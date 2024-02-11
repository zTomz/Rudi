enum TokenType {
  nullType, // 'null' can't be used as an identifier because it's a keyword.
  number,
  identifier,
  equals,
  let,
  binaryOperator,
  openParen,
  closeParen,
  semiColon,
  eof, // Signified the end of a file
}