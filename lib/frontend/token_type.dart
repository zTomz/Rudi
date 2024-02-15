enum TokenType {
  // Literal Types
  number,
  identifier,
  // Keywords
  let,
  constType,
  // Grouping * Operators
  binaryOperator,
  equals,
  comma,
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
