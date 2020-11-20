import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:quiver/iterables.dart';
import 'package:source_gen/source_gen.dart';

import 'dart_types.dart';
import 'element_annotations.dart';
import 'fixes.dart';
import 'visitors/class_visitor.dart';

part 'service_source_class.g.dart';

const String _importWithSingleQuotes =
    "import 'package:dartrofit/dartrofit.dart'";
const String _importWithDoubleQuotes =
    'import "package:dartrofit/dartrofit.dart"';

abstract class ServiceSourceClass
    implements Built<ServiceSourceClass, ServiceSourceClassBuilder> {
  ClassElement get element;

  factory ServiceSourceClass(ClassElement element) =>
      _$ServiceSourceClass._(element: element);

  ServiceSourceClass._();

  @memoized
  ParsedLibraryResult get parsedLibrary =>
      element.library.session.getParsedLibraryByElement(element.library);

  @memoized
  String get name => element.name;

  @memoized
  String get implName =>
      name.startsWith('_') ? '_\$${name.substring(1)}' : '_\$$name';

  @memoized
  BuiltList<String> get genericParameters =>
      BuiltList<String>(element.typeParameters.map<String>((e) => e.name));

  @memoized
  bool get isAbstract => element.isAbstract;

  @memoized
  ClassDeclaration get classDeclaration =>
      parsedLibrary.getElementDeclaration(element).node as ClassDeclaration;

  @memoized
  String get source =>
      element.library.definingCompilationUnit.source.contents.data;

  @memoized
  String get partStatement {
    final fileName = element.library.source.shortName.replaceAll('.dart', '');
    return "part '$fileName.g.dart';";
  }

  @memoized
  bool get extendsIsAllowed {
    for (var supertype in [
      element.supertype,
      ...element.supertype.element.allSupertypes
    ]) {
      if (DartTypes.getName(supertype) == 'Object') continue;

      // Base class must be not abstract.
      if (supertype.element.isAbstract) return false;
    }
    return true;
  }

  @memoized
  bool get fieldIsAllowed {
    // must have no abstract getters
    if (element.accessors.any((accessor) =>
        !accessor.isStatic && accessor.isGetter && accessor.isAbstract)) {
      return false;
    }
    return true;
  }

  @memoized
  BuiltList<ConstructorDeclaration> get classConstructors =>
      BuiltList<ConstructorDeclaration>(element.constructors
          .where((ctr) => !ctr.isFactory && !ctr.isSynthetic)
          .map<AstNode>(
              (ctr) => parsedLibrary.getElementDeclaration(ctr).node));

  @memoized
  BuiltList<ConstructorDeclaration> get classFactories =>
      BuiltList<ConstructorDeclaration>(element.constructors
          .where((ctr) => ctr.isFactory)
          .map<AstNode>(
              (factory) => parsedLibrary.getElementDeclaration(factory).node));

  @memoized
  BuiltList<MethodElement> get abstractMethods => BuiltList<MethodElement>(
      element.methods.where((method) => method.isAbstract));

  @memoized
  bool get hasPartStatement {
    final expectedCode = partStatement;
    return source.contains(expectedCode);
  }

  @memoized
  bool get hasDartrofitImportWithShow =>
      source.contains('$_importWithSingleQuotes show') ||
      source.contains('$_importWithDoubleQuotes show');

  @memoized
  bool get hasDartrofitImportWithAs =>
      source.contains('$_importWithSingleQuotes as') ||
      source.contains('$_importWithDoubleQuotes as');

  String get _generics =>
      genericParameters.isEmpty ? '' : '<${genericParameters.join(', ')}>';

  Iterable<GeneratorError> computeErrors() =>
      concat([_checkPart(), _checkClass(), _checkAbstractMethod()]);

  Iterable<GeneratorError> _checkPart() {
    if (hasPartStatement) return [];
    final directives = (classDeclaration.parent as CompilationUnit).directives;

    if (directives.isEmpty) {
      return [
        GeneratorError((b) => b
          ..message = 'Import generated part: $partStatement'
          ..offset = 0
          ..length = 0
          ..fix = '$partStatement\n\n')
      ];
    } else {
      return [
        GeneratorError((b) => b
          ..message = 'Import generated part: $partStatement'
          ..offset = directives.last.offset + directives.last.length
          ..length = 0
          ..fix = '\n\n$partStatement\n\n')
      ];
    }
  }

  Iterable<GeneratorError> _checkClass() {
    final result = <GeneratorError>[];

    if (hasDartrofitImportWithShow) {
      result.add(GeneratorError((b) => b
        ..message = 'Stop using "show" when importing '
            '"package:dartrofit/dartrofit.dart". It prevents the '
            'generated code from finding helper methods.'));
    }

    if (hasDartrofitImportWithAs) {
      result.add(GeneratorError((b) => b
        ..message = 'Stop using "as" when importing '
            '"package:dartrofit/dartrofit.dart". It prevents the generated '
            'code from finding helper methods.'));
    }

    if (!isAbstract) {
      result.add(GeneratorError((b) => b
        ..message = 'Make class abstract'
        ..offset = classDeclaration.offset
        ..length = 0
        ..fix = 'abstract '));
    }

    if (!extendsIsAllowed) {
      result.add(GeneratorError((b) => b
        ..message = 'Stop class extending or implement other abstract class'));
    }

    if (!fieldIsAllowed) {
      result.add(GeneratorError(
          (b) => b..message = 'Stop add abstract getters accessor'));
    }

    // check private constructor
    final expectedCtr = '$name._()';
    if (classConstructors.isEmpty) {
      result.add(GeneratorError((b) => b
        ..message = 'Make class have exactly one construct: $expectedCtr;'
        ..offset = classDeclaration.rightBracket.offset
        ..length = 0
        ..fix = '  $expectedCtr;\n'));
    } else if (classConstructors.length > 1) {
      var found = false;
      for (var ctr in classConstructors) {
        if (ctr.toSource().startsWith(expectedCtr)) {
          found = true;
        } else {
          result.add(GeneratorError((b) => b
            ..message = 'Remove invalid constructor'
            ..offset = ctr.offset
            ..length = ctr.length
            ..fix = ''));
        }
      }
      if (!found) {
        result.add(GeneratorError((b) => b
          ..message = 'Make class exactly one constructor: $expectedCtr'
          ..offset = classDeclaration.rightBracket.offset
          ..length = 0
          ..fix = '  $expectedCtr;\n'));
      }
    } else if (!classConstructors.single.toSource().startsWith(expectedCtr)) {
      result.add(GeneratorError((b) => b
        ..message = 'Make class have exactly one constructor: $expectedCtr'
        ..offset = classConstructors.single.offset
        ..length = classConstructors.single.length
        ..fix = '$expectedCtr;'));
    }

    // check factory constructor
    if (!classFactories
        .any((factory) => factory.toSource().contains('$implName$_generics'))) {
      final exampleFactory =
          'factory $name(Dartrofit dartrofit) = $implName$_generics;';
      result.add(GeneratorError((b) => b
        ..message =
            // ignore: lines_longer_than_80_chars
            'Add a factory so your class can be instantiated. Example:\n\n$exampleFactory'
        ..offset = classDeclaration.rightBracket.offset
        ..length = 0
        ..fix = '  $exampleFactory\n'));
    }
    return result;
  }

  Iterable<GeneratorError> _checkAbstractMethod() {
    final errors = <GeneratorError>[];
    for (var method in abstractMethods) {
      final requestMethodCount = method.metadata
          .where(ElementAnnotations.isDartrofitRequestMethod)
          .length;
      if (requestMethodCount != 1) {
        errors.add(GeneratorError((b) => b
          ..message =
              'Add a request method annotation on ${method.name}, for example: @GET/@POST...'
          ..offset = 0
          ..length = 0
          ..fix = '@GET/@POST ...'));
      }
    }
    return errors;
  }

  String generatedCode() {
    final errors = computeErrors();
    if (errors.isNotEmpty) throw _makeError(errors);

    return _generateImpl();
  }

  String _generateImpl() {
    final implClassName = '$implName$_generics';
    final implClass = Class((b) => b
      ..name = implClassName
      ..extend = refer(name)
      ..fields.addAll([
        Field((b) => b
          ..static = true
          ..type = refer(implClassName)
          ..name = '_instance'),
        Field((b) => b
          ..modifier = FieldModifier.final$
          ..type = refer('Dartrofit')
          ..name = 'dartrofit')
      ])
      ..constructors.addAll([
        Constructor((b) => b
          ..name = '_'
          ..initializers
              .add(refer('super._').call([const CodeExpression(Code(''))]).code)
          ..requiredParameters.add(Parameter((b) => b
            ..toThis = true
            ..name = 'dartrofit'))),
        Constructor((b) => b
          ..requiredParameters.add(Parameter((b) => b
            ..type = refer('Dartrofit')
            ..name = 'dartrofit'))
          ..body = Code('_instance ??= $implClassName._(dartrofit)')
          ..lambda = true
          ..factory = true),
      ])
      ..methods.addAll(_overrideMethodsOf(element)));

    final library = Library((b) => b..body.add(implClass));
    return DartFormatter().format('${library.accept(DartEmitter.scoped())}');
  }

  Iterable<Method> _overrideMethodsOf(Element element) {
    final methods = <Method>{};
    final visitor = ClassVisitor(parsedLibrary)..methods = methods;
    element.visitChildren(visitor);

    final errors = visitor.errors;
    if (errors.isNotEmpty) throw _makeError(errors);

    return methods;
  }

  InvalidGenerationSourceError _makeError(Iterable<GeneratorError> errors) {
    final message =
        StringBuffer('Please make the following changes to use Dartrofit:\n');
    for (var i = 0; i < errors.length; i++) {
      message.write('\n${i + 1}. ${errors.elementAt(i).message}');
    }

    return InvalidGenerationSourceError(message.toString());
  }
}
