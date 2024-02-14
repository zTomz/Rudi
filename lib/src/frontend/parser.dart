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
    switch (tokens[0].type) {
      case TokenType.let:
        return _parseVariableDeclaration();
      case TokenType.finalType:
        return _parseVariableDeclaration();
      default:
        return _parseExpression();
    }
  }

  Statement _parseVariableDeclaration() {
    final isConst = tokens.removeAt(0).type == TokenType.finalType;
    final identifier = _expect(
      TokenType.identifier,
      "Expected identifier name after let or const keyword.",
    ).value;

    if (tokens[0].type == TokenType.semiColon) {
      tokens.removeAt(0);

      if (isConst) {
        throw "Must assign a value to const expressions. No value provided.";
      }

      return VariableDecleration(
        isConst: false,
        identifier: identifier,
      );
    }

    _expect(TokenType.equals, "Expected '=' identifier after variable name.");

    final decleration = VariableDecleration(
      isConst: isConst,
      identifier: identifier,
      value: _parseExpression(),
    );

    _expect(
      TokenType.semiColon,
      "Expected ';' after variable declaration.",
    );

    return decleration;
  }

  Expression _parseExpression() {
    return _parseAssignmentExpression();
  }

  Expression _parseAssignmentExpression() {
    final left = _parsemapExpression();

    if (tokens[0].type == TokenType.equals) {
      tokens.removeAt(0); // advance past the equal
      final value = _parseAssignmentExpression(); // Allow chaining

      _expect(
        TokenType.semiColon,
        "Expected ';' after assignment.",
      );

      return AssignmentExpression(
        assigne: left,
        value: value,
      );
    }

    return left;
  }

  Expression _parsemapExpression() {
    if (tokens[0].type != TokenType.openBrace) {
      return _parseAdditiveExpression();
    }

    tokens.removeAt(0); // Go past open brace
    List<Property> properties = [];

    while (_notEof() && tokens[0].type != TokenType.closeBrace) {
      final key = _expect(
        TokenType.identifier,
        "map literal key expected.",
      ).value;

      // Allows shorthand key: pair -> { key, }
      if (tokens[0].type == TokenType.comma) {
        tokens.removeAt(0); // Go advance the comma

        properties.add(
          Property(key: key, value: null),
        );
        continue;
      } else if (tokens[0].type == TokenType.closeBrace) {
        // Allows shorthand key: pair -> { key }
        properties.add(
          Property(key: key, value: null),
        );
        continue;
      }

      _expect(
        TokenType.colon,
        "Missing colon [\" : \"] following identifier in mapExpr.",
      );

      final value = _parseExpression();

      properties.add(
        Property(key: key, value: value),
      );
      if (tokens[0].type != TokenType.closeBrace) {
        _expect(
          TokenType.comma,
          "Expected comma or closing brace following property.",
        );
      }
    }

    _expect(
      TokenType.closeBrace,
      "map literal missing closing brace.",
    );

    return MapLiteral(
      properties: properties,
    );
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
          "Missing closing paren.",
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
