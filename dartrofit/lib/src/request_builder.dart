import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:quiver/core.dart';
import 'package:wedzera/collection.dart';
import 'package:wedzera/core.dart';

import 'request_body.dart';

class RequestBuilder {
  /// This doc comments is copied from Retrofit
  /// Matches strings that contain {@code .} or {@code ..} as a complete path
  /// segment. This also matches dots in their percent-encoded form,
  /// {@code %2E}.
  ///
  /// <p>It is okay to have these strings within a larger path segment
  /// (like {@code a..z} or {@code index.html}) but when alone they have a
  /// special meaning. A single dot resolves to no path segment so
  /// {@code /one/./three/} becomes {@code /one/three/}. A double-dot pops
  /// the preceding directory, so {@code /one/../three/} becomes {@code /three/}.
  ///
  /// <p>We forbid these in Dartrofit paths because they're likely to have the
  /// unintended effect.
  /// For example, passing {@code ..} to {@code DELETE /account/book/{isbn}/}
  /// yields {@code DELETE /account/}.
  static final RegExp _pathTraversal = RegExp('(.*/)?(\.|%2e|%2E){1,2}(/.*)?');

  final String method;
  final Uri baseUrl;
  String relativeUrl;

  Uri uri;

  final bool isMultipart;
  final bool isFormEncoded;
  final Map<String, String> headers = <String, String>{};

  RequestBody body;

  final multipartFields = <String, String>{};
  final multipartFiles = <MultipartFile>[];

  RequestBuilder(this.method, this.baseUrl, this.relativeUrl, this.isMultipart,
      this.isFormEncoded,
      {Map<String, String> headers}) {
    if (!headers.isNullOrEmpty) {
      this.headers.addAll(headers);
    }

    if (isFormEncoded) {
      body = FormBody();
    }
  }

  void setRelativeUrl(Object relativeUrl) {
    this.relativeUrl = relativeUrl.toString();
  }

  void addPathParam(String name, String value, bool encoded) {
    requireNotNull(relativeUrl, lazyMessage: () => 'relativeUrl is null.');

    final replacement = encoded ? Uri.encodeComponent(value) : value;
    final newRelativeUrl = relativeUrl.replaceAll('{$name}', replacement);
    final matches = _pathTraversal.allMatches(newRelativeUrl);
    if (matches != null &&
        matches.isNotEmpty &&
        !matches.all((match) => match.group(0) == '.')) {
      throw ArgumentError("@Path parameters shouldn't perform path"
          " traversal ('.' or '..'): $value");
    }
    relativeUrl = newRelativeUrl;
  }

  void addQueryParam(String name, String value, bool encoded) {
    if (relativeUrl != null) {
      // Do a one-time combination of the built relative URL and the base URL.
      uri = requireNotNull<Uri>(baseUrl.resolve(relativeUrl),
          lazyMessage: () =>
              'Malformed URL. Base: $baseUrl, Relative: $relativeUrl');

      relativeUrl = null;
    }

    if (name.isNullOrEmpty() || value.isNullOrEmpty()) {
      return;
    }

    if (encoded) {
      name = Uri.encodeQueryComponent(name);
      value = Uri.encodeQueryComponent(value);
    }
    final newQueryParameters = LinkedHashMap.of(uri.queryParameters)
      ..[name] = value;
    uri = uri.replace(queryParameters: newQueryParameters);
  }

  void addFormField(String name, String value, bool encoded) =>
      (body as FormBody).add(name, value, encoded);

  /// one of [Request], [MultipartRequest]
  BaseRequest build() {
    var url = uri;
    url ??= requireNotNull<Uri>(baseUrl.resolve(relativeUrl),
        lazyMessage: () =>
            'Malformed URL. Base: $baseUrl, Relative: $relativeUrl');

    BaseRequest baseRequest;
    if (isMultipart) {
      final multipartRequest = MultipartRequest(method, url);
      if (multipartFields.isNotEmpty) {
        multipartRequest.fields.addAll(multipartFields);
      }
      if (multipartFiles.isNotEmpty) {
        multipartRequest.files.addAll(multipartFiles);
      }
      baseRequest = multipartRequest;
    } else {
      final request = Request(method, url);
      if (body != null) {
        body.writeTo(ByteConversionSink.withCallback((bytes) {
          request.bodyBytes = bytes;
        }));
        Optional.fromNullable(body.contentType).ifPresent((contentType) {
          request.headers['content-type'] = contentType.toString();
        });
      }
      baseRequest = request;
    }
    if (!headers.isNullOrEmpty) baseRequest.headers.addAll(headers);
    return baseRequest;
  }
}
