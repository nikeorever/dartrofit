import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:wedzera/core.dart';
import 'package:quiver/pattern.dart';

class HttpMockServer {
  HttpMockServer({this.address = '0.0.0.0', this.port = 7777}) {
    requireNotNull(matchesFull(RegExp(_ipv4Pattern), address),
        lazyMessage: () => '$address is not standard ipv4 address');
  }

  final String address;
  final int port;
  static const _ipv4Pattern =
      r'(?=(\b|\D))(((\d{1,2})|(1\d{1,2})|(2[0-4]\d)|(25[0-5]))\.){3}((\d{1,2})|(1\d{1,2})|(2[0-4]\d)|(25[0-5]))(?=(\b|\D))';

  /// Starts listening for HTTP requests on the specified [address] and [port]
  Future<HttpServer> listen(Future Function(HttpRequest) requestHandler,
      {Function onError,
      void Function() onDone,
      bool cancelOnError}) async {
    final server = await HttpServer.bind(address, port);
    server.listen(requestHandler,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    return server;
  }

  Uri url([String path]) => Uri.http('$address:$port', path.orEmpty());

  static Future serveRequestByVirtualDirectory(HttpRequest request,
      {String pathPrefix}) {
    final staticFiles = VirtualDirectory(pathPrefix)
      ..allowDirectoryListing = true;
    return staticFiles.serveRequest(request);
  }
}
