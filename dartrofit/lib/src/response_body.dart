import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class ResponseBody {
  final int contentLength;
  final Uint8List bytes;
  final String string;
  final MediaType contentType;

  ResponseBody._(this.contentLength, this.bytes, this.string, this.contentType);

  ResponseBody.fromResponse(http.Response response)
      : this._(response.contentLength, response.bodyBytes, response.body,
            _contentTypeForHeaders(response.headers));

  /// Returns the [MediaType] object for the given headers's content-type.
  ///
  /// Defaults to `application/octet-stream`.
  static MediaType _contentTypeForHeaders(Map<String, String> headers) {
    final contentType = headers['content-type'];
    if (contentType != null) return MediaType.parse(contentType);
    return MediaType('application', 'octet-stream');
  }

  @override
  String toString() =>
      'ResponseBody{contentLength: $contentLength, string: $string,'
      ' contentType: $contentType}';
}
