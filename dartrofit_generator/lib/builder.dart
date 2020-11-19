import 'package:build/build.dart';
import 'package:dartrofit_generator/dartrofit_generator.dart';
import 'package:source_gen/source_gen.dart';

@Deprecated('use serviceBuilder instead.')
Builder webApiBuilder(BuilderOptions options) =>
    SharedPartBuilder([WebApiGenerator()], 'web_api');

Builder serviceBuilder(BuilderOptions options) =>
    SharedPartBuilder([ServiceGenerator()], 'service');
