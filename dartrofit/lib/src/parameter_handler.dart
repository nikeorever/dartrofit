import 'package:http/http.dart';
import 'package:wedzera/core.dart';

import 'annotations/field.dart';
import 'annotations/header.dart';
import 'annotations/multipart.dart';
import 'annotations/queries.dart';
import 'annotations/url.dart';
import 'converter.dart';
import 'request_body.dart';
import 'request_builder.dart';

abstract class ParameterHandler<T> {
  void apply(RequestBuilder builder, T value);
}

/// [Query]
class QueryHandler extends ParameterHandler<dynamic> {
  final String name;
  final bool encoded;

  QueryHandler(this.name, this.encoded) : assert(name != null);

  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return; // skip null value
    builder.addQueryParam(name, value.toString(), encoded);
  }
}

/// [QueryMap]
class QueryMapHandler extends ParameterHandler<Map<String, dynamic>> {
  final bool encoded;

  QueryMapHandler(this.encoded);

  @override
  void apply(RequestBuilder builder, Map<String, dynamic> value) {
    requireNotNull(value, lazyMessage: () => 'Query map was null');

    value.forEach((String entryKey, dynamic entryValue) {
      requireNotNull<String>(entryKey,
          lazyMessage: () => 'Query map contained null key');
      requireNotNull<dynamic>(entryValue,
          lazyMessage: () =>
              "Query map contained null value for key '$entryKey'");

      builder.addQueryParam(entryKey, entryValue.toString(), encoded);
    });
  }
}

/// [Url]
class RelativeUrlHandler extends ParameterHandler<Object> {
  @override
  void apply(RequestBuilder builder, Object value) {
    requireNotNull(value, lazyMessage: () => '@Url parameter is null');
    builder.setRelativeUrl(value);
  }
}

class PathHandler extends ParameterHandler<Object> {
  final String name;
  final bool encoded;

  PathHandler(this.name, this.encoded);

  @override
  void apply(RequestBuilder builder, Object value) {
    requireNotNull(value,
        lazyMessage: () => '@Path parameter "$name" value must not be null.');
    builder.addPathParam(name, value.toString(), encoded);
  }
}

class BodyHandler extends ParameterHandler<Object> {
  final Converter<Object, RequestBody> converter;

  BodyHandler(this.converter);

  @override
  void apply(RequestBuilder builder, Object value) {
    requireNotNull(value,
        lazyMessage: () => 'Body parameter value must not be null.');

    builder.body =
        runCatching<RequestBody>(() => converter.convert(value)).getOrElse((e) {
      throw ArgumentError('Unable to convert $value to RequestBody');
    });
  }
}

/// [Field]
class FieldHandler extends ParameterHandler<dynamic> {
  final String name;
  final bool encoded;

  FieldHandler(this.name, this.encoded) : assert(name != null);

  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    builder.addFormField(name, value.toString(), encoded);
  }
}

/// [FieldMap]
class FieldMapHandler extends ParameterHandler<Map<String, dynamic>> {
  final bool encoded;

  FieldMapHandler(this.encoded);

  @override
  void apply(RequestBuilder builder, Map<String, dynamic> value) {
    requireNotNull(value, lazyMessage: () => 'Field map was null.');
    value.forEach((String key, dynamic value) {
      requireNotNull<String>(key,
          lazyMessage: () => 'Field map contained null key.');
      requireNotNull<dynamic>(value,
          lazyMessage: () => 'Field map contained null value for key $key.');
      builder.addFormField(key, value.toString(), encoded);
    });
  }
}

/// [Headers]
class HeadersHandler extends ParameterHandler<List<String>> {
  @override
  void apply(RequestBuilder builder, List<String> value) {
    if (value == null || value.isEmpty) return;
    for (var str in value) {
      // expect 'name: value'
      if (str.contains(':')) {
        final split = str.split(':');
        final name = split[0].trim();
        final value = split[1].trim();
        if (!name.isNullOrEmpty() && !value.isNullOrEmpty()) {
          builder.headers[name] = value;
        }
      }
    }
  }
}

/// [Header]
class HeaderHandler extends ParameterHandler<dynamic> {
  final String name;

  HeaderHandler(this.name) : assert(name != null);

  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    builder.headers[name] = value.toString();
  }
}

/// [HeaderMap]
class HeaderMapHandler extends ParameterHandler<dynamic> {
  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    if (value is Map) {
      final casted = value.cast<String, String>();
      builder.headers.addAll(casted);
    }
  }
}

/// [PartField]
class PartFieldHandler extends ParameterHandler<dynamic> {
  final String name;

  PartFieldHandler(this.name) : assert(name != null);

  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    builder.multipartFields[name] = value.toString();
  }
}

/// [PartFieldMap]
class PartFieldMapHandler extends ParameterHandler<dynamic> {
  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    if (value is Map) {
      final casted = value.cast<String, String>();
      if (casted.isNotEmpty) {
        builder.multipartFields.addAll(casted);
      }
    }
  }
}

/// [PartFile]
class PartFileHandler extends ParameterHandler<dynamic> {
  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    if (value is MultipartFile) {
      builder.multipartFiles.add(value);
    }
  }
}

/// [PartFileList]
class PartFileListHandler extends ParameterHandler<dynamic> {
  @override
  void apply(RequestBuilder builder, dynamic value) {
    if (value == null) return;
    if (value is Iterable) {
      final casted = value.cast<MultipartFile>();
      builder.multipartFiles.addAll(casted);
    }
  }
}
