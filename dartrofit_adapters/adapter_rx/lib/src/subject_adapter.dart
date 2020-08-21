import 'package:dartrofit/dartrofit.dart' as dartrofit;
import 'package:rxdart/rxdart.dart';
import 'package:wedzera/core.dart' as wedzera;

/// Using [BehaviorSubject]
class SubjectAdapter<R>
    implements dartrofit.CallAdapter<R, Subject<dartrofit.Response<R>>> {
  @override
  Subject<dartrofit.Response<R>> adapt(dartrofit.Call<R> call) {
    call = call.clone();

    final subject =
        BehaviorSubject<dartrofit.Response<R>>(onCancel: call.cancel);
    call.enqueue(
        (_, dartrofit.Response<R> response) => subject.add(response),
        (_, wedzera.ErrorAndStacktrace errorAndStacktrace) => subject.addError(
            errorAndStacktrace.error, errorAndStacktrace.stackTrace));
    return subject;
  }
}
