import 'request_body.dart';
import 'response_body.dart';
import 'type_value.dart';

abstract class Converter<F, T> {
  T convert(F value);
}

abstract class ConverterFactory {
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) =>
      null;

  Converter<Object, RequestBody> requestBodyConverter(Object value) => null;
}
