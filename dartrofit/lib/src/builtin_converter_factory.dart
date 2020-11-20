import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:quiver/core.dart';

import 'converter.dart';
import 'request_body.dart';
import 'response_body.dart';
import 'type_value.dart';

class BuiltInConvertFactory extends ConverterFactory {
  @override
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) {
    if (TypeValue.isQuiverOptional(dataType)) {
      final innerType = (dataType as ParameterizedTypeValue).upperBoundAtIndex0;

      // For Optional<ResponseBody>
      if (TypeValue.isDartrofitResponseBody(innerType)) {
        return OptionalConverter<ResponseBody>(_ResponseBodyConverter())
            as Converter<ResponseBody, T>;
      }

      // For Optional<Map<String, Object>>, Optional<Map<Object, Object>>
      // or Optional<Map<String, dynamic>>
      if (TypeValue.isDartCoreMap(innerType)) {
        try {
          return OptionalConverter<Map<String, Object>>(
              _MapResponseBodyConverter()) as Converter<ResponseBody, T>;
        } catch (e) {
          throw UnsupportedError(
              'You might want to convert ResponseBody to Optional JSONObject, '
              'use Optional<Map<String, Object>>, '
              'Optional<Map<Object, Object>> '
              'or Optional<Map<String, dynamic>> instead');
        }
      }

      // For Optional<List<Object>>
      if (TypeValue.isDartCoreList(innerType)) {
        try {
          return OptionalConverter<List<Object>>(_ListResponseBodyConverter())
              as Converter<ResponseBody, T>;
        } catch (_) {
          throw UnsupportedError(
              'You might want to convert ResponseBody to Optional JSONArray, '
              'use Optional<List<Object>> instead.');
        }
      }
    }

    // For ResponseBody
    if (TypeValue.isDartrofitResponseBody(dataType)) {
      return _ResponseBodyConverter() as Converter<ResponseBody, T>;
    }

    // For Map<String, Object>, Map<Object, Object> or Map<String, dynamic>
    if (TypeValue.isDartCoreMap(dataType)) {
      try {
        return _MapResponseBodyConverter() as Converter<ResponseBody, T>;
      } catch (_) {
        throw UnsupportedError(
            'You might want to convert ResponseBody to JSONObject, use '
            'Map<String, Object>, Map<Object, Object> '
            'or Map<String, dynamic> instead');
      }
    }

    // For List<Object>
    if (TypeValue.isDartCoreList(dataType)) {
      try {
        return _ListResponseBodyConverter() as Converter<ResponseBody, T>;
      } catch (_) {
        throw UnsupportedError(
            'You might want to convert ResponseBody to JSONArray, '
            'use List<Object> instead.');
      }
    }

    return null;
  }

  @override
  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    if (value is RequestBody) return _RequestBodyConverter();
    return JsonRequestBodyConverter();
  }
}

class _ResponseBodyConverter implements Converter<ResponseBody, ResponseBody> {
  @override
  ResponseBody convert(ResponseBody value) => value;
}

class OptionalConverter<T> implements Converter<ResponseBody, Optional<T>> {
  final Converter<ResponseBody, T> delegate;

  OptionalConverter(this.delegate);

  @override
  Optional<T> convert(ResponseBody value) =>
      Optional.fromNullable(delegate.convert(value));
}

class _MapResponseBodyConverter
    implements Converter<ResponseBody, Map<String, Object>> {
  @override
  Map<String, Object> convert(ResponseBody value) =>
      jsonDecode(value.string) as Map<String, Object>;
}

class _ListResponseBodyConverter
    implements Converter<ResponseBody, List<Object>> {
  @override
  List<Object> convert(ResponseBody value) =>
      jsonDecode(value.string) as List<Object>;
}

class _RequestBodyConverter implements Converter<RequestBody, RequestBody> {
  @override
  RequestBody convert(RequestBody value) => value;
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
