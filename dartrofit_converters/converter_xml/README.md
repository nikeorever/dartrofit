# Dartrofit_converter_xml for dartrofit

[![pub package](https://img.shields.io/badge/pub-1.0.0-blueviolet.svg)](https://pub.dev/packages/dartrofit_converter_xml)

The Xml support for dartrofit

First, depend on it
```yaml
dependencies:
    dartrofit_converter_xml: latest version
```
Then, add it to `Dartrofit` configuration
```dart
final dartrofit = Dartrofit(Uri.parse('http://0.0.0.0:7777/'))
  ..converterFactories.add(XmlConverterFactory());
```

## Usage
```dart
import 'package:xml/xml.dart' as xml;

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @POST('books/v1/postBooks')
  Future<Optional<xml.Document>> postBooks(@Body() xml.XmlNode body);
}
```
