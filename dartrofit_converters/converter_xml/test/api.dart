import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart' as xml;

part 'api.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('bookshelf')
  Future<xml.XmlDocument> getBookshelf();

  @GET('invalidBookshelf')
  Future<xml.XmlDocument> getInvalidBookshelf();

  @POST('postBookshelf')
  Future<Response<Map<String, Object>>> postBookshelf(@Body() xml.XmlNode node);
}
