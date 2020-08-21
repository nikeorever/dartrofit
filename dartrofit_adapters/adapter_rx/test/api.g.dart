// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// WebApiGenerator
// **************************************************************************

class _$ApiService extends ApiService {
  _$ApiService._(this.dartrofit) : super._();

  factory _$ApiService(Dartrofit dartrofit) {
    return _instance ??= _$ApiService._(dartrofit);
  }

  static _$ApiService _instance;

  final Dartrofit dartrofit;

  @override
  rx.Subject<Response<ResponseBody>> getBook(String id) {
    final ptv0 = ParameterizedTypeValue(
        'rxdart', 'Subject', 'Subject<Response<ResponseBody>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'book'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([QueryHandler('id', true)])
      ..returnType = ptv0);

    final args = [id];

    return dartrofit
        .parseAnnotation<ResponseBody, rx.Subject<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }
}
