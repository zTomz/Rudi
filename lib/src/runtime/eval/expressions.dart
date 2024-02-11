import 'package:rudi/src/exeptions.dart';
import 'package:rudi/src/frontend/ast.dart';
import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/interpreter.dart';
import 'package:rudi/src/runtime/values.dart';

RuntimeValue evaluateBinaryExpression(
    BinaryExpression binaryExpression, Environment environment) {
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
