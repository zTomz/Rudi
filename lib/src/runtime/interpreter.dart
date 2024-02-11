import 'dart:io';

import 'package:rudi/src/exeptions.dart';
import 'package:rudi/src/frontend/ast.dart';
import 'package:rudi/src/runtime/values.dart';

RuntimeValue evaluate(Statement astNode) {
  switch (astNode.kind) {
    case NodeType.numaricLitaral:
      return NumberValue(
        value: (astNode as NumericLiteral).number,
      );
    case NodeType.nullLiteral:
      return NullValue();
    case NodeType.binaryExpression:
      return evaluateBinaryExpression(astNode as BinaryExpression);
    case NodeType.program:
      return evaluateProgram(astNode as Program);
    default:
      throw UnimplementedError(
        "$astNode has not yet been setup for interpretation.",
      );
  }
}

RuntimeValue evaluateProgram(Program program) {
  RuntimeValue lastEvaluated = NullValue();

  for (final statement in program.body) {
    lastEvaluated = evaluate(statement);
  }

  return lastEvaluated;
}

RuntimeValue evaluateBinaryExpression(BinaryExpression binaryExpression) {
  final left = evaluate(binaryExpression.left);
  final right = evaluate(binaryExpression.right);

  if (left.type == ValueType.number && right.type == ValueType.number) {
    return evaluateNumericBinaryExpression(
      left as NumberValue,
      right as NumberValue,
      binaryExpression.operator,
    );
  }

  // One or both values are null
  return NullValue();
}

NumberValue evaluateNumericBinaryExpression(
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
