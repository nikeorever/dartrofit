import 'package:dartrofit/dartrofit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedzera/core.dart' as wedzera_core;

class SubjectBodyCallAdapter<R> implements CallAdapter<R, Subject<R>> {
  @override
  Subject<R> adapt(Call<R> call) {
    call = call.clone();

    final subject = BehaviorSubject<R>(onCancel: call.cancel);
    call.enqueue((_, Response<R> response) {
      subject.add(response.body);
      // ignore: cascade_invocations
      subject.close();
    }, (_, wedzera_core.ErrorAndStacktrace errorAndStacktrace) {
      subject.addError(errorAndStacktrace.error, errorAndStacktrace.stackTrace);
      // ignore: cascade_invocations
      subject.close();
    });
    return subject;
  }
}
