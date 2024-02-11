import 'package:rudi/src/exeptions.dart';
import 'package:rudi/src/runtime/values.dart';

class Environment {
  Environment? parent;
  Map<String, RuntimeValue> variables;

  Environment({
    this.parent,
  }) : variables = <String, RuntimeValue>{};

  RuntimeValue declareVariable(String variableName, RuntimeValue value) {
    if (variables.containsKey(variableName)) {
      throw VariableAlreadyExistsException(variableName);
    }

    variables[variableName] = value;
    return value;
  }

  RuntimeValue assignVariable(String variableName, RuntimeValue value) {
    final env = resolve(variableName);
    env.variables[variableName] = value;

    return value;
  }

  RuntimeValue lookupVariable(String variableName) {
    final env = resolve(variableName);
    return env.variables[variableName]!;
  }

  Environment resolve(String variableName) {
    if (variables.containsKey(variableName)) {
      return this;
    }

    if (parent == null) {
      throw VariableDoesNotExistException(variableName);
    }

    return parent!.resolve(variableName);
  }
}
