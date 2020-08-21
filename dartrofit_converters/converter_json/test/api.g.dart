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
  Future<Response<Map<String, dynamic>>> getBook(String id) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<Map<String, dynamic>>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<Map<String, dynamic>>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final ptv2 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, dynamic>');
    ptv1.upperBoundAtIndex0 = ptv2;
    final tv3 = TypeValue('dart.core', 'String', 'String');
    ptv2.upperBoundAtIndex0 = tv3;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'book'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([QueryHandler('id', true)])
      ..returnType = ptv0);

    final args = [id];

    return dartrofit
        .parseAnnotation<Map<String, dynamic>,
            Future<Response<Map<String, dynamic>>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Map<String, dynamic>> getBook2(String id) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Map<String, dynamic>>');
    final ptv1 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, dynamic>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dart.core', 'String', 'String');
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
        .parseAnnotation<Map<String, dynamic>, Future<Map<String, dynamic>>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<Map<String, dynamic>> postBook(Map<String, Object> body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Map<String, dynamic>>');
    final ptv1 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, dynamic>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dart.core', 'String', 'String');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'book'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<Map<String, dynamic>, Future<Map<String, dynamic>>>(
            annotationInfo)
        .invoke(args);
  }
}
