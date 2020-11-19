// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_service.dart';

// **************************************************************************
// WebApiGenerator
// **************************************************************************

class _$MyService extends MyService {
  _$MyService._(this.dartrofit) : super._();

  factory _$MyService(Dartrofit dartrofit) =>
      _instance ??= _$MyService._(dartrofit);

  static _$MyService _instance;

  final Dartrofit dartrofit;

  @override
  Future<xml.XmlDocument> getBookshelf() {
    final ptv0 =
        ParameterizedTypeValue('dart.async', 'Future', 'Future<XmlDocument>');
    final tv1 = TypeValue('xml', 'XmlDocument', 'XmlDocument');
    ptv0.upperBoundAtIndex0 = tv1;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'bookshelf'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = <Object>[];

    return dartrofit
        .parseAnnotation<xml.XmlDocument, Future<xml.XmlDocument>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<xml.XmlDocument> getInvalidBookshelf() {
    final ptv0 =
        ParameterizedTypeValue('dart.async', 'Future', 'Future<XmlDocument>');
    final tv1 = TypeValue('xml', 'XmlDocument', 'XmlDocument');
    ptv0.upperBoundAtIndex0 = tv1;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'invalidBookshelf'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = <Object>[];

    return dartrofit
        .parseAnnotation<xml.XmlDocument, Future<xml.XmlDocument>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<Response<Map<String, Object>>> postBookshelf(xml.XmlNode node) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<Map<String, Object>>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<Map<String, Object>>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final ptv2 =
        ParameterizedTypeValue('dart.core', 'Map', 'Map<String, Object>');
    ptv1.upperBoundAtIndex0 = ptv2;
    final tv3 = TypeValue('dart.core', 'String', 'String');
    ptv2.upperBoundAtIndex0 = tv3;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'postBookshelf'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(node))])
      ..returnType = ptv0);

    final args = <Object>[node];

    return dartrofit
        .parseAnnotation<Map<String, Object>,
            Future<Response<Map<String, Object>>>>(annotationInfo)
        .invoke(args);
  }
}
