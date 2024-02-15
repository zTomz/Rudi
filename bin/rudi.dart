import 'dart:io';

import 'package:rudi/frontend/parser.dart';
import 'package:rudi/runtime/environment.dart';
import 'package:rudi/runtime/interpreter.dart';

void main(List<String> args) async {
  final Parser parser = Parser();
  final Environment environment = Environment();


  final input = File(args[0]).readAsStringSync();
  final program = parser.produceAST(input);
  evaluate(program, environment);
}
