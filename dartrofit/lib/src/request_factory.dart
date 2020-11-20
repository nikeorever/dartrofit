import 'package:http/http.dart';
import 'package:wedzera/core.dart';
import 'package:wedzera/collection.dart';

import 'parameter_handler.dart';
import 'request_builder.dart';

class RequestFactory {
  final String method;
  final Uri baseUrl;
  final String relativeUrl;
  final bool isMultipart;
  final bool isFormEncoded;
  final List<ParameterHandler<Object>> parameterHandlers;

  RequestFactory(this.method, this.baseUrl, this.relativeUrl, this.isMultipart,
      this.isFormEncoded, this.parameterHandlers);

  /// one of [Request], [MultipartRequest]
  BaseRequest create(List<Object> args) {
    final handlers = parameterHandlers;
    final argumentCount = args.length;
    require(argumentCount == handlers.length,
        lazyMessage: () =>
            "Argument count ($argumentCount) doesn't match expected"
            ' count (${handlers.length})');

    final requestBuilder = RequestBuilder(
        method, baseUrl, relativeUrl, isMultipart, isFormEncoded);

    handlers.forEachIndexed((index, handler) {
      handler.apply(requestBuilder, args[index]);
    });

    return requestBuilder.build();
  }
}
