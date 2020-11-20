import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:wedzera/collection.dart';
import 'package:wedzera/core.dart';

import '../dart_types.dart';
import '../element_annotations.dart';
import '../fixes.dart';
import 'parameter_visitor.dart';

class ClassVisitor extends SimpleElementVisitor<dynamic> {
  Set<Method> methods;
  final errors = <GeneratorError>[];

  final ParsedLibraryResult parsedLibrary;

  ClassVisitor(this.parsedLibrary);

  @override
  Object visitMethodElement(MethodElement element) {
    if (element.isAbstract) {
      final parameterVisitor = ParameterVisitor(parsedLibrary)
        ..requiredParameters = <Parameter>{}
        ..optionalParameters = <Parameter>{};
      element.visitChildren(parameterVisitor);

      // collect parameter error
      errors.addAll(parameterVisitor.errors);

      final method = Method((b) => b
        ..returns = refer(returnTypeWithPrefix(element))
        ..name = element.name
        ..requiredParameters.addAll(parameterVisitor.requiredParameters)
        ..optionalParameters.addAll(parameterVisitor.optionalParameters)
        ..body = Code(_bodyCode(element, parameterVisitor))
        ..annotations.addAll([const CodeExpression(Code('override'))]));

      methods.add(method);
    }
    return super.visitMethodElement(element);
  }

  String returnTypeWithPrefix(MethodElement element) {
    final type = DartTypes.getName(element.returnType);
    final isFunctionType = type.contains('(');
    // The [type] plus any import prefix.
    String typeWithPrefix() {
      final typeFromAst = (parsedLibrary.getElementDeclaration(element).node
                  as MethodDeclaration)
              ?.returnType
              ?.toSource() ??
          'dynamic';

      final typeFromElement = type;

      // If the type is a function, we can't use the element result; it is
      // formatted incorrectly.
      if (isFunctionType) return typeFromAst;

      // If the type does not have an import prefix, prefer the element result.
      // It handles inherited generics correctly.
      if (!typeFromAst.contains('.')) return typeFromElement;

      return typeFromAst;
    }

    return typeWithPrefix();
  }

