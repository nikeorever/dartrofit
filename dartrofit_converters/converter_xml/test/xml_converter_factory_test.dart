import 'dart:typed_data';

import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';
import 'package:http_server/http_server.dart';
import 'package:test/test.dart';
import 'package:dartrofit/dartrofit.dart';
import 'package:mockserver/mockserver.dart';
import 'package:xml/xml.dart';

import 'api.dart';

void main() {
  group('Test_XmlConverterFactory', () {
    Api api;
    HttpMockServer mockServer;

    setUp(() {
      mockServer = HttpMockServer();
      api = Api(Dartrofit(mockServer.url('api/'))
        ..addConverterFactory(XmlConverterFactory()));
    });

    test('Test_XmlResponseBodyConverter_validXml', () async {
      final server = await mockServer.listen((request) =>
          HttpMockServer.serveRequestByVirtualDirectory(request,
              pathPrefix: 'test'));

      final bookshelf = await api.getBookshelf();
      expect(bookshelf.rootElement.name.toString(), equals('bookshelf'));
      await server.close(force: true);
    });

    test('Test_XmlResponseBodyConverter_invalidXml', () async {
      final server = await mockServer.listen((request) =>
          HttpMockServer.serveRequestByVirtualDirectory(request,
              pathPrefix: 'test'));

      try {
        await api.getInvalidBookshelf();
      } catch (e) {
        expect(e, isA<XmlParserException>());
      } finally {
        await server.close(force: true);
      }
    });

    test('Test_XmlRequestBodyConverter', () async {
      final server = await mockServer.listen((request) async {
        final requestBody = await HttpBodyHandler.processRequest(request);
        expect(requestBody.type, 'binary');
        expect(request.headers['content-type'].toString(),
            '[application/xml; charset=utf-8]');
        final bookshelfXml =
            String.fromCharCodes(requestBody.body as Uint8List);
        expect(XmlDocument.parse(bookshelfXml).rootElement.name.toString(),
            equals('bookshelf'));
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final builder = XmlBuilder();
      // ignore: cascade_invocations
      builder.processing('xml', 'version="1.0"');
      // ignore: cascade_invocations
      builder.element('bookshelf', nest: () {
        builder.element('book', nest: () {
          builder.element('title', nest: () {
            builder.attribute('lang', 'english');
            // ignore: cascade_invocations
            builder.text('Growing a Language');
          });
          // ignore: cascade_invocations
          builder.element('price', nest: 29.99);
        });
        // ignore: cascade_invocations
        builder.element('book', nest: () {
          builder.element('title', nest: () {
            builder.attribute('lang', 'english');
            // ignore: cascade_invocations
            builder.text('Learning XML');
          });
          // ignore: cascade_invocations
          builder.element('price', nest: 39.95);
        });
        // ignore: cascade_invocations
        builder.element('price', nest: 132.00);
      });
      final bookshelfXml = builder.buildDocument();

      final response = await api.postBookshelf(bookshelfXml);
      expect(response.body['isSuccess'], isTrue);
      await server.close(force: true);
    });

    test('Test_XmlRequestBodyConverter_nullBody', () async {
      final server = await mockServer.listen((request) async =>
          HttpMockServer.serveRequestByVirtualDirectory(request,
              pathPrefix: 'test'));

      try {
        await api.postBookshelf(null);
      } catch (e) {
        expect(e, isA<ArgumentError>());
      } finally {
        await server.close(force: true);
      }
    });
  });
}
