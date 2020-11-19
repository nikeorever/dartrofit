import 'package:dartrofit/dartrofit.dart';
import 'package:rxdart/rxdart.dart' as rx;

part 'my_service.g.dart';

@service
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @GET('book')
  rx.Subject<Response<ResponseBody>> getBook1(@Query('id') String id);

  @GET('book')
  rx.Subject<Map<String, Object>> getBook2(@Query('id') String id);
}
