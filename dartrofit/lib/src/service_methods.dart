import 'call.dart';
import 'call_adapter.dart';
import 'converter.dart';
import 'request_factory.dart';
import 'response_body.dart';

abstract class HttpServiceMethod<ResponseT, ReturnT> {
  final RequestFactory requestFactory;
  final Converter<ResponseBody, ResponseT> converter;

  HttpServiceMethod(this.requestFactory, this.converter);

  ReturnT invoke(List<Object> args) {
    final call = Call<ResponseT>(requestFactory, args, converter);
    return adapt(call);
  }

  ReturnT adapt(Call<ResponseT> future);
}

class CallAdapted<ResponseT, ReturnT>
    extends HttpServiceMethod<ResponseT, ReturnT> {
  final CallAdapter<ResponseT, ReturnT> adapter;

  CallAdapted(RequestFactory requestFactory, this.adapter,
      Converter<ResponseBody, ResponseT> converter)
      : super(requestFactory, converter);

  @override
  ReturnT adapt(Call<ResponseT> future) => adapter.adapt(future);
}
