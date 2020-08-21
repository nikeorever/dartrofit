class Path {
  final String name;
  final bool encoded;

  const Path(this.name, {this.encoded = false}) : assert(name != null);
}
