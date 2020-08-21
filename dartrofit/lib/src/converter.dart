import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit/src/response_body.dart';
import 'package:dartrofit/src/type_value.dart';

abstract class Converter<F, T> {
  T convert(F value);
}

abstract class ConverterFactory {
  Converter<ResponseBody, T> responseBodyConverter<T>(TypeValue dataType) {
    return null;
  }

  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    return null;
  }
}
