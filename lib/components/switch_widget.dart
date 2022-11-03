import 'package:flutter/material.dart';


typedef SwitchToggle = void Function(bool);

class SwitchWidget extends StatefulWidget {
  final bool initialValue;

  final Color switchOnColor;

  final Color switchOffColor;

  final SwitchToggle? onSwitchToggle;

  const SwitchWidget(
      {this.switchOnColor = Colors.red,
      this.switchOffColor = Colors.black,
      Key? key,
      this.initialValue = false,
      this.onSwitchToggle})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool state = false;

  @override
  void initState() {
    super.initState();
    state = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SwitchWidget oldWidget) {
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
          widget.onSwitchToggle?.call(state);
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
