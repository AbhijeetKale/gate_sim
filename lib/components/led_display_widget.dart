import 'package:flutter/material.dart';

class LedDisplayWidget extends StatefulWidget {
  final bool initialValue;

  final Color switchOnColor;

  final Color switchOffColor;

  const LedDisplayWidget(
      {this.switchOnColor = Colors.red,
      this.switchOffColor = Colors.black,
      Key? key,
      this.initialValue = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LedDisplayWidgetState();
}

class _LedDisplayWidgetState extends State<LedDisplayWidget> {
  bool state = false;

  @override
  void initState() {
    super.initState();
    state = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant LedDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    state = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: GestureDetector(
        onTap: () {
          setState(() {
            state = !state;
          });
        },
        child: Container(
          height: 20,
          width: 20,
          color: state ? widget.switchOnColor : widget.switchOffColor,
        ),
      ),
    );
  }
}
