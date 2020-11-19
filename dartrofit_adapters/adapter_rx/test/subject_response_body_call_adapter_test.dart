import 'dart:convert';

import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_adapter_rx/dartrofit_adapter_rx.dart';
import 'package:mockserver/mockserver.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'my_service.dart';

void main() {
  test('Test_SubjectResponseBodyCallAdapter', () async {
    final mockServer = HttpMockServer();
    final myService = MyService(Dartrofit(mockServer.url('api/'))
      ..addCallAdapterFactory(RxDartCallAdapterFactory()));

    final server = await mockServer.listen((request) =>
        HttpMockServer.serveRequestByVirtualDirectory(request,
            pathPrefix: 'test'));


    myService
        .getBook1('0')
        .map<Map<String, dynamic>>((response) =>
            jsonDecode(response.body.string) as Map<String, dynamic>)
        .timestamp()
        .listen((data) => expect(data.value['name'], equals('Cosmos')),
            onError: (dynamic e, StackTrace s) => print(e),
            onDone: () => server.close(force: true));
  });
}
