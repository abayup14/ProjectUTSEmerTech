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
        _detik--; // kurangi waktu
        if (_detik <= 0) {
          if (_gambarSekarang < _gambarKuis.length - 1) {
            _gambarSekarang++; // pindah ke set berikutnya
            _detik = _waktuKuis; // reset waktu untuk set berikutnya
          } else {
            _timer.cancel(); // hentikan timer jika sudah melewati semua set
            // Logika akhir game atau fase kuis selesai
          }
        }
      });
    });
  }

  List<String> buatGambarUntukDiingat(int count) {
    Random random = Random();
    Set<int> randomGambarSets = {}; // menyimpan set unik
    List<String> listGambar = [];

    while (randomGambarSets.length < count) {
      int gambarKe = 1 + random.nextInt(20); // set acak 1-20
      int subgambarKe = 1 + random.nextInt(4); // gambar acak 1-4

      if (randomGambarSets.contains(gambarKe)) {
        continue; // jika set sudah ada, lanjutkan loop
      }

      String namaGambar = "c-$gambarKe-$subgambarKe"; // format nama gambar
      listGambar.add(namaGambar); // tambahkan gambar
      randomGambarSets.add(gambarKe); // tambahkan set unik
    }

    return listGambar; // kembalikan daftar gambar
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
              style: const TextStyle(fontSize: 20)), // teks akhir
          ElevatedButton(
            onPressed: ()  {
                showResult(context);
            },
            child: const Text("Kembali"),
          ),
        ],
      )));
    } else {
      List<String> currentChoices =
          _gambarKuis[_gambarSekarang]; // set kuis saat ini

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
                        ), // pilihan gambar
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
                        ), // pilihan gambar
                      ),
                      TextButton(
                        onPressed: () =>
                            cekJawaban(currentChoices[3]), // cek jawaban
                        child: Image.asset(
                          "assets/images/${currentChoices[3]}.png",
                          height: 200,
                          width: 200,
                        ), // pilihan gambar
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
      _score++; // tingkatkan skor jika jawaban benar
    }

    // Periksa apakah ini adalah set kuis terakhir
    if (_gambarSekarang >= _gambarKuis.length) {
      // Jika set terakhir, hentikan timer dan berikan logika akhir kuis
      _timer.cancel(); // hentikan timer untuk menghindari kebocoran memori
      setState(() {}); // perbarui UI
    } else {
      // Jika masih ada set kuis, lanjutkan ke set berikutnya
      _gambarSekarang++; // pindah ke set berikutnya
      _detik = _waktuKuis; // reset waktu untuk set kuis berikutnya
      _timer.cancel(); // pastikan timer dihentikan
      startQuiz(); // mulai ulang timer
    }
  }

  List<List<String>> generateQuizSets() {
    List<List<String>> quizSets = [];
    Random random = Random();

    for (var memorizedImage in _gambarDiingat) {
      List<String> quizOptions = [];
      int correctSet = int.parse(memorizedImage
          .split('-')[1]); // ekstrak nomor set dari gambar yang diingat

      // Tambahkan jawaban yang benar (gambar yang diingat)
      quizOptions.add(memorizedImage);

      // Tambahkan tiga gambar acak lainnya dari set yang sama
      while (quizOptions.length < 4) {
        int randomImageNumber =
            1 + random.nextInt(4); // acak angka 1-4 untuk gambar dalam set
        String randomImage = "c-$correctSet-$randomImageNumber";

        if (!quizOptions.contains(randomImage)) {
          // pastikan tidak ada duplikasi
          quizOptions.add(randomImage);
        }
      }

      quizOptions.shuffle(); // acak urutan pilihan dalam set
      quizSets.add(quizOptions); // tambahkan set kuis ke daftar
    }

    return quizSets; // kembalikan daftar set kuis
  }

  String formatTime(int detik) {
    var minutes = ((detik % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (detik % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds"; // format waktu
  }

  @override
  void dispose() {
    _timer.cancel(); // hentikan timer untuk menghindari kebocoran memori
    super.dispose();
  }
}
