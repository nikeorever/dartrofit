import 'dart:convert';

import 'package:dartrofit/src/call_adapter.dart';
import 'package:dartrofit/src/converter.dart';
import 'package:dartrofit/src/request_factory.dart';
import 'package:dartrofit/src/response_body.dart';
import 'package:dartrofit/src/type_value.dart';
import 'package:dartrofit/dartrofit.dart';
import 'package:quiver/check.dart';

class Dartrofit {
  final Uri baseUrl;
  final List<ConverterFactory> _converterFactories = <ConverterFactory>[
    BuiltInConvertFactory() // must be last
  ];
  final List<CallAdapterFactory> _adapterFactories = <CallAdapterFactory>[
    BuiltInAdapterFactory()
  ];

  Dartrofit(Uri baseUrl) : baseUrl = _checkBaseUrl(baseUrl);

  static Uri _checkBaseUrl(Uri baseUrl) {
    checkNotNull(baseUrl, message: 'baseUrl == null');
    final pathSegments = baseUrl.pathSegments;
    if (pathSegments.isNotEmpty && '' != pathSegments[pathSegments.length - 1]) {
      throw ArgumentError('baseUrl must end in /: $baseUrl');
    }
    return baseUrl;
  }

  void addConverterFactory(ConverterFactory factory) {
    // BuiltInConvertFactory must be last.
    _converterFactories.insert(0, factory);
  }

  void addCallAdapterFactory(CallAdapterFactory factory) {
    _adapterFactories.add(factory);
  }

  HttpServiceMethod<ResponseT, ReturnT> parseAnnotation<ResponseT, ReturnT>(
      AnnotationInfo methodInfo) {
    final requestFactory = RequestFactory(
      methodInfo.httpMethod,
      baseUrl,
      methodInfo.relativeUrl,
      methodInfo.isMultipart,
      methodInfo.isFormEncoded,
      methodInfo.parameterHandlers.toList(),
    );
    return _callAdapted<ResponseT, ReturnT>(
        methodInfo.returnType, requestFactory);
  }

  HttpServiceMethod<ResponseT, ReturnT> _callAdapted<ResponseT, ReturnT>(
      TypeValue returnType, RequestFactory requestFactory) {
    final adapter = _nextAdapter<ResponseT, ReturnT>(returnType);
    final converter = _responseBodyConverter<ResponseT>(returnType);
    return CallAdapted<ResponseT, ReturnT>(requestFactory, adapter, converter);
  }

  CallAdapter<ResponseT, ReturnT> _nextAdapter<ResponseT, ReturnT>(
      TypeValue returnType) {
    for (var factory in _adapterFactories) {
      final adapter = factory.get<ResponseT, ReturnT>(returnType);
      if (adapter != null) {
        return adapter;
      }
    }
    return null;
  }

  Converter<ResponseBody, ResponseT> _responseBodyConverter<ResponseT>(
      TypeValue returnType) {
    TypeValue dataType;
    final parameterizedTypeValue = returnType as ParameterizedTypeValue;
    final upperBoundAtIndex0 = parameterizedTypeValue.upperBoundAtIndex0;
    if (TypeValue.isDartrofitResponse(upperBoundAtIndex0)) {
      dataType =
          (upperBoundAtIndex0 as ParameterizedTypeValue).upperBoundAtIndex0;
    } else {
      dataType = upperBoundAtIndex0;
    }

    for (var factory in _converterFactories) {
      final converter = factory.responseBodyConverter<ResponseT>(dataType);
      if (converter != null) {
        return converter;
      }
    }
    return null;
  }

  Converter<Object, RequestBody> requestBodyConverter(Object value) {
    for (var factory in _converterFactories) {
      final converter = factory.requestBodyConverter(value);
      if (converter != null) {
        return converter;
      }
    }
    return null;
  }
}
