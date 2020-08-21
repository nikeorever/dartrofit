import 'package:dartrofit/dartrofit.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'http.dart';

part 'multipart_sample.g.dart';

@webApi
abstract class MultipartApi {
  MultipartApi._();

  factory MultipartApi(Dartrofit dartrofit) = _$MultipartApi;

  @Multipart()
  @POST('books/v1/postBooks')
  Future<Response<ResponseBody>> postBooksWithMultipart(
      @PartField('name') String partFileValue,
      @PartFieldMap() Map<String, String> partFieldMap,
      @PartFileList() List<http.MultipartFile> multipartFiles,
      @PartFile() http.MultipartFile multipartFile);
}

void main() async {
  final multipartFile = await http.MultipartFile.fromPath('package',
      '/home/xianxueliang/IdeaProjects/dartrofit/samples/lib/text',
      contentType: MediaType('application', 'octet-stream'));
  final multipartResponse = await MultipartApi(dartrofit).postBooksWithMultipart(
      null, {'name1': 'value1', 'name2': 'value2'}, [], multipartFile);
  if (multipartResponse.isSuccessful()) {
    print(multipartResponse.body);
  } else {
    print('error...');
  }
}
