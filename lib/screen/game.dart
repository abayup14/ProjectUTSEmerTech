import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_uts_emertech/main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setScore(int score) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt("game_score", score);
}

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  late Timer _timer;
  final int _waktuIngat = 3;
  final int _waktuKuis = 30;
  int _detik = 0;
  bool animated = false;

  bool _isKuisDimulai = false;
  bool _FaseMengingat = true;

  int _gambarIngatKe = 0;
  List<String> _gambarDiingat = [];
  List<List<String>> _gambarKuis = [];
  int _gambarSekarang = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _gambarDiingat = buatGambarUntukDiingat(5);
    _detik = _waktuIngat;
    mulaiMengingat();
  }

  void mulaiMengingat() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _detik--;
        if (_detik <= 0) {
          if (_gambarIngatKe < _gambarDiingat.length - 1) {
            animated = !animated;
            _gambarIngatKe++;
            _detik = _waktuIngat;
          } else {
            _FaseMengingat = false;
            _isKuisDimulai = true;
            _gambarKuis = generateQuizSets();
            _gambarSekarang = 0;
            _detik = _waktuKuis;
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
        if (_detik <= 0) {
          if (_gambarSekarang < _gambarKuis.length - 1) {
            _gambarSekarang++;
            _detik = _waktuKuis;
          } else {
            _timer.cancel();
          }
        }
      });
    });
  }

  List<String> buatGambarUntukDiingat(int count) {
    Random random = Random();
    Set<int> randomGambarSets = {};
    List<String> listGambar = [];

    while (randomGambarSets.length < count) {
      int gambarKe = 1 + random.nextInt(20);
      int subgambarKe = 1 + random.nextInt(4);

      if (randomGambarSets.contains(gambarKe)) {
        continue;
      }

      String namaGambar = "c-$gambarKe-$subgambarKe";
      listGambar.add(namaGambar);
      randomGambarSets.add(gambarKe);
    }

    return listGambar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemorImage"),
      ),
      body: Center(
        child: _FaseMengingat ? memorizationUI() : quizUI(),
      ),
    );
  }

  Widget memorizationUI() {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const Text("Ingat gambar-gambar ini", style: TextStyle(fontSize: 20)),
          LinearPercentIndicator(
            center: Text(
              formatTime(_detik),
              style: const TextStyle(fontSize: 16),
            ),
            width: MediaQuery.of(context).size.width,
            lineHeight: 20.0,
            percent: (_detik / _waktuIngat),
            backgroundColor: Colors.red,
            progressColor: Colors.green,
          ),
          if (_gambarIngatKe < _gambarDiingat.length)
            AnimatedAlign(
              alignment: animated ? Alignment.topRight : Alignment.bottomLeft,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Image.asset(
                  "assets/images/${_gambarDiingat[_gambarIngatKe]}.png"),
            )
        ],
      ),
    ));
  }

  Widget quizUI() {
    if (_gambarSekarang >= _gambarKuis.length) {
      setScore(_score);
      return Center(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Text("Game selesai! Skor Anda: $_score",
              style: const TextStyle(fontSize: 20)),
          ElevatedButton(
            onPressed: () {
              showResult(context);
            },
            child: const Text("Kembali"),
          ),
        ],
      )));
    } else {
      List<String> currentChoices = _gambarKuis[_gambarSekarang];
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Pilih gambar yang benar",
                  style: TextStyle(fontSize: 20)),
              CircularPercentIndicator(
                radius: 90.0,
                lineWidth: 20.0,
                percent: 1 - (_detik / _waktuKuis),
                center: Text(formatTime(_detik)),
                progressColor: Colors.red,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => cekJawaban(currentChoices[0]),
                        child: Image.asset(
                          "assets/images/${currentChoices[0]}.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            cekJawaban(currentChoices[1]), // cek jawaban
                        child: Image.asset(
                          "assets/images/${currentChoices[1]}.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () =>
                            cekJawaban(currentChoices[2]), // cek jawaban
                        child: Image.asset(
                          "assets/images/${currentChoices[2]}.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            cekJawaban(currentChoices[3]), // cek jawaban
                        child: Image.asset(
                          "assets/images/${currentChoices[3]}.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  void cekJawaban(String selectedOption) {
    String correctAnswer = _gambarDiingat[_gambarSekarang];

    if (selectedOption == correctAnswer) {
      _score++;
    }

    if (_gambarSekarang >= _gambarKuis.length) {
      _timer.cancel();
      setState(() {});
    } else {
      _gambarSekarang++;
      _detik = _waktuKuis;
      _timer.cancel();
      startQuiz();
    }
  }

  List<List<String>> generateQuizSets() {
    List<List<String>> quizSets = [];
    Random random = Random();

    for (var memorizedImage in _gambarDiingat) {
      List<String> quizOptions = [];
      int correctSet = int.parse(memorizedImage.split('-')[1]);

      quizOptions.add(memorizedImage);

      while (quizOptions.length < 4) {
        int randomImageNumber = 1 + random.nextInt(4);
        String randomImage = "c-$correctSet-$randomImageNumber";

        if (!quizOptions.contains(randomImage)) {
          quizOptions.add(randomImage);
        }
      }

      quizOptions.shuffle();
      quizSets.add(quizOptions);
    }

    return quizSets;
  }

  String formatTime(int detik) {
    var minutes = ((detik % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (detik % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
