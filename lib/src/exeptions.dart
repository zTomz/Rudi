class VariableAlreadyExistsException implements Exception {
  String variableName;
  
  VariableAlreadyExistsException(
    this.variableName,
  );

  @override
  String toString() {
    return 'A variable with the name [$variableName] already exists.';
  }
}

class UnknownCharacterException implements Exception {
  String character;

  UnknownCharacterException(
    this.character,
  );

  @override
  String toString() {
    return 'Unknown character: [$character]. Char code: ${character.codeUnitAt(0)}';
  }
}

class ParserException implements Exception {
  String message;

  ParserException(
    this.message,
  );

  @override
  String toString() {
    return 'Parser Exception: $message';
  }
}

class UnexpectedTokenException implements Exception {
  String token;

  UnexpectedTokenException(
    this.token,
  );

  @override
  String toString() {
    return 'Unexpected token: $token';
  }
}

class DivisionByZeroException implements Exception {
  @override
  String toString() {
    return 'The division by zero is not allowed.';
  }
}