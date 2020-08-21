// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_sample.dart';

// **************************************************************************
// WebApiGenerator
// **************************************************************************

class _$MultipartApi extends MultipartApi {
  _$MultipartApi._(this.dartrofit) : super._();

  factory _$MultipartApi(Dartrofit dartrofit) {
    return _instance ??= _$MultipartApi._(dartrofit);
  }

  static _$MultipartApi _instance;

  final Dartrofit dartrofit;

  @override
  Future<Response<ResponseBody>> postBooksWithMultipart(
      String partFileValue,
      Map<String, String> partFieldMap,
      List<http.MultipartFile> multipartFiles,
      http.MultipartFile multipartFile) {
    final ptv0 = ParameterizedTypeValue(
        'dart.async', 'Future', 'Future<Response<ResponseBody>>');
    final ptv1 = ParameterizedTypeValue(
        'dartrofit', 'Response', 'Response<ResponseBody>');
    ptv0.upperBoundAtIndex0 = ptv1;
    final tv2 = TypeValue('dartrofit', 'ResponseBody', 'ResponseBody');
    ptv1.upperBoundAtIndex0 = tv2;

    final annotationInfo = AnnotationInfo((b) => b
      ..httpMethod = 'POST'
      ..relativeUrl = 'books/v1/postBooks'
      ..isMultipart = true
      ..isFormEncoded = false
      ..parameterHandlers.addAll([
        PartFieldHandler('name'),
        PartFieldMapHandler(),
        PartFileHandler(),
        PartFileListHandler()
      ])
      ..returnType = ptv0);

    final args = [partFileValue, partFieldMap, multipartFile, multipartFiles];

    return dartrofit
        .parseAnnotation<ResponseBody, Future<Response<ResponseBody>>>(
            annotationInfo)
        .invoke(args);
  }
}
