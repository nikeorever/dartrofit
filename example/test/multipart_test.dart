import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_adapter_rx/dartrofit_adapter_rx.dart';
import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';
import 'package:mockserver/mockserver.dart';
import 'package:http_server/http_server.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'my_service.dart';

void main() {
  group('Test_Multipart', () {
    MyService myService;
    HttpMockServer mockServer;

    setUp(() {
      mockServer = HttpMockServer();
      myService = MyService(Dartrofit(mockServer.url('api/'))
        ..addConverterFactory(XmlConverterFactory())
        ..addCallAdapterFactory(RxDartCallAdapterFactory()));
    });

    test('Test_Single_MultipartFile', () async {
      final server = await mockServer.listen((request) async {
        final requestBody = await HttpBodyHandler.processRequest(request);
        expect(requestBody.type, equals('form'));

        final dynamic bookInfo =
            (requestBody.body as Map<String, dynamic>)['book_info'];
        final book = jsonDecode(bookInfo as String) as Map<String, dynamic>;

        expect(book['book_name'], equals('Dart'));

        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final bookDart = <String, String>{
        'book_id': '1',
        'book_name': 'Dart',
        'book_category': 'Programming Language'
      };
      final book = http.MultipartFile.fromString(
          'book_info', jsonEncode(bookDart),
          contentType: MediaType.parse('application/json; charset=utf-8'));

      await myService.uploadBook(book);
      await server.close(force: true);
    });
  });
}
