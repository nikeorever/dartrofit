import 'package:dartrofit/dartrofit.dart';

part 'api.g.dart';

@webApi
abstract class ApiService {
  ApiService._();

  factory ApiService(Dartrofit dartrofit) = _$ApiService;

  @GET('book')
  Future<Response<Map<String, dynamic>>> getBook(@Query('id', encoded: true) String id);

  @GET('book')
  Future<Map<String, dynamic>> getBook2(@Query('id', encoded: true) String id);

  @POST('book')
  Future<Map<String, dynamic>> postBook(@Body() Map<String, Object> body);
}
