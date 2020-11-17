// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StreamCallAdapterSample.dart';

// **************************************************************************
// WebApiGenerator
// **************************************************************************

class _$Api extends Api {
  _$Api._(this.dartrofit) : super._();

  factory _$Api(Dartrofit dartrofit) {
    return _instance ??= _$Api._(dartrofit);
  }

  static _$Api _instance;

  final Dartrofit dartrofit;

  @override
  Stream<Response<ResponseBody>> getBooks1(String category) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Stream', 'Stream<Response<ResponseBody>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([QueryHandler('category', false)])
      ..returnType = ptv0);

    final args = [category];

    return dartrofit
        .parseAnnotation<ResponseBody, Stream<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Stream<ResponseBody> getBooks2(Map<String, dynamic> queries) {
    final ptv0 =
        ParameterizedTypeValue('dart.async', 'Stream', 'Stream<ResponseBody>');
    final tv1 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv0.upperBoundAtIndex0 = tv1;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([QueryMapHandler(false)])
      ..returnType = ptv0);

    final args = [queries];

    return dartrofit
        .parseAnnotation<ResponseBody, Stream<ResponseBody>>(annotationInfo)
        .invoke(args);
  }
}
