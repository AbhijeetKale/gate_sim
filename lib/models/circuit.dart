import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:gate_sim/util/id_util.dart';

/// A [Connection] refers to a single output or value that can be split and supplied
/// to multiple nodes within the circuit
class Connection {
  String id;

  /// all destinations where the below [value] will be given as input by this single connnection
  List<Node> destinationNode;

  /// [value] determines whether a connection has a value of 0 or 1
  bool value;

  Connection({String? id, List<Node>? destinationNode, this.value = false})
      : destinationNode = destinationNode ?? [],
        id = id ?? IdUtil.newId();
}

class Node {
  /// ID of a nodal component in the circuit
  String id;

  String? label;

  Offset position;

  int maxPossibleOutputCount;

  int maxPossibleInputCount;

  /// A list of outputs (not connection nodes) which are sent to different nodes
  /// in the circuit
  List<Connection> outputConnections;

  Future<void> calculateOutput() async {}

  Node(
      {String? id,
      List<Connection>? outputConnections,
      Offset? position,
      this.maxPossibleOutputCount = 1,
      this.label,
      this.maxPossibleInputCount = 1})
      : assert((outputConnections?.length ?? 0) <= maxPossibleOutputCount),
        id = id ?? IdUtil.newId(),
        position = position ?? Offset.zero,
        outputConnections = outputConnections ?? [];

  @override
  bool operator ==(Object other) => other is Node && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InputSwitch extends Node {
  InputSwitch(String? id, List<Connection> outputConnections, this.value)
      : assert(outputConnections.length == 1),
        super(id: id, outputConnections: outputConnections);
  bool value;

  @override
  Future<void> calculateOutput() async => outputConnections.first.value = value;
}

class OutPutDisplay extends Node {
  OutPutDisplay(String? id, List<Connection>? inputConnections)
      : super(id: id, outputConnections: List.empty());
}

class Circuit {
  final List<Node> _circuitComponents;

  List<Node> get nodes => _circuitComponents;

  Map<Node, List<Connection>>? _inputConnectionMap;

  Circuit({List<Node>? circuitComponents})
      : _circuitComponents = circuitComponents ?? [] {
    _buildDependencyGraph();
  }

  List<Connection>? getNodeInputs(Node node) => _inputConnectionMap?[node];

  void addNode(Node node) {
    _circuitComponents.add(node);
    _buildDependencyGraph();
  }

  void _buildDependencyGraph() {
    _inputConnectionMap?.clear();
    _inputConnectionMap = _inputConnectionMap ?? HashMap();
    for (Node n in _circuitComponents) {
      for (Connection output in n.outputConnections) {
        for (Node destinationNode in output.destinationNode) {
          _inputConnectionMap?.putIfAbsent(destinationNode, () => []);
          _inputConnectionMap?[destinationNode]?.add(output);
        }
      }
    }
  }
}
