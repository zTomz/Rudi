import 'package:rudi/exeptions.dart';
import 'package:rudi/frontend/ast.dart';
import 'package:rudi/frontend/lexer.dart';
import 'package:rudi/frontend/token.dart';

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
      case TokenType.constType:
        return _parseVariableDeclaration();
      case TokenType.fn:
        return _parseFunctionDeclaration();
      default:
        return _parseExpression();
    }
  }

  Statement _parseFunctionDeclaration() {
    tokens.removeAt(0); // Remove 'fn' keyword

    final name = _expect(
      TokenType.identifier,
      "Expected function name.",
    ).value;

    _expect(
      TokenType.openParen,
      "Expected '(' after function name.",
    );

    List<String> parameters =
        tokens[0].type == TokenType.closeParen ? [] : _parseParameters();

    _expect(
      TokenType.openBrace,
      "Expected '{' before function body.",
    );

    List<Statement> body = [];

    while (_notEof() && tokens[0].type != TokenType.closeBrace) {
      body.add(_parseStatement());
    }

    _expect(
      TokenType.closeBrace,
      "Expected '}' after function body.",
    );

    return FunctionDecleration(
      name: name,
      parameters: parameters,
      body: body,
    );
  }

  List<String> _parseParameters() {
    List<String> parameters = [
      _expect(
        TokenType.identifier,
        "Expected parameter name.",
      ).value,
    ];

    while (tokens[0].type == TokenType.comma) {
      tokens.removeAt(0);

      final parameter = _expect(
        TokenType.identifier,
        "Expected parameter name.",
      );

      parameters.add(parameter.value);
    }

    _expect(
      TokenType.closeParen,
      "Expected ')' after parameters.",
    );

    return parameters;
  }

  Statement _parseVariableDeclaration() {
    final isConst = tokens.removeAt(0).type == TokenType.constType;
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
    final left = _parseMapExpression();

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

  Expression _parseMapExpression() {
    if (tokens[0].type != TokenType.openBrace) {
      return _parseAdditiveExpression();
    }

    tokens.removeAt(0); // Go past open brace
    List<Property> properties = [];

    while (_notEof() && tokens[0].type != TokenType.closeBrace) {
      final key = _expect(
        TokenType.string,
        "Map literal key expected.",
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
      case TokenType.string:
        return StringLiteral(
          value: tokens.removeAt(0).value,
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
    Expression left = _parseCallMemberExpression();

    while (tokens[0].value == "*" ||
        tokens[0].value == "/" ||
        tokens[0].value == "%") {
      final operator = tokens.removeAt(0).value;
      BinaryOperator binaryOperator = operator == "*"
          ? BinaryOperator.multiply
          : operator == "/"
              ? BinaryOperator.divide
              : BinaryOperator.modulo;

      final right = _parseCallMemberExpression();

      left = BinaryExpression(
        left: left,
        right: right,
        operator: binaryOperator,
      );
    }

    return left;
  }

  Expression _parseCallMemberExpression() {
    final member = _parseMemberExpression();

    if (tokens[0].type == TokenType.openParen) {
      return _parseCallExpression(member);
    }

    return member;
  }

  CallExpression _parseCallExpression(Expression caller) {
    CallExpression callExprssion = CallExpression(
      caller: caller,
      arguments: _parseArgs(),
    );

    if (tokens[0].type == TokenType.openParen) {
      callExprssion = _parseCallExpression(callExprssion);
    }

    if (tokens[0].type != TokenType.closeParen && tokens[0].type != TokenType.comma) {
      _expect(
        TokenType.semiColon,
        "Expected semi colon after call.",
      );
    }

    return callExprssion;
  }

  Expression _parseMemberExpression() {
    Expression map = _parsePrimaryExpression();

    while (tokens[0].type == TokenType.dot ||
        tokens[0].type == TokenType.identifier) {
      final operator = tokens.removeAt(0);

      Expression property;
      bool computed;

      // Non computed values aka map.expr
      if (operator.type == TokenType.dot) {
        computed = false;
        // Get identifier
        property = _parsePrimaryExpression();

        if (property is! Identifier) {
          throw "Cannot use dot operator on non-identifier.";
        }
      } else {
        // This allows map[key]
        computed = true;
        property = _parseExpression();

        _expect(
          TokenType.closeBracket,
          "Missing closing bracket in computed value.",
        );
      }

      map = MemberExpression(
        map: map,
        property: property,
        computed: computed,
      );
    }

    return map;
  }

  List<Expression> _parseArgs() {
    _expect(
      TokenType.openParen,
      "Expected open parenthesis.",
    );

    final args = tokens[0].type == TokenType.closeParen
        ? <Expression>[]
        : _parseArgumentsList();

    _expect(
      TokenType.closeParen,
      "Missing closing parenthesis.",
    );

    return args;
  }

  List<Expression> _parseArgumentsList() {
    List<Expression> args = [
      _parseExpression(),
    ];

    while (tokens[0].type == TokenType.comma) {
      tokens.removeAt(0);

      args.add(
        _parseExpression(),
      );
    }

    return args;
  }
}
