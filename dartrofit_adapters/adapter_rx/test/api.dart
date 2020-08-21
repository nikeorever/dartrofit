import 'package:dartrofit/dartrofit.dart';
import 'package:rxdart/rxdart.dart' as rx;

part 'api.g.dart';

@webApi
abstract class ApiService {
  ApiService._();

  factory ApiService(Dartrofit dartrofit) = _$ApiService;

  @GET('book')
  rx.Subject<Response<ResponseBody>> getBook(@Query('id', encoded: true) String id);

}