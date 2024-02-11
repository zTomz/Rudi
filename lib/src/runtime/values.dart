enum ValueType {
  nullType,
  number,
}

class RuntimeValue {
  final ValueType type;

  RuntimeValue({
    required this.type,
  });
}

class NullValue extends RuntimeValue {
  final String value;

  NullValue({
    this.value = "null",
  }) : super(
          type: ValueType.nullType,
        );

  @override
  String toString() {
    return 'NullValue{value: $value}';
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
    return 'NumberValue{value: $value}';
  }
}
