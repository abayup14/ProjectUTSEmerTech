import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  bool _quizStarted = false;

  int _picture_no = 0; // untuk saat sesi mengingat
  String _picture_img = "";
  List<int> _picture = generateRandomPicture(1, 20);
  List<int> _answer = generateRandomAnswer(1, 4);
  List<int> _list_pict = [1, 2, 3, 4];
  int _quiz_image_index = 0; // Track the specific picture for the quiz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemorImage"),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: gameplay(),
        )),
      ),
    );
  }

  List<Widget> gameplay() {
    if (!_quizStarted) {
      // Displaying the sequence of images to memorize
      if (_picture_no < 5) {
        return [
          Text(
            formatTime(_detik),
            style: const TextStyle(fontSize: 20),
          ),
          const Text("Memorize this"),
          Image.asset("assets/images/$_picture_img.png"),
        ];
      }
    }

    if (_showQuest && _quizStarted) {
      int quiz_image = _picture[_quiz_image_index];
      return [
        const Text("What is the same picture from the previous sequence?"),
        Text(
          formatTime(_detik),
          style: const TextStyle(fontSize: 20),
        ),
        Row(
          children: [
            Image.asset("assets/images/c-$quiz_image-${_list_pict[0]}.png"),
            Image.asset("assets/images/c-$quiz_image-${_list_pict[1]}.png"),
          ],
        ),
        Row(
          children: [
            Image.asset("assets/images/c-$quiz_image-${_list_pict[2]}.png"),
            Image.asset("assets/images/c-$quiz_image-${_list_pict[3]}.png"),
          ],
        )
      ];
    }

    return [];
  }

  void startIngat() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _detik--;
        if (_detik == 0) {
          _picture_no++;
          if (_picture_no < 5) {
            _picture_img = "c-${_picture[_picture_no]}-${_answer[_picture_no]}";
            _detik = _waktuIngat;
          } else {
            _quizStarted = true;
            _showQuest = true;
            _detik = _waktuJawab;
            _quiz_image_index = Random().nextInt(5);
            _timer.cancel();
            startQuiz();
          }
        }
      });
    });
  }

  void startQuiz() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _detik--;
        if (_detik == 0) {
          _timer.cancel(); // Stop the quiz timer once the time is up
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _detik = _waktuIngat; // Set initial memorization time
    _picture_img = "c-${_picture[0]}-${_answer[0]}";
    startIngat(); // Start the memorization phase
  }

  String formatTime(int detik) {
    var hours = (detik ~/ 3600).toString().padLeft(2, "0");
    var minutes = ((detik % 3600) ~/ 60).toString().padLeft(2, "0");
    var seconds = (detik % 60).toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel(); // Ensure timer is canceled to prevent memory leaks
    super.dispose();
  }
}
