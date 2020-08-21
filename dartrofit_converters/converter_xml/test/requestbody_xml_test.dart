import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';
import 'package:mockserver/mockserver.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';
import 'package:http_server/http_server.dart';

import 'api.dart';

void main() {
  group('requestbody converter Test', () {
    Dartrofit dartrofit;
    HttpMockServer mockServer;

    setUp(() {
      mockServer = HttpMockServer();
      dartrofit = Dartrofit(mockServer.url('api/'))
        ..converterFactories.add(XmlConverterFactory());
    });

    test('with response Test', () async {
      final server = await mockServer.listen((request) async {
        final requestBody = await HttpBodyHandler.processRequest(request);
        expect(requestBody.type, 'binary');
        expect(request.headers['content-type'].toString(), '[application/xml; charset=utf-8]');
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('bookshelf', nest: () {
        builder.element('book', nest: () {
          builder.element('title', nest: () {
            builder.attribute('lang', 'english');
            builder.text('Growing a Language');
          });
          builder.element('price', nest: 29.99);
        });
        builder.element('book', nest: () {
          builder.element('title', nest: () {
            builder.attribute('lang', 'english');
            builder.text('Learning XML');
          });
          builder.element('price', nest: 39.95);
        });
        builder.element('price', nest: 132.00);
      });
      final bookshelfXml = builder.build();
      final xml = await Api(dartrofit).postBookshelf(bookshelfXml);
      expect(xml.body.rootElement.name.toString(), equals('bookshelf'));
      await server.close(force: true);
    });
  });
}
