import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

generateRandomPicture(int min, int max) {
  Random ran = Random();
  Set<int> numPict = Set();

  while (numPict.length < 5) {
    int angka = min + ran.nextInt(max - min + 1);
    numPict.add(angka);
  }
  return numPict.toList();
}

generateRandomAnswer(int min, int max) {
  Random ran = Random();
  List<int> numAns = List.empty(growable: true);

  while (numAns.length < 5) {
    int angka = min + ran.nextInt(max - min + 1);
    numAns.add(angka);
  }
  return numAns;
}

class _GameState extends State<Game> {
  late Timer _timer;
  int _waktuIngat = 3;
  int _waktuJawab = 30;
  int _detik = 0;

  int _picture_no = 0;
  String _picture_img = "";
  List<int> _picture = generateRandomPicture(1, 20);
  List<int> _answer = generateRandomAnswer(1, 4);
  List<int> _list_num = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemorImage"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              formatTime(_detik),
              style: const TextStyle(fontSize: 20),
            ),
            Text("Memorize this"),
            Image.asset("assets/images/${_picture_img}.png")
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _detik = _waktuIngat;
    startTimer();
    print(_picture.toString());
    print(_answer.toString());
    _picture_img = "c-${_picture[0]}-${_answer[0]}";
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
        if (_detik == 0) {
          _picture_no++;
          _detik = _waktuIngat;
          _picture_img = "c-${_picture[_picture_no]}-${_answer[_picture_no]}";
          if (_picture_no > _picture.length - 1) {
            _picture_no = 0;
          }
        }
      });
    });
  }
}
