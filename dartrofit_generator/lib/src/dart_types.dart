import 'package:analyzer/dart/element/type.dart';
import 'package:dartrofit/dartrofit.dart';
import 'package:wedzera/core.dart';

class DartTypes {
  /// Gets the name of a `DartType`. Supports `Function` types, which will
  /// be returned using the `Function()` syntax.
  static String getName(DartType dartType) {
    if (dartType == null) {
      return null;
    } else if (dartType.isDynamic) {
      return 'dynamic';
    } else if (dartType is FunctionType) {
      // ignore: lines_longer_than_80_chars
      return '${getName(dartType.returnType)} Function(${dartType.parameters.map((p) => getName(p.type)).join(', ')})';
    } else if (dartType is InterfaceType) {
      final typeArguments = dartType.typeArguments;
      if (typeArguments.isEmpty || typeArguments.every((t) => t.isDynamic)) {
        return dartType.element.name;
      } else {
        final typeArgumentsStr = typeArguments.map(getName).join(', ');
        return '${dartType.element.name}<$typeArgumentsStr>';
      }
    } else if (dartType is TypeParameterType) {
      return dartType.element.name;
    } else if (dartType.isVoid) {
      return 'void';
    } else {
      throw UnimplementedError('(${dartType.runtimeType}) $dartType');
    }
  }

  static bool isParameterizedType(DartType dartType) {
    if (dartType is ParameterizedType) {
      final typeArgs = dartType.typeArguments;
      return typeArgs != null && typeArgs.isNotEmpty;
    }
    return false;
  }

  static bool isDartrofitResponse(DartType dartType) {
    if (dartType == null) {
      return false;
    }
    final element = dartType.element;
    if (element == null) {
      return false;
    }
    return element.name == 'Response' && isDartrofitCore(dartType.element);
  }

  static String getLibraryName(DartType type) {
    var libraryName = type?.element?.library?.name;
    if (libraryName.isNullOrEmpty()) {
      final arr = type.element.source.fullName?.split('/');
      if (arr != null && arr.length >= 2) {
        libraryName = arr[1];
      }
    }
    return libraryName;
  }
}
