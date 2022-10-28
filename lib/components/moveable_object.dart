import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MoveAbleObjectWidget extends SingleChildRenderObjectWidget {
  const MoveAbleObjectWidget({this.height, this.width, Widget? child, Key? key})
      : super(key: key, child: child);

  final double? height;

  final double? width;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      MoveAbleObject(height, width);

  @override
  void updateRenderObject(
      BuildContext context, covariant MoveAbleObject renderObject) {
    renderObject
      ..height = height
      ..width = width;
  }
}

class MoveAbleObject extends RenderProxyBox {
  double? _height;
  double? _width;

  MoveAbleObject(this._height, this._width, [RenderBox? child]) : super(child);

  double? get height => _height;

  set height(double? h) {
    _height = h;
    markNeedsLayout();
  }

  double? get width => _width;

  set width(double? w) {
    _width = w;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.save();
    Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;
    canvas.translate(offset.dx, offset.dy);
    canvas.drawRect(Offset.zero & size, paint);
    canvas.restore();
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    Size? childSize = child?.getDryLayout(constraints);
    Size size = Size(
        width ?? childSize?.width ?? 0.0, height ?? childSize?.height ?? 0.0);
    return constraints.constrain(size);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return 200.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return 100.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return 200.0;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return 100.0;
  }
}
