import 'call.dart';
import 'type_value.dart';

abstract class CallAdapter<R, T> {
  T adapt(Call<R> call);
}

abstract class CallAdapterFactory {
  CallAdapter<R, T> get<R, T>(TypeValue returnType);
}
