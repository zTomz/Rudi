import 'package:rudi/frontend/node_type.dart';

class Statement {
  final NodeType kind;

  Statement({
    required this.kind,
  });

  @override
  String toString() {
    return 'Statement{kind: $kind}';
  }
}

class Program extends Statement {
  final List<Statement> body;

  Program({
    required this.body,
  }) : super(
          kind: NodeType.program,
        );

  @override
  String toString() {
    return 'Program{body: $body, kind: $kind}';
  }
}

class VariableDecleration extends Statement {
  final bool isConst;
  final String identifier;
  final Expression? value;

  VariableDecleration({
    required this.isConst,
    required this.identifier,
    this.value,
  }) : super(
          kind: NodeType.variableDeclaration,
        );

  @override
  String toString() {
    return 'VariableDecleration{isConst: $isConst, identifier: $identifier, value: $value, kind: $kind}';
  }
}

class Expression extends Statement {
  Expression({
    required super.kind,
  });

  @override
  String toString() {
    return 'Expression{kind: $kind}';
  }
}

enum BinaryOperator {
  /// Addition [+]
  add,

  /// Subtraction [-]
  subtract,

  /// Multiplication [*]
  multiply,

  /// Division [/]
  divide,

  /// Modulo [%]
  modulo,
}

class BinaryExpression extends Expression {
  final Expression left;
  final Expression right;
  final BinaryOperator operator;

  BinaryExpression({
    required this.left,
    required this.right,
    required this.operator,
  }) : super(
          kind: NodeType.binaryExpression,
        );

  @override
  String toString() {
    return 'BinaryExpression{left: $left, right: $right, operator: $operator}';
  }
}

class CallExpression extends Expression {
  final List<Expression> arguments;
  final Expression caller;

  CallExpression({
    required this.arguments,
    required this.caller,
  }) : super(
          kind: NodeType.callExpression,
        );

  @override
  String toString() {
    return 'CallExpression{arguments: $arguments, caller: $caller, kind: $kind}';
  }
}

class MemberExpression extends Expression {
  final Expression map;
  final Expression property;
  final bool computed;

  MemberExpression({
    required this.map,
    required this.property,
    required this.computed,
  }) : super(
          kind: NodeType.memberExpression,
        );

  @override
  String toString() {
    return 'MemberExpression{map: $map, property: $property, computed: $computed, kind: $kind}';
  }
}

class Identifier extends Expression {
  final String symbol;

  Identifier({
    required this.symbol,
  }) : super(
          kind: NodeType.identifier,
        );

  @override
  String toString() {
    return 'Identifier{symbol: $symbol}';
  }
}

class NumericLiteral extends Expression {
  final num number;

  NumericLiteral({
    required this.number,
  }) : super(
          kind: NodeType.numericLitaral,
        );

  @override
  String toString() {
    return 'NumericLiteral{number: $number}';
  }
}

class AssignmentExpression extends Expression {
  final Expression assigne;
  final Expression value;

  AssignmentExpression({
    required this.assigne,
    required this.value,
  }) : super(
          kind: NodeType.assignmentExpression,
        );
}

class Property extends Expression {
  final String key;
  final Expression? value;

  Property({
    required this.key,
    required this.value,
  }) : super(
          kind: NodeType.property,
        );

  @override
  String toString() {
    return 'Property{key: $key, value: $value, kind: $kind}';
  }
}

class MapLiteral extends Expression {
  final List<Property> properties;

  MapLiteral({
    required this.properties,
  }) : super(
          kind: NodeType.mapLiteral,
        );

  @override
  String toString() {
    return 'mapLiteral{properties: $properties, kind: $kind}';
  }
}
