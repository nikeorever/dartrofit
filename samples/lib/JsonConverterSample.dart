import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:quiver/core.dart';
import 'package:http_parser/http_parser.dart';
import 'http.dart';

part 'JsonConverterSample.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('books/v1/getJsonArray')
  Future<List<Object>> getJsonArray1();

  @GET('books/v1/getJsonArray')
  Future<Optional<List<Object>>> getJsonArray2();

  @GET('books/v1/getBooks')
  Future<Map<String, Object>> getBooks1();

  @GET('books/v1/getBooks')
  Future<Map<String, dynamic>> getBooks2();

  @GET('books/v1/getBooks')
  Future<Optional<Map<int, Object>>> getBooks3();

  @GET('books/v1/getBooks')
  Future<Optional<Map<Object, Object>>> getBooks4();

  @POST('books/v1/postBooks')
  Future<Optional<ResponseBody>> postBooks1(@Body() RequestBody body);

  @POST('books/v1/postBooks')
  Future<Optional<ResponseBody>> postBooks2(@Body() Map body);

  @POST('books/v1/postBooks')
  Future<Optional<ResponseBody>> postBooks3(@Body() List body);

  @POST('books/v1/postBooks')
  Future<Optional<ResponseBody>> postBooks4(@Body() User body);
}

class User {
  final int id;
  final String name;

  const User(this.id, this.name);

  String toJson() {
    return json.encode({'id': id, 'name': name});
  }
}

void main() async {
  final api = Api(dartrofit);
  var opt = await api.postBooks1(RequestBody.string(
      MediaType(
          'application', 'json', {'charset': RequestBody.getEncoding().name}),
      json.encode({'id': 1, 'name': 'Kobe'})));

  opt = await api.postBooks2({'id': 2, 'name': 'Kobe'});
  opt = await api.postBooks3([1, 2, 3, 4]);
  opt = await api.postBooks4(const User(4, 'Kobe'));

  opt.ifPresent((body) {
    print(body.string);
  });
}
