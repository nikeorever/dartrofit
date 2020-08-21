import 'dart:async';

import 'package:async/async.dart';
import 'package:dartrofit/src/call.dart';
import 'package:dartrofit/src/call_adapter.dart';
import 'package:dartrofit/src/response.dart';
import 'package:dartrofit/src/type_value.dart';
import 'package:wedzera/core.dart';

class BuiltInAdapterFactory extends CallAdapterFactory {
  @override
  CallAdapter<R, T> get<R, T>(TypeValue returnType) {
    if (returnType is ParameterizedTypeValue) {
      if (_isDartAsyncFuture(returnType)) {
        final upperBoundAtIndex0 = returnType.upperBoundAtIndex0;

        if (TypeValue.isDartrofitResponse(upperBoundAtIndex0)) {
          return FutureCallAdapter<R>() as CallAdapter<R, T>;
        } else {
          return FutureBodyCallAdapter<R>() as CallAdapter<R, T>;
        }
      }

      if (_isAsyncCancelableOperation(returnType)) {
        final upperBoundAtIndex0 = returnType.upperBoundAtIndex0;

        if (TypeValue.isDartrofitResponse(upperBoundAtIndex0)) {
          return CancelableOperationCallAdapter<R>() as CallAdapter<R, T>;
        } else {
          return CancelableOperationBodyCallAdapter<R>() as CallAdapter<R, T>;
        }
      }

      if (_isDartrofitCall(returnType)) {
        final upperBoundAtIndex0 = returnType.upperBoundAtIndex0;
        if (TypeValue.isDartrofitResponse(upperBoundAtIndex0)) {
          throw UnsupportedError(
              'not support Call<Response<T>>, should Call<T>');
        }
        return IdentityCallAdapter<R>() as CallAdapter<R, T>;
      }
    }
    return null;
  }

  static bool _isDartAsyncFuture(ParameterizedTypeValue returnType) {
    return returnType.name == 'Future' &&
        returnType.libraryName == 'dart.async';
  }

  static bool _isAsyncCancelableOperation(ParameterizedTypeValue returnType) {
    return returnType.name == 'CancelableOperation' &&
        returnType.libraryName == 'async';
  }

  static bool _isDartrofitCall(ParameterizedTypeValue returnType) {
    return returnType.name == 'Call' && returnType.libraryName == 'dartrofit';
  }
}

class FutureCallAdapter<R> implements CallAdapter<R, Future<Response<R>>> {
  @override
  Future<Response<R>> adapt(Call<R> call) {
    call = call.clone();

    final completer = Completer<Response<R>>();
    call.enqueue((call, response) {
      completer.complete(response);
    }, (call, errorAndStacktrace) {
      completer.completeError(
          errorAndStacktrace.error, errorAndStacktrace.stackTrace);
    });
    return completer.future;
  }
}

class FutureBodyCallAdapter<R> implements CallAdapter<R, Future<R>> {
  @override
  Future<R> adapt(Call<R> call) {
    call = call.clone();

    final completer = Completer<R>();
    call.enqueue((call, response) {
      completer.complete(response.body);
    }, (call, errorAndStacktrace) {
      completer.completeError(
          errorAndStacktrace.error, errorAndStacktrace.stackTrace);
    });
    return completer.future;
  }
}

class CancelableOperationCallAdapter<R>
    implements CallAdapter<R, CancelableOperation<Response<R>>> {
  @override
  CancelableOperation<Response<R>> adapt(Call<R> call) {
    call = call.clone();

    final completer = Completer<Response<R>>();
    call.enqueue((call, response) {
      completer.complete(response);
    }, (call, errorAndStacktrace) {
      completer.completeError(
          errorAndStacktrace.error, errorAndStacktrace.stackTrace);
    });

    return CancelableOperation<Response<R>>.fromFuture(completer.future);
  }
}

class CancelableOperationBodyCallAdapter<R>
    implements CallAdapter<R, CancelableOperation<R>> {
  @override
  CancelableOperation<R> adapt(Call<R> call) {
    call = call.clone();

    final completer = Completer<R>();
    call.enqueue((call, response) {
      completer.complete(response.body);
    }, (call, errorAndStacktrace) {
      completer.completeError(
          errorAndStacktrace.error, errorAndStacktrace.stackTrace);
    });
    return CancelableOperation<R>.fromFuture(completer.future);
  }
}

class IdentityCallAdapter<R> implements CallAdapter<R, Call<R>> {
  @override
  Call<R> adapt(Call<R> call) {
    return call.clone();
  }
}
