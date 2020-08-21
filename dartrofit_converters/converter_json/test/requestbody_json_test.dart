import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_converter_json/dartrofit_converter_json.dart';
import 'package:mockserver/mockserver.dart';
import 'package:test/test.dart';
import 'package:http_server/http_server.dart';

import 'api.dart';

void main() {
  group('dartrofit json requestBody converter Tests', () {
    HttpMockServer mockServer;
    Dartrofit dartrofit;
    setUp(() {
      mockServer = HttpMockServer();
      dartrofit = Dartrofit(mockServer.url('api/'))
        ..converterFactories.add(JsonConverterFactory());
    });

    test('with application/json Test', () async {
      final server = await mockServer.listen((request) async {
        final requestBody = await HttpBodyHandler.processRequest(request);
        final body = requestBody.body;
        expect(body, isA<Map>());
        expect(body['offset'], equals(0));
        expect(body['limit'], equals(20));
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });

      final json =
          await ApiService(dartrofit).postBook({'offset': 0, 'limit': 20});
      expect(json['name'], equals('Cosmos'));

      await server.close(force: true);
    });
  });
}
