import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'dartrofit_generator.dart';

Builder serviceBuilder(BuilderOptions options) =>
    SharedPartBuilder([ServiceGenerator()], 'service');
