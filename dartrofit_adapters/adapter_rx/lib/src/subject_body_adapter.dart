import 'package:dartrofit/dartrofit.dart' as dartrofit;
import 'package:rxdart/rxdart.dart';
import 'package:wedzera/core.dart' as wedzera;

/// Using [BehaviorSubject]
class SubjectBodyAdapter<R> implements dartrofit.CallAdapter<R, Subject<R>> {
  @override
  Subject<R> adapt(dartrofit.Call<R> call) {
    call = call.clone();

    final subject = BehaviorSubject<R>(onCancel: call.cancel);
    call.enqueue(
        (_, dartrofit.Response<R> response) => subject.add(response.body),
        (_, wedzera.ErrorAndStacktrace errorAndStacktrace) => subject
            .addError(errorAndStacktrace.error, errorAndStacktrace.stackTrace));
    return subject;
  }
}
