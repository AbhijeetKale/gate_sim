import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gate_sim/components/line_object.dart';
import 'package:gate_sim/components/drawing_board.dart';
import 'package:gate_sim/components/moveable_object.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  double width = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            width = Random().nextInt(200).toDouble();
          });
        },
        child: const Icon(Icons.place),
      ),
      body: DrawingBoard(
        lines: [Line([Offset.zero, Offset(10.0, 30.0)])],
      ),
    );
  }
}
