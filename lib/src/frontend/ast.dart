import 'package:rudi/src/frontend/node_type.dart';

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
          kind: NodeType.numaricLitaral,
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
