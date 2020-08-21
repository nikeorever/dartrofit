import 'package:dartrofit/dartrofit.dart';
import 'package:wedzera/core.dart';

import 'http.dart';

part 'get_sample.g.dart';

@WebApi()
abstract class GETApi {
  GETApi._();

  factory GETApi(Dartrofit dartrofit) = _$GETApi;

  @Headers(['header1: value_of_header1', 'header2: value_of_header2'])
  @GET('books/v1/getBooks')
  Future<Response<Map<String, dynamic>>> getBooksFuture(
    @Query('param1') String param1,
    @Query('param2') int param2,
    @QueryMap() Map<String, dynamic> paramMap1,
    @QueryMap() Map<String, dynamic> paramMap2,
    @Header('header3') String valueOfHeader3,
    @Header('header4') int valueOfHeader4,
  );
}

void main() async {
  final api = GETApi(dartrofit);
  final response = await api.getBooksFuture(
      'value1',
      2,
      {'param3': 'value3', 'param4': 4},
      {'param5': 'value5', 'param6': 6},
      'valueOfHeader3',
      7);
  final qp = response.raw().request.url.queryParameters;
  assert(qp['param3'] == 'value3');
  assert(response.request().headers['header1'] == 'value_of_header1');
  assert(response.request().headers['header4'].toInt() == 7);

  print(response.headers());
}
