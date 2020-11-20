# XML Converter For [Dartrofit](https://pub.dev/packages/dartrofit)

[![pub package](https://img.shields.io/badge/pub-1.1.0-blueviolet.svg)](https://pub.dev/packages/dartrofit_converter_xml)

A Converter which uses [xml](https://pub.dev/packages/xml) for XML serialization.

## Example
```dart
import 'package:dartrofit/dartrofit.dart';
import 'package:quiver/core.dart';
import 'package:xml/xml.dart' as xml;

part 'my_service.g.dart';

@Service()
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @GET('bookshelf')
  Future<Response<xml.XmlDocument>> getBookshelf1();

  @GET('bookshelf')
  Future<Response<Optional<xml.XmlDocument>>> getBookshelf2();

  @GET('bookshelf')
  Future<xml.XmlDocument> getBookshelf3();

  @GET('bookshelf')
  Future<Optional<xml.XmlDocument>> getBookshelf4();

  @POST('postBookshelf')
  Future<Response<Map<String, Object>>> postBookshelf(@Body() xml.XmlNode bookshelf);
}
```

## Download

```yaml
dependencies:
  dartrofit_converter_xml: ^1.1.0
```
