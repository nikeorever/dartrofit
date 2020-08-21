# Dartrofit_adapter_rx for dartrofit
The Rx support for dartrofit

First, depend on it
```yaml
dependencies:
    dartrofit_adapter_rx: latest version
```
Then, add it to `Dartrofit` configuration
```dart
final dartrofit = Dartrofit(Uri.parse('http://0.0.0.0:7777/'))
  ..adapterFactories.add(SubjectAdaptFactory());
```

## Usage
```dart
import 'package:rxdart/rxdart.dart' as rx;

@WebApi()
abstract class Api {
  Api._();

  factory Api(Dartrofit dartrofit) = _$Api;

  @GET('books/v1/getBooks')
  rx.Subject<Response<Map<String, dynamic>>> getBookNumber();
}
```
