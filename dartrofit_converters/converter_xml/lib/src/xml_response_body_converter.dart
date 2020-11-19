import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart';

class XmlResponseBodyConverter implements Converter<ResponseBody, XmlDocument> {
  @override
  XmlDocument convert(ResponseBody value) => XmlDocument.parse(value.string);
}
