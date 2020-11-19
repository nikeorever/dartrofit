import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart';
import 'package:http_parser/http_parser.dart';

class XmlRequestBodyConverter implements Converter<XmlNode, RequestBody> {
  static final MediaType _mediaType =
      MediaType.parse('application/xml; charset=utf-8');

  @override
  RequestBody convert(XmlNode value) =>
      RequestBody.string(_mediaType, value.toXmlString());
}
