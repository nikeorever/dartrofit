import 'package:build/build.dart';
import 'package:dartrofit_generator/dartrofit_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder webApiBuilder(BuilderOptions options) =>
    SharedPartBuilder([WebApiGenerator()], 'web_api');

