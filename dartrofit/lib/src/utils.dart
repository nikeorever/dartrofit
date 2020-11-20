import 'package:analyzer/dart/element/element.dart';
import 'package:wedzera/collection.dart';
import 'package:wedzera/core.dart';

bool isDartrofitCore(Element element) {
  if (element?.library?.name == 'dartrofit') {
    return true;
  }
  final arr = element?.enclosingElement?.librarySource?.fullName?.split('/');
  return 'dartrofit' ==
      arr?.takeIf((arr) => arr.length >= 2)?.elementAtOrNull(1);
}

bool isHttpCore(Element element) {
  if (element?.library?.name == 'http') {
    return true;
  }
  final arr = element?.enclosingElement?.librarySource?.fullName?.split('/');
  return 'http' == arr?.takeIf((arr) => arr.length >= 2)?.elementAtOrNull(1);
}
