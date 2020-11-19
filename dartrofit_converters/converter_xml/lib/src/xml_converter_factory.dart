import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart';

import 'xml_request_body_converter.dart';
import 'xml_response_body_converter.dart';

/// A [ConverterFactory] which provides two capabilities:
///
/// 1. Convert [ResponseBody] to [XmlDocument]
/// 2. convert [XmlNode] to [RequestBody].
class XmlConverterFactory extends ConverterFactory {
  static XmlConverterFactory _cache;

  factory XmlConverterFactory() => _cache ?? XmlConverterFactory._();

  XmlConverterFactory._();

  @override
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) {
    if (TypeValue.isQuiverOptional(dataType)) {
      final innerType = (dataType as ParameterizedTypeValue).upperBoundAtIndex0;

      // For Optional<XmlDocument>
      if (_isXmlDocument(innerType)) {
        return OptionalConverter<XmlDocument>(XmlResponseBodyConverter())
            as Converter<ResponseBody, T>;
      }
    }

    // For XmlDocument
    if (_isXmlDocument(dataType)) {
      return XmlResponseBodyConverter() as Converter<ResponseBody, T>;
    }
    return null;
  }

  @override
  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    if (value is XmlNode) return XmlRequestBodyConverter();
    return null;
  }

  static bool _isXmlDocument(TypeValue typeValue) =>
      typeValue.name == 'XmlDocument' && typeValue.libraryName == 'xml';
}
