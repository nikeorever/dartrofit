import 'package:dartrofit/dartrofit.dart';
import 'package:rxdart/rxdart.dart';

import 'subject_body_call_adapter.dart';
import 'subject_response_body_call_adapter.dart';

/// A [CallAdapterFactory] which uses rxdart for creating Subjects.
///
/// Adding this class to [Dartrofit] allows you to return an [Subject] from
/// service methods.
class RxDartCallAdapterFactory extends CallAdapterFactory {
  static RxDartCallAdapterFactory _cache;

  factory RxDartCallAdapterFactory() => _cache ?? RxDartCallAdapterFactory._();

  RxDartCallAdapterFactory._();

  @override
  CallAdapter<R, T> get<R, T>(TypeValue returnType) {
    if (returnType is ParameterizedTypeValue) {
      if (_isRxSubject(returnType)) {
        final upperBoundAtIndex0 = returnType.upperBoundAtIndex0;

        if (TypeValue.isDartrofitResponse(upperBoundAtIndex0)) {
          return SubjectResponseBodyCallAdapter<R>() as CallAdapter<R, T>;
        } else {
          return SubjectBodyCallAdapter<R>() as CallAdapter<R, T>;
        }
      }
    }
    return null;
  }

  static bool _isRxSubject(ParameterizedTypeValue returnType) =>
      returnType.name == 'Subject' && returnType.libraryName == 'rxdart';
}
