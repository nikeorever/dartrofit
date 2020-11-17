// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JsonConverterSample.dart';

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
  Future<List<Object>> getJsonArray1() {
    final ptv0 =
        ParameterizedTypeValue('dart.async', 'Future', 'Future<List<Object>>');
    final ptv1 = ParameterizedTypeValue('dart.core', 'List', 'List<Object>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dart.core', 'Object', 'Object');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getJsonArray'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<List<Object>, Future<List<Object>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<List<Object>>> getJsonArray2() {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<List<Object>>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<List<Object>>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final ptv2 = ParameterizedTypeValue('dart.core', 'List', 'List<Object>');
    ptv1.upperBoundAtIndex0 = ptv2;
    final tv3 = TypeValue('dart.core', 'Object', 'Object');
    ptv2.upperBoundAtIndex0 = tv3;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getJsonArray'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<Optional<List<Object>>,
            Future<Optional<List<Object>>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Map<String, Object>> getBooks1() {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Map<String, Object>>');
    final ptv1 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, Object>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dart.core', 'String', 'String');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<Map<String, Object>, Future<Map<String, Object>>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<Map<String, dynamic>> getBooks2() {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Map<String, dynamic>>');
    final ptv1 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, dynamic>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dart.core', 'String', 'String');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<Map<String, dynamic>, Future<Map<String, dynamic>>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<Map<int, Object>>> getBooks3() {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<Map<int, Object>>>');
    final ptv1 = ParameterizedTypeValue(
        'quiver', 'Optional', 'Optional<Map<int, Object>>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final ptv2 = ParameterizedTypeValue('dart.core', 'Map', 'Map<int, Object>');
    ptv1.upperBoundAtIndex0 = ptv2;
    final tv3 = TypeValue('dart.core', 'int', 'int');
    ptv2.upperBoundAtIndex0 = tv3;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<Optional<Map<int, Object>>,
            Future<Optional<Map<int, Object>>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<Map<Object, Object>>> getBooks4() {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<Map<Object, Object>>>');
    final ptv1 = ParameterizedTypeValue(
        'quiver', 'Optional', 'Optional<Map<Object, Object>>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final ptv2 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<Object, Object>');
    ptv1.upperBoundAtIndex0 = ptv2;
    final tv3 = TypeValue('dart.core', 'Object', 'Object');
    ptv2.upperBoundAtIndex0 = tv3;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'books/v1/getBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<Optional<Map<Object, Object>>,
            Future<Optional<Map<Object, Object>>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<ResponseBody>> postBooks1(RequestBody body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<ResponseBody>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<Optional<ResponseBody>,
            Future<Optional<ResponseBody>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<ResponseBody>> postBooks2(Map body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<ResponseBody>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<Optional<ResponseBody>,
            Future<Optional<ResponseBody>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<ResponseBody>> postBooks3(List body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<ResponseBody>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<Optional<ResponseBody>,
            Future<Optional<ResponseBody>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<Optional<ResponseBody>> postBooks4(User body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<ResponseBody>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postBooks'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<Optional<ResponseBody>,
            Future<Optional<ResponseBody>>>(annotationInfo)
        .invoke(args);
  }
}
