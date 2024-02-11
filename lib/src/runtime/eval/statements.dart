import 'package:rudi/src/frontend/ast.dart';
import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/interpreter.dart';
import 'package:rudi/src/runtime/values.dart';

RuntimeValue evaluateProgram(Program program, Environment environment) {
  RuntimeValue lastEvaluated = NullValue();

  for (final statement in program.body) {
    lastEvaluated = evaluate(statement, environment);
  }

  return lastEvaluated;
}

RuntimeValue evaluateIdentifier(
  Identifier identifier,
  Environment environment,
) {
  final value = environment.lookupVariable(identifier.symbol);
  return value;
}

RuntimeValue evaluateVariableDeclaration(
  VariableDecleration variableDecleration,
  Environment environment,
) {
  final value = variableDecleration.value != null
      ? evaluate(variableDecleration.value!, environment)
      : NullValue();

  return environment.declareVariable(
    variableDecleration.identifier,
    value,
    variableDecleration.isConst,
  );
}
