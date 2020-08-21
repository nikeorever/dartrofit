import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_generator/src/dart_types.dart';
import 'package:dartrofit_generator/src/element_annotations.dart';
import 'package:dartrofit_generator/src/fixes.dart';

class ParameterVisitor extends SimpleElementVisitor {
  final ParsedLibraryResult parsedLibrary;
  final errors = <GeneratorError>[];

  Set<Parameter> requiredParameters;
  Set<Parameter> optionalParameters;

  List<ParameterInfo> queryInfos = <ParameterInfo>[];
  List<ParameterInfo> queryMapInfos = <ParameterInfo>[];

  ParameterInfo bodyInfo;

  List<ParameterInfo> fieldInfos = <ParameterInfo>[];
  List<ParameterInfo> fieldMapInfos = <ParameterInfo>[];

  List<ParameterInfo> headerInfos = <ParameterInfo>[];
  List<ParameterInfo> headerMapInfos = <ParameterInfo>[];

  List<ParameterInfo> partFieldInfos = <ParameterInfo>[];
  List<ParameterInfo> partFieldMapInfos = <ParameterInfo>[];
  List<ParameterInfo> partFileInfos = <ParameterInfo>[];
  List<ParameterInfo> partFileListInfos = <ParameterInfo>[];

  ParameterInfo urlInfo;

  List<ParameterInfo> pathInfos = <ParameterInfo>[];

  ParameterVisitor(this.parsedLibrary);

