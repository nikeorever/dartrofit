import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_server/http_server.dart';
import 'package:logging/logging.dart';
import 'package:mockserver/mockserver.dart';

final mockServerLog = Log('Mock server');
final staticFiles = VirtualDirectory('lib')..allowDirectoryListing = true;

void main() {
  staticFiles.errorPageHandler = (request) {
    mockServerLog.info('Oh noes! ${request.uri}');
  };
  runZoned(() {
    HttpMockServer().listen(_serveRequest,
        onError: (dynamic e, StackTrace stackTrace) =>
            mockServerLog.info('Oh noes! $e $stackTrace'));
    mockServerLog.info('Server running');
  });
}

Future _serveRequest(HttpRequest request) async {
  var requestInfo =
      // ignore: lines_longer_than_80_chars
      'method: ${request.method}; url: ${request.uri}; headers: [${request.headers}];';
  switch (request.method.toUpperCase()) {
    case 'POST':
    case 'PUT':
    case 'PATCH':
      final requestBody = await HttpBodyHandler.processRequest(request);
      requestInfo +=
          'requestBody:[type: ${requestBody.type}, body: ${requestBody.body}];';
      final dynamic body = requestBody.body;
      if (body is Map) {
        for (var httpBodyFileUpload
            in body.values.whereType<HttpBodyFileUpload>()) {
          final dynamic content = httpBodyFileUpload.content;
          if (content is Uint8List) {
            print('HttpBodyFileUpload: ${utf8.decode(content)}');
          }
        }
      }
      break;
  }
  mockServerLog.info(requestInfo);
  return staticFiles.serveRequest(request);
}

class Log {
  Logger _logger;
  static Log instance;

  factory Log(String name) => instance ??= Log._(name);

  Log._(String name) {
    _logger = Logger(name)
      ..onRecord.listen((record) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      });
  }

  void info(dynamic message, [Object error, StackTrace stackTrace]) =>
      _logger.info(message, error, stackTrace);
}
