import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_converter_json/dartrofit_converter_json.dart';
import 'package:mockserver/mockserver.dart';
import 'package:test/test.dart';

import 'api.dart';

void main() {
  group('dartrofit json responseBody converter Tests', () {
    HttpMockServer mockServer;
    Dartrofit dartrofit;
    setUp(() {
      mockServer = HttpMockServer();
      dartrofit = Dartrofit(mockServer.url('api/'))
        ..converterFactories.add(JsonConverterFactory());
    });

    test('with response Test', () async {
      final server = await mockServer.listen((request) {
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final response = await ApiService(dartrofit).getBook('0');
      expect(response.body['name'], equals('Cosmos'));

      await server.close(force: true);
    });

    test('without response Test', () async {
      final server = await mockServer.listen((request) {
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final json = await ApiService(dartrofit).getBook2('0');
      expect(json['name'], equals('Cosmos'));

      await server.close(force: true);
    });
  });
}
