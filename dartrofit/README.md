# Dartrofit for Dart and Flutter

[![pub package](https://img.shields.io/badge/pub-1.1.0-blueviolet.svg)](https://pub.dev/packages/dartrofit)

## Introduction
`Dartrofit` turns your HTTP API into a Dart *interface*.
```dart
import 'package:dartrofit/dartrofit.dart';

part 'my_service.g.dart';

@Service()
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @GET('books/v1/getBook')
  Future<Response<ResponseBody>> getBook(@Query('category') int category);
}
```
Create a `Dartrofit` object that can be used to configure `baseUrl`, `AdapterFactory`s, `ConverterFactory`s.
```dart
final dartrofit = Dartrofit(Uri.parse('http://0.0.0.0:7777/'))
  ..addCallAdapterFactory(RxDartCallAdapterFactory()) // Optional
  ..addConverterFactory(XmlConverterFactory()); // Optional
```
Use `build_runner`. The [dartrofit_generator](https://pub.dev/packages/dartrofit_generator) will generates an implementation of the `MyService` class in `my_service.g.dart`.

For Dart:
```shell script
pub run build_runner build
```

For Flutter:
```shell script
flutter pub run build_runner build
```

Send request.
```dart
void main() async {
  final myService = MyService(dartrofit);
  final response = await myService.getBook(2);
  // response ok.
  if (response.isSuccessful()) {
    // handle responseBody.
  } else {
    // handle error.
  }
}
```

## Download
```yaml
dependencies:
  dartrofit: ^1.1.0 # Required
  dartrofit_adapter_rx: ^1.1.0 # Optional 
  dartrofit_converter_xml: ^1.1.0 # Optional

dev_dependencies:
  build_runner: ^1.10.1 # Required
  build_verify: ^1.1.1 # Required
  dartrofit_generator: ^1.1.0 # Required
``` 

## Request Methods
Every method must have an HTTP annotation that provides the request method and relative URL. 
There are seven built-in annotations: GET, POST, PUT, PATCH, DELETE, OPTIONS and HEAD. 
```dart
@GET('books/v1/getBook')
```

## Url Manipulation
A request URL can be updated dynamically using replacement blocks and parameters on the method. 
A replacement block is an alphanumeric string surrounded by { and }. 
A corresponding parameter must be annotated with `@Path()` using the same string.
```dart
@GET('books/{version}/getBook')
Call<Response<ResponseBody>> getBook(@Path('version') String version); 
```

## Dynamic url
```dart
@GET()
Call<Response<ResponseBody>> getBooks(@Url() String url); 
```

## Form encoded and multipart
Methods can also be declared to send form-encoded and multipart data.

Form-encoded data is sent when `@FormUrlEncoded()` is present on the method. 
Each key-value pair is annotated with `@Field()` containing the name and the object providing the value.
In the case of multiple fields, you can use `@FieldMap()` instead.
```dart
@FormUrlEncoded()
@POST('books/v1/postBooks')
Future<Optional<XmlDocument>> postBooks(
    @Field('name') String name,
    @FieldMap() Map<String, String> fieldMap
);
```

Multipart requests are used when `@Multipart()` is present on the method.
```dart
@Multipart()
@POST('books/v1/postBooks')
Future<Response<ResponseBody>> postBooks(
    @PartField('name') String partFileValue,
    @PartFieldMap() Map<String, String> partFieldMap,
    @PartFileList() List<http.MultipartFile> multipartFiles,
    @PartFile() MultipartFile multipartFile);
```

## Headers manipulation
You can set static headers for a method using `@Headers([])`, `@Header()`, `@HeaderMap()` annotations.
```dart
@Headers([
  'Accept: application/vnd.github.v3.full+json',
  'User-Agent: Dartrofit-Sample-App'
])
@GET('books/v1/getBooks')
rx.Subject<Response<Map<String, dynamic>>> getBooks(
    @Query('key1', encoded: true) String value1,
    @QueryMap(encoded: true) Map<String, String> queries,
    @Query('key2', encoded: true) String value2,
    @Header('HeaderName') String headerValue,
    @HeaderMap() Map<String, String> headers);
```

## Dartrofit Configuration
### Call Adapters
- `Call` (built-in)
```dart
@GET('books/v1/getBook')
Call<Response<ResponseBody>> getBook(@Query('category') int category); 
```
- `Future` (built-in)
```dart
@GET('books/v1/getBook')
Future<Response<ResponseBody>> getBook(@Query('category') int category); 
```
- `CancelableOperation` (built-in)
```dart
@GET('books/v1/getBook')
CancelableOperation<Response<ResponseBody>> getBook(@Query('category') int category); 
```
- `Stream` (built-in)
```dart
@GET('books/v1/getBook')
Stream<ResponseBody> getBook(@Query('category') int category); 
```
- `Subject` ([external dependency](https://pub.dev/packages/dartrofit_adapter_rx))
```dart
@GET('books/v1/getBook')
Subject<Response<ResponseBody>> getBook(@Query('category') int category); 
```

### Converters
By default, Dartrofit can only deserialize HTTP bodies into Dartrofit's `ResponseBody` type and it can only accept
its `RequestBody` type for `@Body()`.
```dart
@POST('books/v1/postBooks')
Future<Optional<ResponseBody>> postBooks(@Body() RequestBody body);
```
Converters can be added to support other types.
- Json: (built-in)

Only supports converting `ResponseBody` into: `Map<String, Object>`, `Map<Object, Object>`, `Map<String, dynamic>`, or `List<Object>`.

Any type that support conversion to `RequestBody` can be accepted by `jsonEncode()` in `json`.  
```dart
@POST('books/v1/postBooks')
Future<Map<String, dynamic>> postBooks(@Body() Map<String, dynamic> body);
```
- Xml: ([external dependency](https://pub.dev/packages/dartrofit_converter_xml))

Only supports converting `ResponseBody` into: `XmlDocument`.

The type that support conversion to `RequestBody` is `XmlNode`. 
```dart
@POST('books/v1/postBooks')
Future<Optional<XmlDocument>> postBooks(@Body() xml.XmlNode body);
```