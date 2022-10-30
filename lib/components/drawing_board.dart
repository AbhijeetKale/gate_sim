import 'package:flutter/material.dart';
import 'package:gate_sim/components/line_object.dart';
import 'package:gate_sim/components/logic_gate_box.dart';
import 'package:gate_sim/models/circuit.dart';

class DrawingBoard extends StatefulWidget {
  final Circuit? circuit;

  const DrawingBoard({Key? key, this.circuit}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  late Circuit circuit;

  @override
  void initState() {
    super.initState();
    circuit = widget.circuit ?? Circuit();
  }

  List<Widget> _buildNodeWidget() {
    List<Widget> result = [];
    for (Node node in circuit.nodes) {
      result.add(
        Positioned(
          left: node.position.dx,
          top: node.position.dy,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                node.position += details.delta;
              });
            },
            child: LogicGateWidget(
              inputCount: node.maxPossibleInputCount,
              outputCount: node.maxPossibleOutputCount,
              child: Center(child: Text(node.label ?? node.id)),
            ),
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
            ),
            height: constraints.maxHeight * 0.9,
            child: InteractiveViewer(
              child: CustomPaint(
                child: Stack(
                  children: _buildNodeWidget(),
                ),
              ),
            ),
          ),
          ButtonBar(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      circuit.addNode(Node(position: Offset(200, 200)));
                    });
                  },
                  child: Text("And Gate"))
            ],
          )
        ],
      );
    });
  }
}

class LinePainter extends CustomPainter {
  List<Line> lines;

  LinePainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()..color = Colors.black;
    for (Line line in lines) {
      _drawLine(canvas, line, p);
    }
  }

  void _drawLine(Canvas canvas, Line line, Paint paint) {
    for (int i = 1; i < line.linePoints.length; i++) {
      canvas.drawLine(line.linePoints[i - 1], line.linePoints[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    if (oldDelegate.lines.length != lines.length) {
      for (int i = 0; i < lines.length; i++) {
        if (lines[i] != oldDelegate.lines[i]) {
          return true;
        }
      }
    }
    return false;
  }
}
