import 'dart:async';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  late Timer _timer;
  int _waktuIngat = 3;
  int _waktuJawab = 30;
  int _detik = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemorImage"),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _detik = _waktuIngat;
    startTimer();
  }

  String formatTime(int detik) {
    var hours = (detik ~/ 3600).toString().padLeft(2, "0");
    var minutes = ((detik % 3600) ~/ 60).toString().padLeft(2, "0");
    var seconds = (detik % 60).toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _detik--;
      });
    });
  }
}
