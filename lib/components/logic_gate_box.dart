import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LogicGateWidget extends SingleChildRenderObjectWidget {
  const LogicGateWidget(
      {this.inputCount = 1,
      this.outputCount = 1,
      this.nodeSize = 20,
      Widget? child,
      Key? key})
      : assert(inputCount > 0),
        assert(outputCount > 0),
        assert(nodeSize > 0),
        super(key: key, child: child);

  final int inputCount;

  final int outputCount;

  final int nodeSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      LogicGateBox(inputCount, outputCount, nodeSize);

  @override
  void updateRenderObject(
      BuildContext context, covariant LogicGateBox renderObject) {
    renderObject
      ..inputCount = inputCount
      ..outputCount = outputCount
      ..nodeSize = nodeSize;
  }
}

class LogicGateBox extends RenderProxyBox {
  int _inputCount;

  int _outputCount;

  int _nodeSize;

  LogicGateBox(this._inputCount, this._outputCount, this._nodeSize,
      [RenderBox? child])
      : assert(_inputCount > 0),
        assert(_outputCount > 0),
        assert(_nodeSize > 0),
        super(child);

  int get inputCount => _inputCount;

  set inputCount(int value) {
    _inputCount = value;
    markNeedsLayout();
  }

  int get outputCount => _outputCount;

  set outputCount(int value) {
    _outputCount = value;
    markNeedsLayout();
  }

  int get nodeSize => _nodeSize;

  set nodeSize(int value) {
    _nodeSize = value;
    markNeedsLayout();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);
    _drawInputNodes(canvas);
    _drawOutputNodes(canvas);
    canvas.restore();
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  void _drawInputNodes(Canvas canvas) {
    double inputGap =
        (size.height - (inputCount * nodeSize)) / (inputCount + 1);
    Paint inputPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    double currentStartPoint = 0;
    for (int i = 0; i < inputCount; i++) {
      currentStartPoint += inputGap;
      Rect rect;
      canvas.drawRect(
          Rect.fromLTWH(
              0, currentStartPoint, nodeSize.toDouble(), nodeSize.toDouble()),
          inputPaint);
      currentStartPoint += nodeSize;
    }
  }

  void _drawOutputNodes(Canvas canvas) {
    double outputGap =
        (size.height - (outputCount * nodeSize)) / (outputCount + 1);
    Paint inputPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    double currentStartPoint = 0;
    for (int i = 0; i < outputCount; i++) {
      currentStartPoint += outputGap;
      canvas.drawRect(
          Rect.fromLTWH(size.width - nodeSize, currentStartPoint,
              nodeSize.toDouble(), nodeSize.toDouble()),
          inputPaint);
      currentStartPoint += nodeSize;
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
    assert(constraints.maxHeight > inputCount * nodeSize,
        "This generally happens if the all input nodes cannot be fitted into the logic gate\nnodeSize = $nodeSize, no of output nodes = $inputCount max height available = ${constraints.maxHeight}");
    assert(constraints.maxHeight > outputCount * nodeSize,
        "This generally happens if the all output nodes cannot be fitted into the logic gate\nnodeSize = $nodeSize, no of output nodes = $outputCount max height available = ${constraints.maxHeight}");
    child?.layout(BoxConstraints(maxHeight: size.height, maxWidth: size.width));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    Size childSize = child?.getDryLayout(constraints) ?? Size.zero;
    int maxNodeCount = max(inputCount, outputCount);
    var offset = Size(childSize.width + 3 * nodeSize.toDouble(),
        max(childSize.height, (2 * maxNodeCount + 1) * nodeSize.toDouble()));
    return constraints.constrain(offset);
  }
}
