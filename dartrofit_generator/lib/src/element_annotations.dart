import 'package:analyzer/dart/element/element.dart';
import 'package:dartrofit/dartrofit.dart';

class ElementAnnotations {
  static bool isDartrofitGet(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'GET';
    }
    return false;
  }

  static bool isDartrofitPost(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'POST';
    }
    return false;
  }

  static bool isDartrofitPut(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'PUT';
    }
    return false;
  }

  static bool isDartrofitPatch(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'PATCH';
    }
    return false;
  }

  static bool isDartrofitDelete(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'DELETE';
    }
    return false;
  }

  static bool isDartrofitHead(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'HEAD';
    }
    return false;
  }

  static bool isDartrofitOptions(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'OPTIONS';
    }
    return false;
  }

  static bool isDartrofitRequestMethod(ElementAnnotation annotation) =>
      isDartrofitGet(annotation) ||
      isDartrofitPost(annotation) ||
      isDartrofitPut(annotation) ||
      isDartrofitPatch(annotation) ||
      isDartrofitDelete(annotation) ||
      isDartrofitHead(annotation) ||
      isDartrofitOptions(annotation);

  static bool isDartrofitQuery(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Query';
    }
    return false;
  }

  static bool isDartrofitQueryMap(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'QueryMap';
    }
    return false;
  }

  static bool isDartrofitBody(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Body';
    }
    return false;
  }

  static bool isDartrofitHeaders(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Headers';
    }
    return false;
  }

  static bool isDartrofitHeader(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Header';
    }
    return false;
  }

  static bool isDartrofitHeaderMap(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'HeaderMap';
    }
    return false;
  }

  static bool isDartrofitMultipart(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Multipart';
    }
    return false;
  }

  static bool isDartrofitPartField(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'PartField';
    }
    return false;
  }

  static bool isDartrofitPartFieldMap(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'PartFieldMap';
    }
    return false;
  }

  static bool isDartrofitPartFile(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'PartFile';
    }
    return false;
  }

  static bool isDartrofitPartFileList(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'PartFileList';
    }
    return false;
  }

  static bool isDartrofitFormUrlEncoded(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element)) {
      if (element is ConstructorElement) {
        return element.enclosingElement.name == 'FormUrlEncoded';
      } else if (element is PropertyAccessorElement) {
        return element.name == 'formUrlEncoded';
      }
    }
    return false;
  }

  static bool isDartrofitField(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Field';
    }
    return false;
  }

  static bool isDartrofitFieldMap(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'FieldMap';
    }
    return false;
  }

  static bool isDartrofitPath(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element) && element is ConstructorElement) {
      return element.enclosingElement.name == 'Path';
    }
    return false;
  }

  static bool isDartrofitUrl(ElementAnnotation annotation) {
    if (annotation == null) return false;
    final element = annotation.element;
    if (isDartrofitCore(annotation.element)) {
      if (element is ConstructorElement) {
        return element.enclosingElement.name == 'Url';
      } else if (element is PropertyAccessorElement) {
        return element.name == 'url';
      }
    }
    return false;
  }
}
