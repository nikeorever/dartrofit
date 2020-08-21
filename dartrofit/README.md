# Dartrofit for Dart and Flutter

## Introduction
`Dartrofit` turns your HTTP API into a Dart "interface"(abstract class).
```dart
import 'package:dartrofit/dartrofit.dart';

part 'sample.g.dart';

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('books/v1/getBooks')
  Future<Response<Map<String, dynamic>>> getBooks(
    @Query('category') int category,
  );
}
```
Create a `Dartrofit` object that can be used to configure `baseUrl`, `adapters`, `converters` etc.
```dart
final dartrofit = Dartrofit(Uri.parse('http://0.0.0.0:7777/'))
  ..adapterFactories.add(SubjectAdaptFactory()) // Optional
  ..converterFactories.addAll([XmlConverterFactory(), JsonConverterFactory()]); // Optional
```
Use `build_runner`. The [dartrofit_generator](https://pub.dev/packages/dartrofit_generator) will generates an implementation of the `Api` class in `sample.g.dart`
```shell script
pub run build_runner build
```
in Flutter
```shell script
flutter pub run build_runner build
```
Send request.
```dart
void main() async {
  final api = Api(dartrofit);
  final response = await api.getBooks( 2);
  // response ok.
  final qp = response.request().url.queryParameters;
  assert(int.parse(qp['category']) == 2);
}
```

## Dependencies
```yaml
dependencies:
  dartrofit: latest version # Required
  dartrofit_adapter_rx: latest version # Optional 
  dartrofit_converter_xml: latest version # Optional 
  dartrofit_converter_json: latest version # Optional 

dev_dependencies:
  dartrofit_generator: latest version # Required
  build_runner: latest version # Required
  build_verify: latest version # Required
``` 

## Request Methods
Every method must have an HTTP annotation that provides the request method and relative URL. 
There are seven built-in annotations: GET, POST, PUT, PATCH, DELETE, OPTIONS and HEAD. 
```dart
@GET('v1/getBooks')
```

## Url Manipulation
A request URL can be updated dynamically using replacement blocks and parameters on the method. 
A replacement block is an alphanumeric string surrounded by { and }. 
A corresponding parameter must be annotated with `@Path()` using the same string.
```dart
@GET('books/{version}/getBooks')
Call<Response<Map<String, dynamic>>> getBooks(@Path('version') String version); 
```

## Dynamic url
```dart
@GET()
Call<Response<Map<String, dynamic>>> getBooks(@Url() String url); 

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
Future<Response<ResponseBody>> postBooksWithMultipart(
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
rx.Subject<Response<Map<String, dynamic>>> getBookNumber(
    @Query('key1', encoded: true) String wrapper,
    @QueryMap(encoded: true) Map<String, String> param,
    @Query('key2', encoded: true) String value1,
    @Header('HeaderName') String headerValue,
    @HeaderMap() Map<String, String> headerMap);
```

## Dartrofit Configuration
### Adapters
- `Call` (built-in)
```dart
@GET('books/v1/getBooks')
Call<Response<Map<String, dynamic>>> getBooks(@Query('category') int category); 
```
- `Future` (built-in)
```dart
@GET('books/v1/getBooks')
Future<Response<Map<String, dynamic>>> getBooks(@Query('category') int category); 
```
- `CancelableOperation` (built-in)
```dart
@GET('books/v1/getBooks')
CancelableOperation<Response<Map<String, dynamic>>> getBooks(@Query('category') int category); 
```
- `Subject` ([rxdart](https://pub.dev/packages/rxdart) support, depend on `dartrofit_adapter_rx: latest version`)
```dart
@GET('books/v1/getBooks')
CancelableOperation<Response<Map<String, dynamic>>> getBooks(@Query('category') int category); 
```

### Converters
By default, Dartrofit can only deserialize HTTP bodies into Dartrofit's `ResponseBody` type and it can only accept
its `RequestBody` type for `@Body()`.
```dart
@POST('books/v1/postBooks')
Future<Optional<ResponseBody>> postBooks(@Body() RequestBody body);
```
Converters can be added to support other types.
- Json: `dartrofit_converter_json: latest version`(Any type accepted by `jsonEncode()` in `json`)
```dart
@POST('books/v1/postBooks')
Future<Optional<Map<String, dynamic>>> postBooks(@Body() Map<String, dynamic> body);
```
- Xml: `dartrofit_converter_xml: latest version`
```dart
@POST('books/v1/postBooks')
Future<Optional<XmlDocument>> postBooks(@Body() xml.XmlNode body);
```

