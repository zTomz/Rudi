import 'package:rudi/frontend/ast.dart';
import 'package:rudi/runtime/environment.dart';
import 'package:rudi/runtime/interpreter.dart';
import 'package:rudi/runtime/values.dart';

RuntimeValue evaluateProgram(Program program, Environment environment) {
  RuntimeValue lastEvaluated = NullValue();

  for (final statement in program.body) {
    lastEvaluated = evaluate(statement, environment);
  }

  return lastEvaluated;
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

RuntimeValue evaluateFunctionDeclaration(
  FunctionDecleration functionDecleration,
  Environment environment,
) {
  final fn = FunctionValue(
    name: functionDecleration.name,
    parameters: functionDecleration.parameters,
    body: functionDecleration.body,
    declerationEnvironment: environment,
  );

  if (environment.exists(functionDecleration.name)) {
    throw "Cannot redeclare function ${functionDecleration.name} in this scope as it already exists.";
  }

  return environment.declareVariable(
    functionDecleration.name,
    fn,
    true,
  );
}
