// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

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
  Future<xml.XmlDocument> getBookshelf() {
    final ptv0 =
        ParameterizedTypeValue('dart.async', 'Future', 'Future<XmlDocument>');
    final tv1 = TypeValue('xml.nodes.document', 'XmlDocument', 'XmlDocument');
    ptv0.upperBoundAtIndex0 = tv1;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'GET'
      ..relativeUrl = 'bookshelf'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers.addAll([])
      ..returnType = ptv0);

    final args = [];

    return dartrofit
        .parseAnnotation<xml.XmlDocument, Future<xml.XmlDocument>>(
            annotationInfo)
        .invoke(args);
  }

  @override
  Future<Response<xml.XmlDocument>> postBookshelf(xml.XmlNode node) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<XmlDocument>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<XmlDocument>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('xml.nodes.document', 'XmlDocument', 'XmlDocument');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'bookshelf'
      ..isMultipart = false
      ..isFormEncoded = false
      ..parameterHandlers
          .addAll([BodyHandler(dartrofit.requestBodyConverter(node))])
      ..returnType = ptv0);

    final args = [node];

    return dartrofit
        .parseAnnotation<xml.XmlDocument, Future<Response<xml.XmlDocument>>>(
            annotationInfo)
        .invoke(args);
  }
}
