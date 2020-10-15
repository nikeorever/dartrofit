# Dartrofit_converter_json for dartrofit

[![pub package](https://img.shields.io/badge/pub-1.0.0-blueviolet.svg)](https://pub.dev/packages/dartrofit_converter_json)

The Json support for dartrofit

First, depend on it
```yaml
dependencies:
    dartrofit_converter_json: latest version
```
Then, add it to `Dartrofit` configuration
```dart
final dartrofit = Dartrofit(Uri.parse('http://0.0.0.0:7777/'))
  ..converterFactories.add(JsonConverterFactory());
```

## Usage
All types accepted by `jsonEncode()` in `json` can be annotated with `@Body()`.
```dart
@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @POST('books/v1/postBooks')
  Future<Response<Map<String, dynamic>>> postBookNumber(@Body() Map<String, dynamic> body);
}
```