  @override
  Object visitParameterElement(ParameterElement element) {
    final type = DartTypes.getName(element.type);
    final isFunctionType = type.contains('(');
    // The [type] plus any import prefix.
    String typeWithPrefix() {
      final typeFromAst = (parsedLibrary.getElementDeclaration(element).node
                  as SimpleFormalParameter)
              ?.type
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

    var parameter = Parameter((ParameterBuilder b) => b
      ..type = refer(typeWithPrefix())
      ..annotations.addAll([])
      ..name = element.name);

    if (element.isNotOptional) {
      requiredParameters.add(parameter);
    } else if (element.isOptional) {
      if (element.isOptionalNamed) {
        final builder = parameter.toBuilder();
        builder.named = true;
        parameter = builder.build();
      }
      optionalParameters.add(parameter);
    }

    for (var annotation in element.metadata) {
      if (ElementAnnotations.isDartrofitQuery(annotation)) {
        final name = annotation
            .computeConstantValue()
            ?.getField('name')
            ?.toStringValue();
        final encoded = annotation
            .computeConstantValue()
            ?.getField('encoded')
            ?.toBoolValue();

        final queryInfo =
            ParameterInfo(element.name, "QueryHandler('$name', $encoded)");
        queryInfos.add(queryInfo);
      } else if (ElementAnnotations.isDartrofitQueryMap(annotation)) {
        _checkQueryMapAnnotation(element);

        final encoded = annotation
            .computeConstantValue()
            ?.getField('encoded')
            ?.toBoolValue();

        final queryMapInfo =
            ParameterInfo(element.name, 'QueryMapHandler($encoded)');
        queryMapInfos.add(queryMapInfo);
      } else if (ElementAnnotations.isDartrofitBody(annotation)) {
        _checkBodyAnnotation(element);

        bodyInfo = ParameterInfo(element.name,
            'BodyHandler(dartrofit.requestBodyConverter(${element.name}))');
      } else if (ElementAnnotations.isDartrofitField(annotation)) {
        _checkFieldAnnotation(element);

        final name = annotation
            .computeConstantValue()
            ?.getField('name')
            ?.toStringValue();

        final encoded = annotation
            .computeConstantValue()
            ?.getField('encoded')
            ?.toBoolValue();
        fieldInfos.add(
            ParameterInfo(element.name, "FieldHandler('$name', $encoded)"));
      } else if (ElementAnnotations.isDartrofitFieldMap(annotation)) {
        _checkFieldMapAnnotation(element);

        final encoded = annotation
            .computeConstantValue()
            ?.getField('encoded')
            ?.toBoolValue();
        fieldMapInfos
            .add(ParameterInfo(element.name, 'FieldMapHandler($encoded)'));
      } else if (ElementAnnotations.isDartrofitHeader(annotation)) {
        _checkHeaderAnnotation(element);

        final name = annotation
            .computeConstantValue()
            ?.getField('name')
            ?.toStringValue();
        headerInfos.add(ParameterInfo(element.name, "HeaderHandler('$name')"));
      } else if (ElementAnnotations.isDartrofitHeaderMap(annotation)) {
        _checkHeaderMapAnnotation(element);

        headerMapInfos.add(ParameterInfo(element.name, 'HeaderMapHandler()'));
      } else if (ElementAnnotations.isDartrofitPartField(annotation)) {
        _checkPartFieldAnnotation(element);

        final name = annotation
            .computeConstantValue()
            ?.getField('name')
            ?.toStringValue();
        partFieldInfos
            .add(ParameterInfo(element.name, "PartFieldHandler('$name')"));
      } else if (ElementAnnotations.isDartrofitPartFieldMap(annotation)) {
        _checkPartFieldMapAnnotation(element);

        partFieldMapInfos
            .add(ParameterInfo(element.name, 'PartFieldMapHandler()'));
      } else if (ElementAnnotations.isDartrofitPartFile(annotation)) {
        _checkPartFileAnnotation(element);

        partFileInfos.add(ParameterInfo(element.name, 'PartFileHandler()'));
      } else if (ElementAnnotations.isDartrofitPartFileList(annotation)) {
        _checkPartFileListAnnotation(element);

        partFileListInfos
            .add(ParameterInfo(element.name, 'PartFileListHandler()'));
      } else if (ElementAnnotations.isDartrofitUrl(annotation)) {
        _checkUrlAnnotation(element);

        urlInfo = ParameterInfo(element.name, 'RelativeUrlHandler()');
      } else if (ElementAnnotations.isDartrofitPath(annotation)) {
        _checkPathAnnotation(element);

        final name = annotation
            .computeConstantValue()
            ?.getField('name')
            ?.toStringValue();

        final encoded = annotation
            .computeConstantValue()
            ?.getField('encoded')
            ?.toBoolValue();
        pathInfos
            .add(ParameterInfo(element.name, "PathHandler('$name', $encoded)"));
      }
    }
    return super.visitParameterElement(element);
  }

  void _checkQueryMapAnnotation(ParameterElement element) {
    void addError() {
      errors.add(GeneratorError((b) => b
        ..message =
            '@QueryMap() should be annotated to parameters of type Map<String, dynamic>; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (element.type.isDartCoreMap) {
      final tArgs = (element.type as ParameterizedType).typeArguments;
      if (!tArgs[0].isDartCoreString) addError();
    } else {
      addError();
    }
  }

  void _checkBodyAnnotation(ParameterElement element) {
    if (bodyInfo != null) {
      errors.add(GeneratorError((b) => b
        ..message =
            'Multiple @Body() method annotations found.; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkFieldAnnotation(ParameterElement element) {
    final isFormUrlEncoded = (element.enclosingElement as MethodElement)
        .metadata
        .any(ElementAnnotations.isDartrofitFormUrlEncoded);
    if (!isFormUrlEncoded) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@Field() should be used with @FormUrlEncoded(); (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (!element.type.isDartCoreString) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@Field() should be annotated to String type parameters; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkFieldMapAnnotation(ParameterElement element) {
    final isFormUrlEncoded = (element.enclosingElement as MethodElement)
        .metadata
        .any(ElementAnnotations.isDartrofitFormUrlEncoded);
    if (!isFormUrlEncoded) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@FieldMap() should be used with @FormUrlEncoded(); (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    void addError() {
      errors.add(GeneratorError((b) => b
        ..message =
            '@FieldMap() should be annotated to parameters of type Map<String, String>; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (element.type.isDartCoreMap) {
      final tArgs = (element.type as ParameterizedType).typeArguments;
      if (!tArgs[0].isDartCoreString || !tArgs[1].isDartCoreString) addError();
    } else {
      addError();
    }
  }

  void _checkHeaderAnnotation(ParameterElement element) {
    final errors = <GeneratorError>[];
    if (!element.type.isDartCoreString) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@Header() should be annotated to String type parameters; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkHeaderMapAnnotation(ParameterElement element) {
    void addError() {
      errors.add(GeneratorError((b) => b
        ..message =
            '@HeaderMap() should be annotated to parameters of type Map<String, String>; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (element.type.isDartCoreMap) {
      final tArgs = (element.type as ParameterizedType).typeArguments;
      if (!tArgs[0].isDartCoreString || !tArgs[1].isDartCoreString) addError();
    } else {
      addError();
    }
  }

  void _checkPartFieldAnnotation(ParameterElement element) {
    final isMultipart = (element.enclosingElement as MethodElement)
        .metadata
        .any(ElementAnnotations.isDartrofitMultipart);
    if (!isMultipart) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartField() should be used with @Multipart(); (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (!element.type.isDartCoreString) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartField() should be annotated to String type parameters; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkPartFieldMapAnnotation(ParameterElement element) {
    final isMultipart = (element.enclosingElement as MethodElement)
        .metadata
        .any(ElementAnnotations.isDartrofitMultipart);
    if (!isMultipart) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartFieldMap() should be used with @Multipart(); (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    void addError() {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartFieldMap() should be annotated to parameters of type Map<String, String>; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (element.type.isDartCoreMap) {
      final tArgs = (element.type as ParameterizedType).typeArguments;
      if (!tArgs[0].isDartCoreString || !tArgs[1].isDartCoreString) addError();
    } else {
      addError();
    }
  }

  static bool isHttpMultipartFile(DartType type) {
    final element = type.element;
    if (element == null) {
      return false;
    }
    return element.name == 'MultipartFile' && isHttpCore(element);
  }

  void _checkPartFileAnnotation(ParameterElement element) {
    final isMultipart = (element.enclosingElement as MethodElement)
        .metadata
        .any(ElementAnnotations.isDartrofitMultipart);
    if (!isMultipart) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartFile() should be used with @Multipart(); (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (!isHttpMultipartFile(element.type)) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartFile() should be annotated to parameters of type MultipartFile; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkPartFileListAnnotation(ParameterElement element) {
    final isMultipart = (element.enclosingElement as MethodElement)
        .metadata
        .any(ElementAnnotations.isDartrofitMultipart);
    if (!isMultipart) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartFileList() should be used with @Multipart(); (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (!element.type.isDartCoreList ||
        !isHttpMultipartFile(
            (element.type as ParameterizedType).typeArguments[0])) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@PartFileList() should be annotated to parameters of type List<MultipartFile>; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkUrlAnnotation(ParameterElement element) {
    if (urlInfo != null) {
      errors.add(GeneratorError((b) => b
        ..message =
            'Multiple @Url() method annotations found.; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }

    if (!element.type.isDartCoreString) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@Url() should be annotated to String type parameters; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }

  void _checkPathAnnotation(ParameterElement element) {
    if (!element.type.isDartCoreString) {
      errors.add(GeneratorError((b) => b
        ..message =
            '@Path() should be annotated to String type parameters; (${element.location})'
        ..offset = element.nameOffset
        ..length = element.nameLength
        ..fix = ''));
    }
  }
}

class ParameterInfo {
  final String parameterName;
  final String parameterHandler;

  ParameterInfo(this.parameterName, this.parameterHandler)
      : assert(parameterName != null),
        assert(parameterHandler != null);
}
