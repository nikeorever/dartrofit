import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartrofit/dartrofit.dart' as dartrofit;
import 'package:source_gen/source_gen.dart';

import 'src/service_source_class.dart';

class ServiceGenerator extends GeneratorForAnnotation<dartrofit.Service> {
  @override
  String generateForAnnotatedElement(
          Element element, ConstantReader annotation, BuildStep buildStep) =>
      ServiceSourceClass(element as ClassElement).generatedCode();
}
