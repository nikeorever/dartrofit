// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'QuerySample.dart';

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
  Future<Response<ResponseBody>> getBooks1(String category) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<ResponseBody>>');
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
        .parseAnnotation<ResponseBody, Future<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<Response<ResponseBody>> getBooks2(Map<String, dynamic> queries) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<ResponseBody>>');
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
      ..parameterHandlers.addAll([QueryMapHandler(false)])
      ..returnType = ptv0);

    final args = [queries];

    return dartrofit
        .parseAnnotation<ResponseBody, Future<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }
}
