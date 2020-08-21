import 'package:dartrofit/src/parameter_handler.dart';
import 'package:dartrofit/src/request_builder.dart';
import 'package:http/http.dart';

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
    if (argumentCount != handlers.length) {
      throw ArgumentError(
          "Argument count ($argumentCount) doesn't match expected count (${handlers.length})");
    }
    final requestBuilder = RequestBuilder(
        method, baseUrl, relativeUrl, isMultipart, isFormEncoded);

    for (var p = 0; p < argumentCount; p++) {
      handlers[p].apply(requestBuilder, args[p]);
    }

    return requestBuilder.build();
  }
}
