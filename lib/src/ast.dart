enum NodeType {
  program,
  numaricLitaral,
  nullLiteral,
  identifier,
  binaryExpr,
}

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

class Expression extends Statement {
  Expression({
    required super.kind,
  });

  @override
  String toString() {
    return 'Expression{kind: $kind}';
  }
}

class BinaryExpression extends Expression {
  final Expression left;
  final Expression right;
  final String operator;

  BinaryExpression({
    required this.left,
    required this.right,
    required this.operator,
  }) : super(
          kind: NodeType.binaryExpr,
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

class NullLiteral extends Expression {
  final String value;

  NullLiteral({
    required this.value,
  }) : super(
          kind: NodeType.nullLiteral,
        );

  @override
  String toString() {
    return 'NullLiteral{value: $value}';
  }
}
