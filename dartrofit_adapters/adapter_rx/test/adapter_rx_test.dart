import 'dart:async';
import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_adapter_rx/src/subject_adapter_factory.dart';
import 'package:mockserver/mockserver.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'api.dart';

void main() {
  group('dartrofit rx adapter Tests', () {
    HttpMockServer mockServer;
    Dartrofit dartrofit;
    setUp(() {
      mockServer = HttpMockServer();
      dartrofit = Dartrofit(mockServer.url('api/'))
        ..adapterFactories.add(SubjectAdaptFactory());
    });

    test('GET request Test', () async {
      final server = await mockServer.listen((request) {
        return HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test');
      });
      ApiService(dartrofit)
          .getBook('0')
          .stream
          .flatMap<Map<String, dynamic>>((response) {
            // RxDart Api
            return Stream.value(
                jsonDecode(response.body.string) as Map<String, dynamic>);
          })
          .switchIfEmpty(Stream.value({})) // RxDart Api
          .timestamp() // RxDart Api
          .doOnData(// RxDart Api
              expectAsync1<void, Timestamped<Map<String, dynamic>>>((data) {
            print(data);
            expect(data.value['name'], equals('Cosmos'));
            server.close(force: true);
          }))
          .doOnError((dynamic e, StackTrace s) {
            // RxDart Api
            server.close(force: true);
          })
          .listen(null);
    });
  });
}
