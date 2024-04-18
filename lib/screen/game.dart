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

  bool _showQuest = false;

  int _picture_no = 0;
  String _picture_img = "";
  List<int> _picture = generateRandomPicture(1, 20);
  List<int> _answer = generateRandomAnswer(1, 4);
  List<int> _list_pict = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemorImage"),
      ),
      body: Center(
        child: Column(children: gameplay()),
      ),
    );
  }

  List<Widget> gameplay() {
    if (_picture_no > -1 && _picture_no < 5) {
      return [
        Text(
          formatTime(_detik),
          style: const TextStyle(fontSize: 20),
        ),
        const Text("Memorize this"),
        Image.asset("assets/images/$_picture_img.png")
      ];
    } else if (!_showQuest) {
      _showQuest = true;
      Random ran = Random();
      int _get_pict = _picture[ran.nextInt(_picture.length)];
      return [
        Text("What is the same picture from previous?"),
        Text(
          formatTime(_detik),
          style: const TextStyle(fontSize: 20),
        ),
        Image.asset("assets/images/c-${_get_pict}-${_list_pict[0]}.png"),
        Image.asset("assets/images/c-${_get_pict}-${_list_pict[1]}.png"),
        Image.asset("assets/images/c-${_get_pict}-${_list_pict[2]}.png"),
        Image.asset("assets/images/c-${_get_pict}-${_list_pict[3]}.png"),
      ];
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _detik = _waktuIngat;
    startTimer();
    _picture_img = "c-${_picture[0]}-${_answer[0]}";
  }

  String formatTime(int detik) {
    var hours = (detik ~/ 3600).toString().padLeft(2, "0");
    var minutes = ((detik % 3600) ~/ 60).toString().padLeft(2, "0");
    var seconds = (detik % 60).toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }

  startIngat() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _detik--;
        if (_detik == 0) {
          _picture_no++;
          _picture_img = "c-${_picture[_picture_no]}-${_answer[_picture_no]}";
          if (_picture_no > 5) {
            _timer.cancel();
            _detik = 0;
            _detik = _waktuJawab;
          }
          _detik = _waktuIngat;
        }
      });
    });
  }

  startTimer() {
    startIngat();
  }

  startQuiz() {}

  @override
  void dispose() {
    super.dispose();
  }
}
