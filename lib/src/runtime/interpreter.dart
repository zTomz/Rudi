import 'package:rudi/src/exeptions.dart';
import 'package:rudi/src/frontend/ast.dart';
import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/values.dart';

RuntimeValue evaluate(Statement astNode, Environment environment) {
  switch (astNode.kind) {
    case NodeType.numaricLitaral:
      return NumberValue(
        value: (astNode as NumericLiteral).number,
      );
    case NodeType.identifier:
      return evaluateIdentifier(
        astNode as Identifier,
        environment,
      );
    case NodeType.binaryExpression:
      return evaluateBinaryExpression(
        astNode as BinaryExpression,
        environment,
      );
    case NodeType.program:
      return evaluateProgram(
        astNode as Program,
        environment,
      );
    default:
      throw UnimplementedError(
        "$astNode has not yet been setup for interpretation.",
      );
  }
}

RuntimeValue evaluateProgram(Program program, Environment environment) {
  RuntimeValue lastEvaluated = NullValue();

  for (final statement in program.body) {
    lastEvaluated = evaluate(statement, environment);
  }

  return lastEvaluated;
}

RuntimeValue evaluateBinaryExpression(
    BinaryExpression binaryExpression, Environment environment) {
  final left = evaluate(binaryExpression.left, environment);
  final right = evaluate(binaryExpression.right, environment);

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

RuntimeValue evaluateIdentifier(
  Identifier identifier,
  Environment environment,
) {
  final value = environment.lookupVariable(identifier.symbol);
  return value;
}