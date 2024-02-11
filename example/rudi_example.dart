import 'dart:io';

import 'package:rudi/rudi.dart';
import 'package:rudi/src/runtime/environment.dart';

void main(List<String> args) async {
  final Parser parser = Parser();
  final Environment environment = Environment();


  final input = File(args[0]).readAsStringSync();
  final program = parser.produceAST(input);
  final result = evaluate(program, environment);

  print(result);
}
