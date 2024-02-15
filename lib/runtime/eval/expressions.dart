import 'package:rudi/exeptions.dart';
import 'package:rudi/frontend/ast.dart';
import 'package:rudi/frontend/node_type.dart';
import 'package:rudi/runtime/environment.dart';
import 'package:rudi/runtime/interpreter.dart';
import 'package:rudi/runtime/values.dart';

RuntimeValue evaluateBinaryExpression(
  BinaryExpression binaryExpression,
  Environment environment,
) {
  final left = evaluate(binaryExpression.left, environment);
  final right = evaluate(binaryExpression.right, environment);

  if (left.type == ValueType.number && right.type == ValueType.number) {
    return _evaluateNumericBinaryExpression(
      left as NumberValue,
      right as NumberValue,
      binaryExpression.operator,
    );
  }

  // One or both values are null
  return NullValue();
}

NumberValue _evaluateNumericBinaryExpression(
  NumberValue left,
  NumberValue right,
  BinaryOperator operator,
) {
  num result = 0;

  switch (operator) {
    case BinaryOperator.add:
      result = left.value + right.value;
      break;
    case BinaryOperator.subtract:
      result = left.value - right.value;
      break;
    case BinaryOperator.multiply:
      result = left.value * right.value;
      break;
    case BinaryOperator.divide:
      // Prevent division by zero
      if (right.value == 0) {
        throw DivisionByZeroException();
      }

      result = left.value / right.value;
      break;
    case BinaryOperator.modulo:
      result = left.value % right.value;
      break;
  }

  return NumberValue(
    value: result,
  );
}

RuntimeValue evaluateIdentifier(
  Identifier identifier,
  Environment environment,
) {
  final value = environment.lookupVariable(identifier.symbol);

  return value;
}

RuntimeValue evaluateAssignmentExpression(
  AssignmentExpression assignmentExpression,
  Environment environment,
) {
  if (assignmentExpression.assigne.kind != NodeType.identifier) {
    throw "Invalid assignment target [${assignmentExpression.assigne.kind}].";
  }

  final varName = (assignmentExpression.assigne as Identifier).symbol;

  return environment.assignVariable(
    varName,
    evaluate(assignmentExpression.value, environment),
  );
}

RuntimeValue evaluateMapLiteral(
  MapLiteral mapLiteral,
  Environment environment,
) {
  final map = MapValue(properties: {});

  for (final property in mapLiteral.properties) {
    final runtimeValue = property.value == null
        ? environment.lookupVariable(property.key)
        : evaluate(property.value!, environment);

    map.properties[property.key] = runtimeValue;
  }

  return map;
}
