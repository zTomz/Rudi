import 'package:rudi/rudi.dart';
import 'dart:io';

import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/values.dart';

void main() async {
  final Parser parser = Parser();

  final Environment environment = Environment();
  // Create Default Global Enviornment
  environment.declareVariable("x", NumberValue(value: 100));
  environment.declareVariable("true", BooleanValue(value: true));
  environment.declareVariable("false", BooleanValue(value: false));
  environment.declareVariable("null", NullValue());

  print("Rudi v0.1");
  while (true) {
    stdout.write("> ");
    final input = stdin.readLineSync() ?? "";

    if (input == "exit") {
      exit(0);
    }

    final program = parser.produceAST(input);
    print("Program: $program");

    final result = evaluate(program, environment);
    print("Result: $result");
  }
}
