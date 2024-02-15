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

enum TokenType {
  // Literal Types
  number,
  string,
  identifier,
  // Keywords
  let,
  constType,
  fn,
  // Grouping * Operators
  binaryOperator,
  equals,
  comma,
  dot,
  openBrace, // {
  closeBrace, // }
  openParen, // (
  closeParen, // )
  openBracket, // [
  closeBracket, // ]
  semiColon, // ;
  colon, // :
  // Signified the end of a file
  eof,
}
