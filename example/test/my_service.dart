import 'package:dartrofit/dartrofit.dart';
import 'package:http/http.dart' as http;

part 'my_service.g.dart';

@Service()
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @Multipart()
  @POST('uploadBook')
  Future<Response<ResponseBody>> uploadBook(
      @PartFile() http.MultipartFile book);
}