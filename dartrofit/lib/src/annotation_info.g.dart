// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnnotationInfo extends AnnotationInfo {
  @override
  final String httpMethod;
  @override
  final String relativeUrl;
  @override
  final bool isMultipart;
  @override
  final bool isFormEncoded;
  @override
  final BuiltList<ParameterHandler<Object>> parameterHandlers;
  @override
  final TypeValue returnType;

  factory _$AnnotationInfo([void Function(AnnotationInfoBuilder) updates]) =>
      (new AnnotationInfoBuilder()..update(updates)).build();

  _$AnnotationInfo._(
      {this.httpMethod,
      this.relativeUrl,
      this.isMultipart,
      this.isFormEncoded,
      this.parameterHandlers,
      this.returnType})
      : super._() {
    if (httpMethod == null) {
      throw new BuiltValueNullFieldError('AnnotationInfo', 'httpMethod');
    }
    if (isMultipart == null) {
      throw new BuiltValueNullFieldError('AnnotationInfo', 'isMultipart');
    }
    if (isFormEncoded == null) {
      throw new BuiltValueNullFieldError('AnnotationInfo', 'isFormEncoded');
    }
    if (parameterHandlers == null) {
      throw new BuiltValueNullFieldError('AnnotationInfo', 'parameterHandlers');
    }
    if (returnType == null) {
      throw new BuiltValueNullFieldError('AnnotationInfo', 'returnType');
    }
  }

  @override
  AnnotationInfo rebuild(void Function(AnnotationInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnnotationInfoBuilder toBuilder() =>
      new AnnotationInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnnotationInfo &&
        httpMethod == other.httpMethod &&
        relativeUrl == other.relativeUrl &&
        isMultipart == other.isMultipart &&
        isFormEncoded == other.isFormEncoded &&
        parameterHandlers == other.parameterHandlers &&
        returnType == other.returnType;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, httpMethod.hashCode), relativeUrl.hashCode),
                    isMultipart.hashCode),
                isFormEncoded.hashCode),
            parameterHandlers.hashCode),
        returnType.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AnnotationInfo')
          ..add('httpMethod', httpMethod)
          ..add('relativeUrl', relativeUrl)
          ..add('isMultipart', isMultipart)
          ..add('isFormEncoded', isFormEncoded)
          ..add('parameterHandlers', parameterHandlers)
          ..add('returnType', returnType))
        .toString();
  }
}

class AnnotationInfoBuilder
    implements Builder<AnnotationInfo, AnnotationInfoBuilder> {
  _$AnnotationInfo _$v;

  String _httpMethod;
  String get httpMethod => _$this._httpMethod;
  set httpMethod(String httpMethod) => _$this._httpMethod = httpMethod;

  String _relativeUrl;
  String get relativeUrl => _$this._relativeUrl;
  set relativeUrl(String relativeUrl) => _$this._relativeUrl = relativeUrl;

  bool _isMultipart;
  bool get isMultipart => _$this._isMultipart;
  set isMultipart(bool isMultipart) => _$this._isMultipart = isMultipart;

  bool _isFormEncoded;
  bool get isFormEncoded => _$this._isFormEncoded;
  set isFormEncoded(bool isFormEncoded) =>
      _$this._isFormEncoded = isFormEncoded;

  ListBuilder<ParameterHandler<Object>> _parameterHandlers;
  ListBuilder<ParameterHandler<Object>> get parameterHandlers =>
      _$this._parameterHandlers ??= new ListBuilder<ParameterHandler<Object>>();
  set parameterHandlers(
          ListBuilder<ParameterHandler<Object>> parameterHandlers) =>
      _$this._parameterHandlers = parameterHandlers;

  TypeValue _returnType;
  TypeValue get returnType => _$this._returnType;
  set returnType(TypeValue returnType) => _$this._returnType = returnType;

  AnnotationInfoBuilder();

  AnnotationInfoBuilder get _$this {
    if (_$v != null) {
      _httpMethod = _$v.httpMethod;
      _relativeUrl = _$v.relativeUrl;
      _isMultipart = _$v.isMultipart;
      _isFormEncoded = _$v.isFormEncoded;
      _parameterHandlers = _$v.parameterHandlers?.toBuilder();
      _returnType = _$v.returnType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnnotationInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AnnotationInfo;
  }

  @override
  void update(void Function(AnnotationInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AnnotationInfo build() {
    _$AnnotationInfo _$result;
    try {
      _$result = _$v ??
          new _$AnnotationInfo._(
              httpMethod: httpMethod,
              relativeUrl: relativeUrl,
              isMultipart: isMultipart,
              isFormEncoded: isFormEncoded,
              parameterHandlers: parameterHandlers.build(),
              returnType: returnType);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'parameterHandlers';
        parameterHandlers.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AnnotationInfo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
