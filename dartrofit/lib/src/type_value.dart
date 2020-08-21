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
    if (type == null) {
      throw ArgumentError.notNull('typevalue is null');
    }
    return type.name == 'Response' && type.libraryName == 'dartrofit';
  }

  static bool isQuiverOptional(TypeValue type) {
    if (type == null) {
      throw ArgumentError.notNull('typevalue is null');
    }
    return type.name == 'Optional' && type.libraryName == 'quiver.core';
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
