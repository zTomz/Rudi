import 'dart:math';

import 'package:rudi/exeptions.dart';
import 'package:rudi/runtime/values.dart';

class Environment {
  Environment? parent;
  Map<String, RuntimeValue> variables;
  Set<String> constants;
  bool global;

  Environment({
    this.parent,
  })  : variables = {},
        constants = {},
        global = parent == null ? true : false {
    if (global) {
      setuptScope(this);
    }
  }

  RuntimeValue declareVariable(
      String variableName, RuntimeValue value, bool isConst) {
    if (variables.containsKey(variableName)) {
      throw VariableAlreadyExistsException(variableName);
    }

    variables[variableName] = value;

    if (isConst) {
      constants.add(variableName);
    }

    return value;
  }

  RuntimeValue assignVariable(String variableName, RuntimeValue value) {
    final env = resolve(variableName);

    // Cannot assign to a constant
    if (env.constants.contains(variableName)) {
      throw "Cannot reassign a constant. Trying to reassign constant [$variableName].";
    }
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

/// Setup the default scope
void setuptScope(Environment environment) {
  environment.declareVariable("true", BooleanValue(value: true), true);
  environment.declareVariable("false", BooleanValue(value: false), true);
  environment.declareVariable("null", NullValue(), true);
  environment.declareVariable("pi", NumberValue(value: pi), true);
}
