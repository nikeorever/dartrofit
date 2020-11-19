import 'package:dartrofit/dartrofit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedzera/core.dart' as wedzera_core;

class SubjectResponseBodyCallAdapter<R>
    implements CallAdapter<R, Subject<Response<R>>> {
  @override
  Subject<Response<R>> adapt(Call<R> call) {
    call = call.clone();

    final subject = BehaviorSubject<Response<R>>(onCancel: call.cancel);
    call.enqueue((_, Response<R> response) {
      subject.add(response);
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
