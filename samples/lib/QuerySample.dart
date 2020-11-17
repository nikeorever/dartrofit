import 'package:dartrofit/dartrofit.dart';
import 'package:wedzera/collection.dart';
import 'package:wedzera/core.dart';
import 'http.dart';

part 'QuerySample.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('books/v1/getBooks')
  Future<Response<ResponseBody>> getBooks1(@Query('category') String category);

  @GET('books/v1/getBooks')
  Future<Response<ResponseBody>> getBooks2(
      @QueryMap() Map<String, dynamic> queries);
}

void main() async {
  final api = Api(dartrofit);
  var response1 = await api.getBooks1('natural');
  assert(response1.request().url.queryParameters['category'] == 'natural');

  response1 = await api.getBooks1(null);
  assert(!response1.request().url.queryParameters.containsKey('category'));

  try {
    await api.getBooks2(null);
  } catch (e) {
    print(e);
  }

  final response2 = await api.getBooks2({'category': 'natural'});
  assert(response2.request().url.queryParameters['category'] == 'natural');

  try {
    await api.getBooks2({'category': null});
  } on ArgumentError catch (e) {
    print(e);
  }

  try {
    await api.getBooks2({null: null});
  } on ArgumentError catch (e, s) {
    print(e);
    print(s);
  }
}
