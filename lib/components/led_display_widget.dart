import 'package:flutter/material.dart';

class LedDisplayWidget extends StatelessWidget {
  final Color color;

  const LedDisplayWidget({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 20,
        width: 20,
        color: color,
      ),
    );
  }
}
