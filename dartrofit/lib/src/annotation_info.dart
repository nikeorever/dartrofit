import 'package:dartrofit/src/parameter_handler.dart';
import 'package:dartrofit/src/type_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'annotation_info.g.dart';

abstract class AnnotationInfo
    implements Built<AnnotationInfo, AnnotationInfoBuilder> {
  @memoized
  String get httpMethod;

  @nullable
  @memoized
  String get relativeUrl;

  @memoized
  bool get isMultipart;

  @memoized
  bool get isFormEncoded;

  @memoized
  BuiltList<ParameterHandler<Object>> get parameterHandlers;

  @memoized
  TypeValue get returnType;

  AnnotationInfo._();

  factory AnnotationInfo([void Function(AnnotationInfoBuilder) updates]) =>
      _$AnnotationInfo(updates);
}
