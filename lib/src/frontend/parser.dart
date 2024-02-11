import 'package:rudi/rudi.dart';
import 'package:rudi/src/exeptions.dart';
import 'package:rudi/src/frontend/ast.dart';
import 'package:rudi/src/frontend/token_type.dart';

class Parser {
  List<Token> tokens = [];

  Program produceAST(String sourceCode) {
    tokens = tokenize(sourceCode);

    Program program = Program(
      body: [],
    );

    while (_notEof()) {
      program.body.add(
        _parseStatement(),
      );
    }

    return program;
  }

  bool _notEof() {
    return tokens[0].type != TokenType.eof;
  }

  Token _expect(TokenType type, dynamic error) {
    final prev = tokens.removeAt(0);
    if (prev.type != type) {
      throw ParserException(error.toString());
    }

    return prev;
  }

  Statement _parseStatement() {
    // skip to parse_expr
    return _parseExpression();
  }

  Expression _parseExpression() {
    return _parseAdditiveExpression();
  }

  Expression _parsePrimaryExpression() {
    final token = tokens[0].type;

    switch (token) {
      case TokenType.identifier:
        return Identifier(
          symbol: tokens.removeAt(0).value,
        );
      case TokenType.number:
        return NumericLiteral(
          number: double.parse(tokens.removeAt(0).value),
        );
      case TokenType.openParen:
        tokens.removeAt(0); // Remove opening paren
        final value = _parseExpression();
        _expect(
          TokenType.closeParen,
          "Missing closing paren",
        ); // Closing paren
        return value;
      default:
        throw UnexpectedTokenException(token.toString());
    }
  }

  Expression _parseAdditiveExpression() {
    Expression left = _parseMultiplicativeExpression();

    while (tokens[0].value == "+" || tokens[0].value == "-") {
      final operator = tokens.removeAt(0).value;
      BinaryOperator binaryOperator =
          operator == "+" ? BinaryOperator.add : BinaryOperator.subtract;
      final right = _parseMultiplicativeExpression();

      left = BinaryExpression(
        left: left,
        right: right,
        operator: binaryOperator,
      );
    }

    return left;
  }

  Expression _parseMultiplicativeExpression() {
    Expression left = _parsePrimaryExpression();

    while (tokens[0].value == "*" ||
        tokens[0].value == "/" ||
        tokens[0].value == "%") {
      final operator = tokens.removeAt(0).value;
      BinaryOperator binaryOperator = operator == "*"
          ? BinaryOperator.multiply
          : operator == "/"
              ? BinaryOperator.divide
              : BinaryOperator.modulo;

      final right = _parsePrimaryExpression();

      left = BinaryExpression(
        left: left,
        right: right,
        operator: binaryOperator,
      );
    }

    return left;
  }
}
