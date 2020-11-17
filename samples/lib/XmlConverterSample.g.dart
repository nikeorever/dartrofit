// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'XmlConverterSample.dart';

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
  Future<Optional<ResponseBody>> postXml1(xml.XmlNode body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<ResponseBody>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postXml'
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
  Future<Optional<xml.XmlDocument>> postXml2(xml.XmlNode body) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Optional<XmlDocument>>');
    final ptv1 =
        ParameterizedTypeValue('quiver', 'Optional', 'Optional<XmlDocument>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('xml', 'XmlDocument', 'XmlDocument');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postXml'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<Optional<xml.XmlDocument>,
            Future<Optional<xml.XmlDocument>>>(annotationInfo)
        .invoke(args);
  }

  @override
  Future<xml.XmlDocument> postXml3(xml.XmlNode body) {
    final ptv0 =
        ParameterizedTypeValue('dart.async', 'Future', 'Future<XmlDocument>');
    final tv1 = TypeValue('xml', 'XmlDocument', 'XmlDocument');
    ptv0.upperBoundAtIndex0 = tv1;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postXml'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(body))])
      ..returnType = ptv0);

    final args = [body];

    return dartrofit
        .parseAnnotation<xml.XmlDocument, Future<xml.XmlDocument>>(
            annotationInfo)
        .invoke(args);
  }
}
