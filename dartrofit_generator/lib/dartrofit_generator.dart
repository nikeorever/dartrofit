import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartrofit/dartrofit.dart' as dartrofit;
import 'package:source_gen/source_gen.dart';

import 'src/service_source_class.dart';
import 'src/webapi_source_class.dart';

@Deprecated('use ServiceGenerator instead.')
class WebApiGenerator extends GeneratorForAnnotation<dartrofit.WebApi> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return WebApiSourceClass(element as ClassElement).generatedCode();
  }
}

class ServiceGenerator extends GeneratorForAnnotation<dartrofit.Service> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return ServiceSourceClass(element as ClassElement).generatedCode();
  }
}
