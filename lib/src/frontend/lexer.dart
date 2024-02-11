import 'package:rudi/src/exeptions.dart';
import 'package:rudi/src/frontend/keywords.dart';
import 'package:rudi/src/frontend/token_type.dart';

class Token {
  final String value;
  final TokenType type;

  Token({
    required this.value,
    required this.type,
  });

  @override
  String toString() {
    return 'Token{value: $value, type: $type}';
  }
}

List<Token> tokenize(String sourceCode) {
  List<Token> tokens = [];
  // Split the code into every single character
  List<String> src = sourceCode.split("");

  // Build each token until end of the file
  while (src.isNotEmpty) {
    if (src[0] == '(') {
      tokens.add(
        Token(
          value: src.removeAt(0),
          type: TokenType.openParen,
        ),
      );
    } else if (src[0] == ')') {
      tokens.add(
        Token(
          value: src.removeAt(0),
          type: TokenType.closeParen,
        ),
      );
    } else if (src[0] == '+' ||
        src[0] == '-' ||
        src[0] == '*' ||
        src[0] == '/' ||
        src[0] == '%') {
      tokens.add(
        Token(
          value: src.removeAt(0),
          type: TokenType.binaryOperator,
        ),
      );
    } else if (src[0] == '=') {
      tokens.add(
        Token(
          value: src.removeAt(0),
          type: TokenType.equals,
        ),
      );
    } else if (src[0] == ";") {
      tokens.add(
        Token(
          value: src.removeAt(0),
          type: TokenType.semiColon,
        ),
      );
    } else {
      // Handle multicharacter tokens

      if (isInt(src[0])) {
        String num = "";

        while (src.isNotEmpty && isInt(src[0])) {
          num += src.removeAt(0);
        }

        tokens.add(
          Token(
            value: num,
            type: TokenType.number,
          ),
        );
      } else if (isAlpha(src[0])) {
        String identifier = "";

        while (src.isNotEmpty && isAlpha(src[0])) {
          identifier += src.removeAt(0);
        }

        final reserved = keywords[identifier];
        if (reserved != null) {
          tokens.add(
            Token(
              value: identifier,
              type: reserved,
            ),
          );
        } else {
          tokens.add(
            Token(
              value: identifier,
              type: TokenType.identifier,
            ),
          );
        }
      } else if (isSkippable(src[0])) {
        // Skip the current character
        src.removeAt(0);
      } else {
        throw UnknownCharacterException(src[0]);
      }
    }
  }

  tokens.add(
    Token(
      value: "EndOfFile",
      type: TokenType.eof,
    ),
  );

  return tokens;
}

bool isAlpha(String src) {
  return src.toUpperCase() != src.toLowerCase();
}

bool isInt(String src) {
  return int.tryParse(src) != null;
}

bool isSkippable(String src) {
  return src == " " || src == "\n" || src == "\t" || src == "\r";
}
