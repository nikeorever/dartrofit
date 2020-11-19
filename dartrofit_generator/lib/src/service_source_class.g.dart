// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_source_class.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ServiceSourceClass extends ServiceSourceClass {
  @override
  final ClassElement element;
  ParsedLibraryResult __parsedLibrary;
  String __name;
  String __implName;
  BuiltList<String> __genericParameters;
  bool __isAbstract;
  ClassDeclaration __classDeclaration;
  String __source;
  String __partStatement;
  bool __extendsIsAllowed;
  bool __fieldIsAllowed;
  BuiltList<ConstructorDeclaration> __classConstructors;
  BuiltList<ConstructorDeclaration> __classFactories;
  BuiltList<MethodElement> __abstractMethods;
  bool __hasPartStatement;
  bool __hasDartrofitImportWithShow;
  bool __hasDartrofitImportWithAs;

  factory _$ServiceSourceClass(
          [void Function(ServiceSourceClassBuilder) updates]) =>
      (new ServiceSourceClassBuilder()..update(updates)).build();

  _$ServiceSourceClass._({this.element}) : super._() {
    if (element == null) {
      throw new BuiltValueNullFieldError('ServiceSourceClass', 'element');
    }
  }

  @override
  ParsedLibraryResult get parsedLibrary =>
      __parsedLibrary ??= super.parsedLibrary;

  @override
  String get name => __name ??= super.name;

  @override
  String get implName => __implName ??= super.implName;

  @override
  BuiltList<String> get genericParameters =>
      __genericParameters ??= super.genericParameters;

  @override
  bool get isAbstract => __isAbstract ??= super.isAbstract;

  @override
  ClassDeclaration get classDeclaration =>
      __classDeclaration ??= super.classDeclaration;

  @override
  String get source => __source ??= super.source;

  @override
  String get partStatement => __partStatement ??= super.partStatement;

  @override
  bool get extendsIsAllowed => __extendsIsAllowed ??= super.extendsIsAllowed;

  @override
  bool get fieldIsAllowed => __fieldIsAllowed ??= super.fieldIsAllowed;

  @override
  BuiltList<ConstructorDeclaration> get classConstructors =>
      __classConstructors ??= super.classConstructors;

  @override
  BuiltList<ConstructorDeclaration> get classFactories =>
      __classFactories ??= super.classFactories;

  @override
  BuiltList<MethodElement> get abstractMethods =>
      __abstractMethods ??= super.abstractMethods;

  @override
  bool get hasPartStatement => __hasPartStatement ??= super.hasPartStatement;

  @override
  bool get hasDartrofitImportWithShow =>
      __hasDartrofitImportWithShow ??= super.hasDartrofitImportWithShow;

  @override
  bool get hasDartrofitImportWithAs =>
      __hasDartrofitImportWithAs ??= super.hasDartrofitImportWithAs;

  @override
  ServiceSourceClass rebuild(
          void Function(ServiceSourceClassBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ServiceSourceClassBuilder toBuilder() =>
      new ServiceSourceClassBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServiceSourceClass && element == other.element;
  }

  @override
  int get hashCode {
    return $jf($jc(0, element.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ServiceSourceClass')
          ..add('element', element))
        .toString();
  }
}

class ServiceSourceClassBuilder
    implements Builder<ServiceSourceClass, ServiceSourceClassBuilder> {
  _$ServiceSourceClass _$v;

  ClassElement _element;
  ClassElement get element => _$this._element;
  set element(ClassElement element) => _$this._element = element;

  ServiceSourceClassBuilder();

  ServiceSourceClassBuilder get _$this {
    if (_$v != null) {
      _element = _$v.element;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ServiceSourceClass other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ServiceSourceClass;
  }

  @override
  void update(void Function(ServiceSourceClassBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ServiceSourceClass build() {
    final _$result = _$v ?? new _$ServiceSourceClass._(element: element);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
