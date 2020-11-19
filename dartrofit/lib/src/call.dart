import 'package:dartrofit/src/converter.dart';
import 'package:dartrofit/src/request_factory.dart';
import 'package:dartrofit/src/response.dart';
import 'package:dartrofit/src/response_body.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:wedzera/core.dart';

typedef OnResponse<T> = void Function(Call<T>, Response<T>);
typedef OnFailure<T> = void Function(Call<T>, ErrorAndStacktrace);

abstract class Call<T> {
  factory Call(RequestFactory requestFactory, List<Object> args,
          Converter<ResponseBody, T> responseConverter) =>
      _HttpCall(requestFactory, args, responseConverter);

  /// Asynchronously send the request
  void enqueue(OnResponse<T> onResponse, OnFailure<T> onFailure);

  /// Cancel this call.
  void cancel();

  /// True if [cancel] was called.
  bool isCanceled();

  Call<T> clone();
}

class _HttpCall<T> implements Call<T> {
  final RequestFactory requestFactory;
  final List<Object> args;
  final Converter<ResponseBody, T> responseConverter;

  CancelableOperation<http.Response> operation;
  bool executed = false;
  bool canceled = false;

  _HttpCall(this.requestFactory, this.args, this.responseConverter)
      : assert(requestFactory != null),
        assert(responseConverter != null);

  @override
  void cancel() {
    canceled = true;
    operation?.cancel();
  }

  @override
  void enqueue(onResponse, onFailure) {
    if (executed) throw StateError('Already executed.');
    executed = true;

    final httpResponseFuture = _sendInternal();
    operation =
        CancelableOperation<http.Response>.fromFuture(httpResponseFuture);
    // how to cancel request?

    if (canceled) {
      operation.cancel();
    }

    operation.value.then((http.Response response) {
      onResponse(this, _parseResponse(response));
    }).catchError((dynamic error, StackTrace stackTrace) {
      onFailure(this, ErrorAndStacktrace(error, stackTrace));
    }, test: (error) => true);
  }

  Future<http.Response> _sendInternal() async {
    final streamResponse = await requestFactory.create(args).send();
    return http.Response.fromStream(streamResponse);
  }

  Response<T> _parseResponse(http.Response rawResponse) {
    final rawBody = ResponseBody.fromResponse(rawResponse);

    final code = rawResponse.statusCode;
    if (code < 200 || code >= 300) {
      return Response.error(rawBody, rawResponse);
    }

    if (code == 204 || code == 205) {
      return Response.success(null, rawResponse);
    }

    final body = responseConverter.convert(rawBody);
    return Response.success(body, rawResponse);
  }

  @override
  bool isCanceled() => operation?.isCanceled;

  @override
  Call<T> clone() {
    return _HttpCall<T>(requestFactory, args, responseConverter);
  }
}
