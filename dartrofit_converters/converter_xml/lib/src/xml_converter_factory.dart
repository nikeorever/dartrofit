import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http_parser/http_parser.dart';

class XmlConverterFactory extends ConverterFactory {
  @override
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) {
    if (TypeValue.isQuiverOptional(dataType)) {
      final innerType = (dataType as ParameterizedTypeValue).upperBoundAtIndex0;
      if (_isXmlDocument(innerType)) {
        return OptionalConverter<xml.XmlDocument>(XmlDocumentConverter())
            as Converter<ResponseBody, T>;
      }
    }

    if (_isXmlDocument(dataType)) {
      return XmlDocumentConverter() as Converter<ResponseBody, T>;
    }
    return null;
  }

  @override
  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    if (value is xml.XmlNode) return XmlRequestBodyConverter();
    return null;
  }

  static bool _isXmlDocument(TypeValue typeValue) {
    return typeValue.name == 'XmlDocument' &&
        typeValue.libraryName == 'xml.nodes.document';
  }
}

class XmlDocumentConverter implements Converter<ResponseBody, xml.XmlDocument> {
  @override
  xml.XmlDocument convert(ResponseBody value) => xml.XmlDocument.parse(value.string);
}

class XmlRequestBodyConverter implements Converter<xml.XmlNode, RequestBody> {
  static final MediaType _mediaType = MediaType(
      'application', 'xml', {'charset': RequestBody.getEncoding().name});

  @override
  RequestBody convert(xml.XmlNode value) {
    return RequestBody.string(_mediaType, value.toXmlString());
  }
}
