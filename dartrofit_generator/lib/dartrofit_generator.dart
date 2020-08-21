import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartrofit/dartrofit.dart' as dartrofit;
import 'package:dartrofit_generator/src/webapi_source_class.dart';
import 'package:source_gen/source_gen.dart';

class WebApiGenerator extends GeneratorForAnnotation<dartrofit.WebApi> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return WebApiSourceClass(element as ClassElement).generatedCode();
  }
}