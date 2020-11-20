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
  Future<Response<ResponseBody>> uploadBook(http.MultipartFile book) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<ResponseBody>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'uploadBook'
      ..isMultipart = true
      ..isFormEncoded = false
      ..parameterHandlers.addAll([PartFileHandler()])
      ..returnType = ptv0);

    final args = <Object>[book];

    return dartrofit
        .parseAnnotation<ResponseBody, Future<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }
}
