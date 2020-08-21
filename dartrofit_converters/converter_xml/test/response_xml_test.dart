import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';
import 'package:mockserver/mockserver.dart';
import 'package:test/test.dart';

import 'api.dart';

void main() {
  group('response converter Test', () {
    Dartrofit dartrofit;
    HttpMockServer mockServer;

    setUp(() {
      mockServer = HttpMockServer();
      dartrofit = Dartrofit(mockServer.url('api/'))
        ..converterFactories.add(XmlConverterFactory());
    });

    test('without response Test', () async {
      final server = await mockServer.listen((request) {
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final xml = await Api(dartrofit).getBookshelf();
      expect(xml.rootElement.name.toString(), equals('bookshelf'));
      await server.close(force: true);
    });
  });
}
