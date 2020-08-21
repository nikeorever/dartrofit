import 'package:dartrofit/dartrofit.dart';
import 'package:xml/xml.dart' as xml;

part 'api.g.dart';

@webApi
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('bookshelf')
  Future<xml.XmlDocument> getBookshelf();

  @POST('bookshelf')
  Future<Response<xml.XmlDocument>> postBookshelf(@Body() xml.XmlNode node);
}