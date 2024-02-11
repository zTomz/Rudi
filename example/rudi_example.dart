import 'dart:math';

import 'package:rudi/rudi.dart';
import 'dart:io';

import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/values.dart';

void main() async {
  final Parser parser = Parser();

  final Environment environment = Environment();

  environment.declareVariable("true", BooleanValue(value: true), true);
  environment.declareVariable("false", BooleanValue(value: false), true);
  environment.declareVariable("null", NullValue(), true);
  environment.declareVariable("pi", NumberValue(value: pi), true);

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
