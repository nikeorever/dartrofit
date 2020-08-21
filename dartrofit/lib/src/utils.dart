import 'package:analyzer/dart/element/element.dart';

bool isDartrofitCore(Element element) {
  if (element?.library?.name == 'dartrofit') {
    return true;
  }
  final arr = element?.enclosingElement?.librarySource?.fullName?.split('/');
  if (arr != null && arr.length >= 2) {
    return 'dartrofit' == arr[1];
  } else {
    return false;
  }
}

bool isHttpCore(Element element) {
  if (element?.library?.name == 'http') {
    return true;
  }
  final arr = element?.enclosingElement?.librarySource?.fullName?.split('/');
  if (arr != null && arr.length >= 2) {
    return 'http' == arr[1];
  } else {
    return false;
  }
}
