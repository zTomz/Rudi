import 'dart:math';

import 'package:rudi/rudi.dart';
import 'dart:io';

import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/values.dart';

void main(List<String> args) async {
  final Parser parser = Parser();
  final Environment environment = Environment();

  // Create default global variables
  environment.declareVariable("true", BooleanValue(value: true), true);
  environment.declareVariable("false", BooleanValue(value: false), true);
  environment.declareVariable("null", NullValue(), true);
  environment.declareVariable("pi", NumberValue(value: pi), true);

  final input = File(args[0]).readAsStringSync();
  final program = parser.produceAST(input);
  final result = evaluate(program, environment);

  print(result);
}
