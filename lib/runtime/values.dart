import 'package:rudi/frontend/ast.dart';
import 'package:rudi/runtime/environment.dart';

enum ValueType {
  nullType,
  number,
  string,
  boolean,
  map,
  nativeFunction,
  function,
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

class StringValue extends RuntimeValue {
  final String value;

  StringValue({
    required this.value,
  }) : super(
          type: ValueType.string,
        );

  @override
  String toString() {
    return 'StringValue{value: $value, type: $type}';
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

typedef FunctionCall = RuntimeValue Function(
  List<RuntimeValue> arguments,
  Environment environment,
);

class NativeFunctionValue extends RuntimeValue {
  final FunctionCall call;

  NativeFunctionValue({
    required this.call,
  }) : super(
          type: ValueType.nativeFunction,
        );

  @override
  String toString() {
    return 'NativeFunctionValue{call: $call, type: $type}';
  }
}

class FunctionValue extends RuntimeValue {
  final String name;
  final List<String> parameters;
  final Environment declerationEnvironment;
  final List<Statement> body;

  FunctionValue({
    required this.name,
    required this.parameters,
    required this.body,
    required this.declerationEnvironment,
  }) : super(
          type: ValueType.function,
        );

  @override
  String toString() {
    return 'FunctionValue{name: $name, parameters: $parameters, body: $body, declerationEnvironment: $declerationEnvironment, type: $type}';
  }
}
