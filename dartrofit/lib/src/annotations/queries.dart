class Query {
  final String name;
  /// Specifies whether parameter names and values are already URL encoded.
  final bool encoded;

  const Query(this.name, {this.encoded = false});
}

class QueryMap {
  /// Specifies whether parameter names and values are already URL encoded.
  final bool encoded;

  const QueryMap({this.encoded = false});
}
