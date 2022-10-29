import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gate_sim/components/led_display_widget.dart';
import 'package:gate_sim/util/id_util.dart';

/// A [Connection] refers to a single output or value that can be split and supplied
/// to multiple nodes within the circuit
class Connection {
  /// all destinations where the below [value] will be given as input by this single connnection
  List<Node> destinationNode;

  /// [value] determines whether a connection has a value of 0 or 1
  bool value;

  Connection({List<Node>? destinationNode, this.value = false})
      : destinationNode = destinationNode ?? [];
}

abstract class Node {
  /// ID of a nodal component in the circuit
  String id;

  /// A list of outputs (not connection nodes) which are sent to different nodes
  /// in the circuit
  List<Connection> outputConnections;

  Node({String? id, List<Connection>? outputConnections})
      : id = id ?? IdUtil.newId(),
        outputConnections = outputConnections ?? [];

  /// [getWidget] returns a widget related to the nodal component of a circuit
  Widget getWidget();
}

class InputSwitch extends Node {
  InputSwitch(String? id, List<Connection>? outputConnections)
      : super(id: id, outputConnections: outputConnections);

  @override
  Widget getWidget() => const LedDisplayWidget();
}

class OutPutDisplay extends Node {
  OutPutDisplay(String? id) : super(id: id, outputConnections: List.empty());

  @override
  Widget getWidget() => const LedDisplayWidget();
}

class Circuit {
  List<InputSwitch> inputNodes;

  List<OutPutDisplay> outputNodes;

  List<Node> intermediateComponents;

  Circuit(
      {required this.inputNodes,
      required this.outputNodes,
      required this.intermediateComponents});
}
