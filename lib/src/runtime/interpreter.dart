import 'package:rudi/src/frontend/ast.dart';
import 'package:rudi/src/frontend/node_type.dart';
import 'package:rudi/src/runtime/environment.dart';
import 'package:rudi/src/runtime/eval/expressions.dart';
import 'package:rudi/src/runtime/eval/statements.dart';
import 'package:rudi/src/runtime/values.dart';

RuntimeValue evaluate(Statement astNode, Environment environment) {
  switch (astNode.kind) {
    case NodeType.numericLitaral:
      return NumberValue(
        value: (astNode as NumericLiteral).number,
      );
    case NodeType.identifier:
      return evaluateIdentifier(
        astNode as Identifier,
        environment,
      );
    case NodeType.mapLiteral:
      return evaluateMapLiteral(
        astNode as MapLiteral,
        environment,
      );
    case NodeType.assignmentExpression:
      return evaluateAssignmentExpression(
        astNode as AssignmentExpression,
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
    case NodeType.variableDeclaration:
      return evaluateVariableDeclaration(
        astNode as VariableDecleration,
        environment,
      );
    default:
      throw UnimplementedError(
        "$astNode has not yet been setup for interpretation.",
      );
  }
}
