import 'package:flutter/material.dart';
import 'package:gate_sim/components/line_object.dart';
import 'package:gate_sim/components/moveable_object.dart';

class DrawingBoard extends StatefulWidget {
  final List<Line>? lines;

  const DrawingBoard({Key? key, this.lines}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
//      painter: LinePainter(widget.lines ?? []),
      child: Stack(
        children: [
          MoveAbleObjectWidget(
            height: 100,
            width: 200,
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
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
