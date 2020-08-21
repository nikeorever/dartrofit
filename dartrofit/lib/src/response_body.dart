import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class ResponseBody {
  int contentLength;
  Uint8List bytes;
  String string;
  MediaType contentType;

  ResponseBody._();

  ResponseBody.fromResponse(http.Response response) {
    contentLength = response.contentLength;
    bytes = response.bodyBytes;
    string = response.body;
    contentType = _contentTypeForHeaders(response.headers);
  }

  /// Returns the [MediaType] object for the given headers's content-type.
  ///
  /// Defaults to `application/octet-stream`.
  MediaType _contentTypeForHeaders(Map<String, String> headers) {
    final contentType = headers['content-type'];
    if (contentType != null) return MediaType.parse(contentType);
    return MediaType('application', 'octet-stream');
  }

  @override
  String toString() {
    return 'ResponseBody{contentLength: $contentLength, string: $string, contentType: $contentType}';
  }
}
