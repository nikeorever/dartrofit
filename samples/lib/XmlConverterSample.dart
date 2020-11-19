import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:quiver/core.dart';
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';
import 'http.dart';

part 'XmlConverterSample.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @POST('books/v1/postXml')
  Future<Optional<ResponseBody>> postXml1(@Body() XmlNode body);

  @POST('books/v1/postInvalidXml')
  Future<Optional<XmlDocument>> postXml2(@Body() XmlNode body);

  @POST('books/v1/postXml')
  Future<XmlDocument> postXml3(@Body() XmlNode body);
}

void main() async {
  final api = Api(dartrofit);

  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  builder.element('bookshelf', nest: () {
    builder.element('book', nest: () {
      builder.element('title', nest: () {
        builder.attribute('lang', 'english');
        builder.text('Growing a Language');
      });
      builder.element('price', nest: 29.99);
    });
    builder.element('book', nest: () {
      builder.element('title', nest: () {
        builder.attribute('lang', 'english');
        builder.text('Learning XML');
      });
      builder.element('price', nest: 39.95);
    });
    builder.element('price', nest: 132.00);
  });
  final bookshelfXml = builder.buildDocument();

  final optional = await api.postXml2(bookshelfXml);
  optional.transformNullable((value) => value.toXmlString()).ifPresent(print);

  final xmlDocument = await api.postXml3(bookshelfXml);
  print(xmlDocument.toXmlString());
}
