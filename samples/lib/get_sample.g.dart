// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_sample.dart';

// **************************************************************************
// WebApiGenerator
// **************************************************************************

class _$GETApi extends GETApi {
  _$GETApi._(this.dartrofit) : super._();

  factory _$GETApi(Dartrofit dartrofit) {
    return _instance ??= _$GETApi._(dartrofit);
  }

  static _$GETApi _instance;

  final Dartrofit dartrofit;

  @override
  Future<Response<ResponseBody>> getBooksFuture(
      String param1,
      int param2,
      Map<String, dynamic> paramMap1,
      Map<String, dynamic> paramMap2,
      String valueOfHeader3,
      int valueOfHeader4) {
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
      ..parameterHandlers.addAll([
        QueryHandler('param1', false),
        QueryHandler('param2', false),
        QueryMapHandler(false),
        QueryMapHandler(false),
        HeadersHandler(),
        HeaderHandler('header3'),
        HeaderHandler('header4')
      ])
      ..returnType = ptv0);

    final args = [
      param1,
      param2,
      paramMap1,
      paramMap2,
      ['header1: value_of_header1', 'header2: value_of_header2'],
      valueOfHeader3,
      valueOfHeader4
    ];

    return dartrofit
        .parseAnnotation<ResponseBody, Future<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }
}
