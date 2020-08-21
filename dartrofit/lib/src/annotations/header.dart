/// This can only appear before a function
///
/// Adds headers for a method
/// Replaces the header with the value of its target
class Headers {
  final List<String> headers;

  const Headers(this.headers);
}

/// This can only appear before a parameter
///
/// Replaces the header with the value of its target, If the value is null,
/// the header will be omitted. Otherwise, toString will be called on the value,
/// and the result used.
class Header {
  final String name;

  const Header(this.name);
}

/// This can only appear before a parameter
///
/// Adds headers for a method
class HeaderMap {
  const HeaderMap();
}
