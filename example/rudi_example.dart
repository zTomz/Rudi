import 'package:rudi/rudi.dart';
import 'dart:io';

import 'package:rudi/src/runtime/environment.dart';

void main() async {
  final Parser parser = Parser();

  final Environment environment = Environment();

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
