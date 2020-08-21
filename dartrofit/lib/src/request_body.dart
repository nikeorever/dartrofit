import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:quiver/check.dart';

abstract class RequestBody {
  final MediaType contentType;

  static Encoding getEncoding([MediaType contentType]) {
    final parameters = contentType?.parameters;
    if (true == parameters?.containsKey('charset')) {
      final charset = parameters['charset'];
      return Encoding.getByName(charset) ??
          (throw FormatException('Unsupported encoding "$charset".'));
    }
    return utf8;
  }

  RequestBody._(this.contentType);

  factory RequestBody.bytes(MediaType contentType, List<int> content) {
    return _RequestBody(contentType, content);
  }

  factory RequestBody.string(MediaType contentType, String content) {
    contentType ??=
        MediaType('text', 'plain', {'charset': RequestBody.getEncoding().name});

    if (!contentType.parameters.containsKey('charset')) {
      contentType = contentType
          .change(parameters: {'charset': RequestBody.getEncoding().name});
    }

    final encoding = RequestBody.getEncoding(contentType);
    return _RequestBody(contentType, encoding.encode(content));
  }

  void writeTo(Sink<List<int>> sink);
}

class _RequestBody extends RequestBody {
  final List<int> content;

  _RequestBody(MediaType contentType, this.content) : super._(contentType);

  @override
  void writeTo(Sink<List<int>> sink) {
    sink.add(content);
    sink.close();
  }
}

class FormBody extends RequestBody {
  static final MediaType _mediaType = MediaType('application',
      'x-www-form-urlencoded', {'charset': RequestBody.getEncoding().name});
  final bodyFields = <List<String>>[];

  FormBody() : super._(_mediaType);

  void add(String name, String value, bool encoded) {
    checkNotNull(name, message: 'name == null');
    checkNotNull(value, message: 'value == null');
    bodyFields.add([
      encoded ? Uri.encodeQueryComponent(name, encoding: utf8) : name,
      encoded ? Uri.encodeQueryComponent(value, encoding: utf8) : value
    ]);
  }

  @override
  void writeTo(Sink<List<int>> sink) {
    final body = bodyFields.map((pair) => '${pair[0]}=${pair[1]}').join('&');
    sink.add(RequestBody.getEncoding(contentType).encode(body));
    sink.close();
  }
}
