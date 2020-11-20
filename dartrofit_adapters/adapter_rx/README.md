# RxDart Adapter For [Dartrofit](https://pub.dev/packages/dartrofit)

[![pub package](https://img.shields.io/badge/pub-1.1.0-blueviolet.svg)](https://pub.dev/packages/dartrofit_adapter_rx)

An Adapter for adapting [rxdart](https://pub.dev/packages/rxdart) types.
Available types:
* The `Subject<T>` and `Subject<Response<T>>` where T is the body type.

## Example
```dart
import 'package:dartrofit/dartrofit.dart';
import 'package:rxdart/rxdart.dart' as rx;

part 'my_service.g.dart';

@Service()
abstract class MyService {
  MyService._();

  factory MyService(Dartrofit dartrofit) = _$MyService;

  @GET('book')
  rx.Subject<Response<ResponseBody>> getBook1(@Query('id') String id);

  @GET('book')
  rx.Subject<ResponseBody> getBook2(@Query('id') String id);
}
```

## Download

```yaml
dependencies:
  dartrofit_adapter_rx: ^1.1.0
```