  String _bodyCode(MethodElement element, ParameterVisitor visitor) {
    // e.g: Subject<Response<Map<String, dynamic>>>
    final returnType = element.returnType;

    final returnTypeFullName = returnTypeWithPrefix(element);
    String dataTypeFullName;
    if (DartTypes.isParameterizedType(returnType)) {
      // check
      final innerType =
          _getParameterUpperBound(0, returnType as ParameterizedType);
      if (DartTypes.isDartrofitResponse(innerType)) {
        //R<Response<T>>

        var openAngleCount = 0;
        var secondOpenAngleIndex = 0;

        for (var i = 0; i < returnTypeFullName.length; i++) {
          final c = returnTypeFullName[i];
          if ('<' == c) {
            if (openAngleCount == 1) {
              secondOpenAngleIndex = i;
              break;
            }
            openAngleCount++;
          }
        }
        dataTypeFullName = returnTypeFullName.substring(
            secondOpenAngleIndex + 1, returnTypeFullName.length - 2);
      } else {
        //R<T>
        dataTypeFullName = returnTypeFullName.substring(
            returnTypeFullName.indexOf('<') + 1, returnTypeFullName.length - 1);
      }
    } else {
      throw InvalidGenerationSourceError(
          'The return type of the method must be a parameterized type; '
          '(${element.location})');
    }

    final buffer = StringBuffer();
    _recursiveTypeValuesCodes(returnType, buffer, 0, null);
    final typeValueCodes = buffer.toString();

    // headers
    ParameterInfo headersInfo;
    final headersAnnotation = element.metadata
        .firstWhere(ElementAnnotations.isDartrofitHeaders, orElse: () => null);
    final headersValueStr = headersAnnotation
        ?.computeConstantValue()
        ?.getField('headers')
        ?.toListValue()
        ?.map((dartObject) => "'${dartObject.toStringValue()}'")
        ?.join(', ');
    if (!headersValueStr.isNullOrEmpty()) {
      headersInfo = ParameterInfo('[$headersValueStr]', 'HeadersHandler()');
    }

    // Multipart
    final isMultipart =
        element.metadata.any(ElementAnnotations.isDartrofitMultipart);

    // FormUrlEncoded
    final isFormUrlEncoded =
        element.metadata.any(ElementAnnotations.isDartrofitFormUrlEncoded);

    String code;
    for (var annotation in element.metadata) {
      if (ElementAnnotations.isDartrofitGet(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'GET'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
        
        final args = <Object>[$parameterNamesStringBuffer];
          
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      } else if (ElementAnnotations.isDartrofitPost(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);
        if (isFormUrlEncoded) {
          _appendParameterHandlersAndNamesOfFields(visitor,
              parameterHandlersStringBuffer, parameterNamesStringBuffer);
        } else {
          _appendParameterHandlersAndNamesOfBody(visitor,
              parameterHandlersStringBuffer, parameterNamesStringBuffer);
        }

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
      
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'POST'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
        
        final args = <Object>[$parameterNamesStringBuffer];
        
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      } else if (ElementAnnotations.isDartrofitPut(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);
        if (isFormUrlEncoded) {
          _appendParameterHandlersAndNamesOfFields(visitor,
              parameterHandlersStringBuffer, parameterNamesStringBuffer);
        } else {
          _appendParameterHandlersAndNamesOfBody(visitor,
              parameterHandlersStringBuffer, parameterNamesStringBuffer);
        }

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
      
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'PUT'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
        
        final args = <Object>[$parameterNamesStringBuffer];
        
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      } else if (ElementAnnotations.isDartrofitPatch(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);
        if (isFormUrlEncoded) {
          _appendParameterHandlersAndNamesOfFields(visitor,
              parameterHandlersStringBuffer, parameterNamesStringBuffer);
        } else {
          _appendParameterHandlersAndNamesOfBody(visitor,
              parameterHandlersStringBuffer, parameterNamesStringBuffer);
        }

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
      
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'PATCH'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
        
        final args = <Object>[$parameterNamesStringBuffer];
        
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      } else if (ElementAnnotations.isDartrofitDelete(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
      
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'DELETE'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
          
        final args = <Object>[$parameterNamesStringBuffer];
        
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      } else if (ElementAnnotations.isDartrofitHead(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
      
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'HEAD'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
        
        final args = <Object>[$parameterNamesStringBuffer];
        
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      } else if (ElementAnnotations.isDartrofitOptions(annotation)) {
        var relativeUrl = annotation
            .computeConstantValue()
            ?.getField('relativeUrl')
            ?.toStringValue();
        relativeUrl = relativeUrl == null ? null : "'$relativeUrl'";

        final parameterHandlersStringBuffer = StringBuffer();
        final parameterNamesStringBuffer = StringBuffer();

        // url order takes precedence over path
        _appendParameterHandlersAndNames(
            [visitor.urlInfo, ...visitor.pathInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfQueries(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        _appendParameterHandlersAndNames(
            [headersInfo, ...visitor.headerInfos, ...visitor.headerMapInfos],
            parameterHandlersStringBuffer,
            parameterNamesStringBuffer);

        _appendParameterHandlersAndNamesOfParts(
            visitor, parameterHandlersStringBuffer, parameterNamesStringBuffer);

        code = '''
      
        $typeValueCodes
        
        final annotationInfo = AnnotationInfo((b) => b
          ..httpMethod = 'OPTIONS'
          ..relativeUrl = $relativeUrl
          ..isMultipart = $isMultipart
          ..isFormEncoded = $isFormUrlEncoded
          ..parameterHandlers.addAll([$parameterHandlersStringBuffer])
          ..returnType = ptv0);
        
        final args = <Object>[$parameterNamesStringBuffer];
        
        return dartrofit.parseAnnotation<$dataTypeFullName, $returnTypeFullName>(annotationInfo).invoke(args);
        ''';
      }
    }
    return code;
  }

  static void _recursiveTypeValuesCodes(DartType type, StringBuffer buffer,
      int variableSuffix, String parameterizedVariableName) {
    final libraryName = DartTypes.getLibraryName(type);
    final name = type.element.name;
    final displayName = type.getDisplayString();
    if (DartTypes.isParameterizedType(type)) {
      final varName = 'ptv$variableSuffix';
      final code =
          // ignore: lines_longer_than_80_chars
          "final $varName = ParameterizedTypeValue('$libraryName', '$name', '$displayName');";
      buffer.writeln(code);
      if (!parameterizedVariableName.isNullOrEmpty()) {
        buffer.writeln(
            '$parameterizedVariableName.upperBoundAtIndex0 = $varName;');
      }

      final innerType = _getParameterUpperBound(0, type as ParameterizedType);
      _recursiveTypeValuesCodes(innerType, buffer, ++variableSuffix, varName);
    } else {
      final varName = 'tv$variableSuffix';
      final code =
          // ignore: lines_longer_than_80_chars
          "final $varName = TypeValue('$libraryName', '$name', '$displayName');";
      buffer.writeln(code);
      if (!parameterizedVariableName.isNullOrEmpty()) {
        buffer.writeln(
            '$parameterizedVariableName.upperBoundAtIndex0 = $varName;');
      }
    }
  }

  static void _appendParameterHandlersAndNamesOfQueries(
      ParameterVisitor visitor,
      StringBuffer parameterHandlersStringBuffer,
      StringBuffer parameterNamesStringBuffer) {
    _appendParameterHandlersAndNames(visitor.queryInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
    _appendParameterHandlersAndNames(visitor.queryMapInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
  }

  static void _appendParameterHandlersAndNamesOfBody(
      ParameterVisitor visitor,
      StringBuffer parameterHandlersStringBuffer,
      StringBuffer parameterNamesStringBuffer) {
    _appendParameterHandlersAndNames([visitor.bodyInfo],
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
  }

  static void _appendParameterHandlersAndNamesOfFields(
      ParameterVisitor visitor,
      StringBuffer parameterHandlersStringBuffer,
      StringBuffer parameterNamesStringBuffer) {
    _appendParameterHandlersAndNames(visitor.fieldInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
    _appendParameterHandlersAndNames(visitor.fieldMapInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
  }

  static void _appendParameterHandlersAndNamesOfParts(
      ParameterVisitor visitor,
      StringBuffer parameterHandlersStringBuffer,
      StringBuffer parameterNamesStringBuffer) {
    _appendParameterHandlersAndNames(visitor.partFieldInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
    _appendParameterHandlersAndNames(visitor.partFieldMapInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
    _appendParameterHandlersAndNames(visitor.partFileInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
    _appendParameterHandlersAndNames(visitor.partFileListInfos,
        parameterHandlersStringBuffer, parameterNamesStringBuffer);
  }

  static void _appendParameterHandlersAndNames(
      List<ParameterInfo> infos,
      StringBuffer parameterHandlersStringBuffer,
      StringBuffer parameterNamesStringBuffer) {
    requireNotNull(parameterHandlersStringBuffer,
        lazyMessage: () => 'parameterHandlersStringBuffer == null');
    requireNotNull(parameterNamesStringBuffer,
        lazyMessage: () => 'parameterNamesStringBuffer == null');
    infos = infos?.where((parameterInfo) => parameterInfo != null)?.toList();
    if (!infos.isNullOrEmpty) {
      for (var info in infos) {
        if (parameterHandlersStringBuffer.isEmpty) {
          parameterHandlersStringBuffer.write(info.parameterHandler);
        } else {
          parameterHandlersStringBuffer.write(', ${info.parameterHandler}');
        }

        if (parameterNamesStringBuffer.isEmpty) {
          parameterNamesStringBuffer.write(info.parameterName);
        } else {
          parameterNamesStringBuffer.write(', ${info.parameterName}');
        }
      }
    }
  }

  static DartType _getParameterUpperBound(int index, ParameterizedType type) {
    final types = type.typeArguments;
    if (index < 0 || index >= types.length) {
      throw ArgumentError(
          'Index $index not in range [0, ${types.length}) for $type');
    }
    return types[index];
  }
}
