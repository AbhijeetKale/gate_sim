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
      ..nodeSize = nodeSize
      ..child = renderObject.child;
  }
}

class InputHitTestEntry extends BoxHitTestEntry {
  final int inputNo;

  InputHitTestEntry(this.inputNo, RenderBox target, Offset localPosition)
      : assert(inputNo > 0),
        super(target, localPosition);
}

class OutputHitTestEntry extends BoxHitTestEntry {
  final int outputNo;

  OutputHitTestEntry(this.outputNo, RenderBox target, Offset localPosition)
      : assert(outputNo > 0),
        super(target, localPosition);
}

class LogicGateBox extends RenderProxyBox {
  int _inputCount;

  int _outputCount;

  int _nodeSize;

  List<Rect> inputNodeLayout = [];

  List<Rect> outputNodeLayout = [];

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

  @override
  set child(RenderBox? newValue) {
    super.child = newValue;
    markNeedsLayout();
  }

  int get nodeSize => _nodeSize;

  set nodeSize(int value) {
    _nodeSize = value;
    markNeedsLayout();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position) &&
        (hitTestChildren(result, position: position) ||
            hitTestSelf(position))) {
      int? inputNodeNo = _hitTestForInputNodes(inputNodeLayout, position);
      if (inputNodeNo != null) {
        result.add(InputHitTestEntry(inputNodeNo, this, position));
        return true;
      }
      int? outputNodeNo = _hitTestForInputNodes(inputNodeLayout, position);
      if (outputNodeNo != null) {
        result.add(OutputHitTestEntry(outputNodeNo, this, position));
        return true;
      }
      result.add(BoxHitTestEntry(this, position));
    }
    return false;
  }

  int? _hitTestForInputNodes(List<Rect> nodeLayout, Offset localPosition) {
    int nodeNo = 0;
    for (Rect rect in inputNodeLayout) {
      if (rect.contains(localPosition)) {
        return nodeNo;
      }
      nodeNo++;
    }
    return null;
  }

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
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
    Paint inputPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    for (Rect inputRect in outputNodeLayout) {
      canvas.drawRect(inputRect, inputPaint);
    }
  }

  void _drawOutputNodes(Canvas canvas) {
    Paint outputPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    for (Rect outputRect in outputNodeLayout) {
      canvas.drawRect(outputRect, outputPaint);
    }
  }

  void _calculateLocalInputOutputOffset() {
    // calculating inputs offsets
    double inputGap =
        (size.height - (inputCount * nodeSize)) / (inputCount + 1);
    double currentStartPoint = 0;
    for (int i = 0; i < inputCount; i++) {
      currentStartPoint += inputGap;
      inputNodeLayout.add(Rect.fromLTWH(
          0, currentStartPoint, nodeSize.toDouble(), nodeSize.toDouble()));
      currentStartPoint += nodeSize;
    }

    // calculating output node offsets
    double outputGap =
        (size.height - (outputCount * nodeSize)) / (outputCount + 1);
    currentStartPoint = 0;
    for (int i = 0; i < outputCount; i++) {
      currentStartPoint += outputGap;
      outputNodeLayout.add(Rect.fromLTWH(size.width - nodeSize,
          currentStartPoint, nodeSize.toDouble(), nodeSize.toDouble()));
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
    _calculateLocalInputOutputOffset();
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
