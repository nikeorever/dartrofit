import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:quiver/core.dart';
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart' as xml;
import 'http.dart';

part 'XmlConverterSample.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @POST('books/v1/postXml')
  Future<Optional<ResponseBody>> postXml1(@Body() xml.XmlNode body);

  @POST('books/v1/postXml')
  Future<Optional<xml.XmlDocument>> postXml2(@Body() xml.XmlNode body);

  @POST('books/v1/postXml')
  Future<xml.XmlDocument> postXml3(@Body() xml.XmlNode body);
}

class User {
  final int id;
  final String name;

  const User(this.id, this.name);

  String toJson() {
    return json.encode({'id': id, 'name': name});
  }
}

void main() async {
  final api = Api(dartrofit);

  final builder = xml.XmlBuilder();
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
  final bookshelfXml = builder.build();

  var opt = await api.postXml1(bookshelfXml);

  opt.ifPresent((body) {
    print(body.string);
  });
}
