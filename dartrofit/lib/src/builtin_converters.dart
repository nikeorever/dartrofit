import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit/src/converter.dart';
import 'package:dartrofit/src/response_body.dart';
import 'package:dartrofit/src/type_value.dart';
import 'package:quiver/core.dart';

class BuiltInConvertFactory extends ConverterFactory {
  @override
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) {
    if (TypeValue.isQuiverOptional(dataType)) {
      final innerType = (dataType as ParameterizedTypeValue).upperBoundAtIndex0;
      if (_isDartrofitResponseBody(innerType)) {
        return OptionalConverter<ResponseBody>(ResponseBodyConverter())
            as Converter<ResponseBody, T>;
      }
    }

    if (_isDartrofitResponseBody(dataType)) {
      return ResponseBodyConverter() as Converter<ResponseBody, T>;
    }

    return null;
  }

  @override
  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    if (value is RequestBody) return RequestBodyConverter();

    return null;
  }

  static bool _isDartrofitResponseBody(TypeValue typeValue) {
    return typeValue.name == 'ResponseBody' &&
        typeValue.libraryName == 'dartrofit';
  }
}

class ResponseBodyConverter implements Converter<ResponseBody, ResponseBody> {
  @override
  ResponseBody convert(ResponseBody value) => value;
}

class OptionalConverter<T> implements Converter<ResponseBody, Optional<T>> {
  final Converter<ResponseBody, T> delegate;

  OptionalConverter(this.delegate);

  @override
  Optional<T> convert(ResponseBody value) {
    return Optional.fromNullable(delegate.convert(value));
  }
}

class RequestBodyConverter implements Converter<RequestBody, RequestBody> {
  @override
  RequestBody convert(RequestBody value) => value;
}
