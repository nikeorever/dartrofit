# The Service code generator for [Dartrofit](https://pub.dev/packages/dartrofit)

[![pub package](https://img.shields.io/badge/pub-1.1.0-blueviolet.svg)](https://pub.dev/packages/dartrofit_converter_xml)

Generate an implementation for the *Service interface* annotated with `@Service()` or `@service`.

## Example
Given a library *my_service.dart* with a `MyService` class annotated with @Service():
```dart
import 'package:dartrofit/dartrofit.dart';

part 'my_service.g.dart';

@Service()
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @GET('book')
  Future<Response<ResponseBody>> getBook(@Query('id') String id);
}
```
Building creates the corresponding part *my_service.g.dart*:

For Dart
``` shell script
pub run build_runner build
```
For Flutter
``` shell script
flutter pub run build_runner build
```

## Download

```yaml
dev_dependencies:
  build_runner: ^1.10.1
  build_verify: ^1.1.1
  dartrofit_generator: ^1.1.0
```
