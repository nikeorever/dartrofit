import 'package:dartrofit/dartrofit.dart';

import 'subject_adapter.dart';
import 'subject_body_adapter.dart';
class SubjectAdaptFactory extends CallAdapterFactory {
  @override
  CallAdapter<R, T> get<R, T>(TypeValue returnType) {
    if (returnType is ParameterizedTypeValue) {
      if (_isRxSubject(returnType)) {
        final upperBoundAtIndex0 = returnType.upperBoundAtIndex0;

        if (TypeValue.isDartrofitResponse(upperBoundAtIndex0)) {
          return SubjectAdapter<R>() as CallAdapter<R, T>;
        } else {
          return SubjectBodyAdapter<R>() as CallAdapter<R, T>;
        }
      }
    }
    return null;
  }

  static bool _isRxSubject(ParameterizedTypeValue returnType) {
    return returnType.name == 'Subject' && returnType.libraryName == 'rxdart';
  }
}
