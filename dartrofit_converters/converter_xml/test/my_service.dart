import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart' as xml;

part 'my_service.g.dart';

@service
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @GET('bookshelf')
  Future<xml.XmlDocument> getBookshelf();

  @GET('invalidBookshelf')
  Future<xml.XmlDocument> getInvalidBookshelf();

  @POST('postBookshelf')
  Future<Response<Map<String, Object>>> postBookshelf(@Body() xml.XmlNode node);
}
