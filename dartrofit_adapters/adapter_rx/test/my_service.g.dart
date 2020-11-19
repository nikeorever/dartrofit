// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_service.dart';

// **************************************************************************
// ServiceGenerator
// **************************************************************************

class _$MyService extends MyService {
  _$MyService._(this.dartrofit) : super._();

  factory _$MyService(Dartrofit dartrofit) =>
      _instance ??= _$MyService._(dartrofit);

  static _$MyService _instance;

  final Dartrofit dartrofit;

  @override
  rx.Subject<Response<ResponseBody>> getBook1(String id) {
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
      ..parameterHandlers.addAll([QueryHandler('id', false)])
      ..returnType = ptv0);

    final args = <Object>[id];

    return dartrofit
        .parseAnnotation<ResponseBody, rx.Subject<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  rx.Subject<Map<String, Object>> getBook2(String id) {
    final ptv0 = ParameterizedTypeValue(
        'rxdart', 'Subject', 'Subject<Map<String, Object>>');
    final ptv1 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, Object>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dart.core', 'String', 'String');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'book'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([QueryHandler('id', false)])
      ..returnType = ptv0);

    final args = <Object>[id];

    return dartrofit
        .parseAnnotation<Map<String, Object>, rx.Subject<Map<String, Object>>>(
            annotationInfo)
        .invoke(args);
  }
}
