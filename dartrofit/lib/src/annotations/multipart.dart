import 'package:http/http.dart';

/// This can only appear before a function
/// Denotes this is a multipart request
class Multipart {
  const Multipart();
}

/// This can only appear before a Parameter
class PartField {
  // The name of form fields
  final String name;

  const PartField(this.name);
}

/// This can only appear before a Parameter
/// [Map<String,String>]
class PartFieldMap {
  const PartFieldMap();
}

/// This can only appear before a Parameter
/// [MultipartFile]
class PartFile {
  const PartFile();
}

/// This can only appear before a Parameter
///
/// [MultipartFile]
class PartFileList {
  const PartFileList();
}