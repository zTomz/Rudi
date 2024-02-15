enum ValueType {
  nullType,
  number,
  boolean,
  map,
}

class RuntimeValue {
  final ValueType type;

  RuntimeValue({
    required this.type,
  });
}

class NullValue extends RuntimeValue {
  // ignore: prefer_void_to_null
  final Null value;

  NullValue({
    this.value,
  }) : super(
          type: ValueType.nullType,
        );

  @override
  String toString() {
    return 'NullValue{value: $value, type: $type}';
  }
}

class BooleanValue extends RuntimeValue {
  final bool value;

  BooleanValue({
    required this.value,
  }) : super(
          type: ValueType.boolean,
        );

  @override
  String toString() {
    return 'BooleanValue{value: $value, type: $type}';
  }
}

class NumberValue extends RuntimeValue {
  final num value;

  NumberValue({
    required this.value,
  }) : super(
          type: ValueType.number,
        );

  @override
  String toString() {
    return 'NumberValue{value: $value, type: $type}';
  }
}

class MapValue extends RuntimeValue {
  final Map<String, RuntimeValue> properties;

  MapValue({
    required this.properties,
  }) : super(
          type: ValueType.map,
        );

  @override
  String toString() {
    return 'MapValue{properties: $properties, type: $type}';
  }
}