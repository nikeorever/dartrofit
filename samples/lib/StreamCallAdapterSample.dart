import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'http.dart';

part 'StreamCallAdapterSample.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('books/v1/getBooks')
  Stream<Response<ResponseBody>> getBooks1(@Query('category') String category);

  @GET('books/v1/getBooks')
  Stream<ResponseBody> getBooks2(@QueryMap() Map<String, dynamic> queries);
}

void main() {
  final api = Api(dartrofit);
  api.getBooks1('natural').listen((response) {
    assert(response.request().url.queryParameters['category'] == 'natural');
  });

  api.getBooks2({'category': 'natural'}).listen((body) {
    final map = json.decode(body.string) as Map<String, dynamic>;
    assert(map['message'] == 'get books success');
  });
}
