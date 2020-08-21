import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:http_parser/http_parser.dart';

class JsonConverterFactory extends ConverterFactory {
  @override
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) {
    if (TypeValue.isQuiverOptional(dataType)) {
      final innerType = (dataType as ParameterizedTypeValue).upperBoundAtIndex0;

      if (_isDartCoreMap(innerType)) {
        try {
          return OptionalConverter<Map<String, dynamic>>(
              JsonResponseBodyConverter()) as Converter<ResponseBody, T>;
        } catch (e) {
          throw UnsupportedError(
              'You might want to convert to JSON, use Optional<Map<String, dynamic>> instead');
        }
      }
    }

    if (_isDartCoreMap(dataType)) {
      try {
        return JsonResponseBodyConverter() as Converter<ResponseBody, T>;
      } catch (e) {
        throw UnsupportedError(
            'You might want to convert to JSON, use Map<String, dynamic> instead');
      }
    }

    return null;
  }

  static bool _isDartCoreMap(TypeValue typeValue) {
    return typeValue.name == 'Map' && typeValue.libraryName == 'dart.core';
  }

  @override
  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    return JsonRequestBodyConverter();
  }
}

class JsonResponseBodyConverter
    implements Converter<ResponseBody, Map<String, dynamic>> {
  @override
  Map<String, dynamic> convert(ResponseBody value) {
    return jsonDecode(value.string) as Map<String, dynamic>;
  }
}

class JsonRequestBodyConverter implements Converter<Object, RequestBody> {
  static final MediaType _mediaType = MediaType(
      'application', 'json', {'charset': RequestBody.getEncoding().name});

  @override
  RequestBody convert(Object value) {
    final json = jsonEncode(value);
    return RequestBody.string(_mediaType, json);
  }
}
