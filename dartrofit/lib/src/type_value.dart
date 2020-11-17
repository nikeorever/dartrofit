import 'package:wedzera/core.dart';

class TypeValue {
  final String libraryName;
  final String name;
  final String displayName;

  TypeValue(this.libraryName, this.name, this.displayName);

  @override
  String toString() {
    return 'TypeValue{libraryName: $libraryName, name: $name, displayName: $displayName}';
  }

  static bool isDartrofitResponse(TypeValue type) {
    requireNotNull(type, lazyMessage: () => 'typeValue is null');
    return type.name == 'Response' && type.libraryName == 'dartrofit';
  }

  static bool isQuiverOptional(TypeValue type) {
    requireNotNull(type, lazyMessage: () => 'typeValue is null');
    return type.name == 'Optional' && type.libraryName == 'quiver';
  }

  static bool isDartrofitResponseBody(TypeValue type) {
    requireNotNull(type, lazyMessage: () => 'typeValue is null');
    return type.name == 'ResponseBody' && type.libraryName == 'dartrofit';
  }

  static bool isDartCoreMap(TypeValue type) {
    requireNotNull(type, lazyMessage: () => 'typeValue is null');
    return type.name == 'Map' && type.libraryName == 'dart.core';
  }

  static bool isDartCoreList(TypeValue type) {
    requireNotNull(type, lazyMessage: () => 'typeValue is null');
    return type.name == 'List' && type.libraryName == 'dart.core';
  }
}

class ParameterizedTypeValue extends TypeValue {
  TypeValue upperBoundAtIndex0;

  ParameterizedTypeValue(String libraryName, String name, String displayName)
      : super(libraryName, name, displayName);

  @override
  String toString() {
    return 'ParameterizedTypeValue{libraryName: $libraryName, name: $name, displayName: $displayName}, upperBoundAtIndex0: $upperBoundAtIndex0}';
  }
}
