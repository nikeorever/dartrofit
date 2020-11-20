import 'package:http/http.dart' as http;

import 'response_body.dart';

class Response<T> {
  final http.Response rawResponse;
  T body;
  ResponseBody errorBody;

  Response(this.rawResponse, {this.body, this.errorBody});

  /// The raw response from the HTTP
  http.Response raw() => rawResponse;

  int code() => rawResponse.statusCode;

  String message() => rawResponse.reasonPhrase;

  /// Return true if [code] is in the range [200..300]
  bool isSuccessful() => code() >= 200 && code() < 300;

  http.BaseRequest request() => rawResponse.request;

  Map<String, String> headers() => rawResponse.headers;

  @override
  String toString() => rawResponse.toString();

  static Response<T> success<T>(T body, http.Response rawResponse) {
    final code = rawResponse.statusCode;
    if (code < 200 || code >= 300) {
      throw ArgumentError('rawResponse must be successful response');
    }
    return Response(rawResponse, body: body);
  }

  static Response<T> error<T>(ResponseBody body, http.Response rawResponse) {
    final code = rawResponse.statusCode;
    if (code >= 200 && code < 300) {
      throw ArgumentError('rawResponse should not be successful response');
    }
    return Response(rawResponse, errorBody: body);
  }
}
