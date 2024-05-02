import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  late Timer _timer;
  int _waktuIngat = 3;
  int _waktuKuis = 30;
  int _detik = 0;

  bool _quizStarted = false; // apakah kuis sudah dimulai
  bool _memorizationPhase = true; // apakah fase mengingat masih berlangsung

  int _memorizationIndex = 0; // indeks gambar di fase mengingat
  List<String> _gambarDiingat = []; // gambar-gambar yang diingat
  List<List<String>> _gambarKuis = []; // set kuis dengan 4 pilihan
  int _currentSet = 0; // set kuis saat ini
  int _score = 0; // skor pemain

  @override
  void initState() {
    super.initState();
    _gambarDiingat =
        buatGambarUntukDiingat(5); // menghasilkan 5 gambar untuk fase mengingat
    _detik = _waktuIngat; // waktu awal untuk fase mengingat
    mulaiMengingat(); // mulai fase mengingat
  }

  void mulaiMengingat() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _detik--; // kurangi waktu
        if (_detik <= 0) {
          if (_memorizationIndex < _gambarDiingat.length - 1) {
            _memorizationIndex++; // pindah ke gambar berikutnya
            _detik = _waktuIngat; // reset waktu untuk gambar berikutnya
          } else {
            _memorizationPhase = false; // fase mengingat selesai
            _quizStarted = true; // fase kuis dimulai
            _gambarKuis = generateQuizSets(); // buat set kuis
            _currentSet = 0; // set kuis pertama
            _detik = _waktuKuis; // reset waktu untuk kuis
            _timer.cancel(); // hentikan timer fase mengingat
            startQuiz(); // mulai fase kuis
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
          if (_currentSet < _gambarKuis.length - 1) {
            _currentSet++; // pindah ke set berikutnya
            _detik = _waktuKuis; // reset waktu untuk set kuis berikutnya
          } else {
            _timer.cancel(); // hentikan timer
            // Logika akhir game atau fase kuis selesai
          }
        }
      });
    });
  }

  List<String> buatGambarUntukDiingat(int count) {
    Random random = Random();
    Set<int> uniqueSets = {}; // menyimpan set unik
    List<String> images = [];

    while (uniqueSets.length < count) {
      int setNumber = 1 + random.nextInt(20); // set acak 1-20
      int imageNumber = 1 + random.nextInt(4); // gambar acak 1-4

      if (uniqueSets.contains(setNumber)) {
        continue; // jika set sudah ada, lanjutkan loop
      }

      String imageName = "c-$setNumber-$imageNumber"; // format nama gambar
      images.add(imageName); // tambahkan gambar
      uniqueSets.add(setNumber); // tambahkan set unik
    }

    return images; // kembalikan daftar gambar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemorImage"),
      ),
      body: Center(
        child: _memorizationPhase
            ? memorizationUI() // UI untuk fase mengingat
            : quizUI(), // UI untuk fase kuis
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
              style: TextStyle(fontSize: 16),
            ),
            width: MediaQuery.of(context).size.width,
            lineHeight: 20.0,
            percent: (_detik / _waktuIngat),
            backgroundColor: Colors.grey,
            progressColor: Colors.red,
          ),
          // teks judul
          if (_memorizationIndex < _gambarDiingat.length)
            Image.asset(
                "assets/images/${_gambarDiingat[_memorizationIndex]}.png"), // gambar fase mengingat // waktu tersisa
        ],
      ),
    ));
  }

  Widget quizUI() {
    if (_currentSet >= _gambarKuis.length) {
      return Center(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Text("Game selesai! Skor Anda: $_score",
              style: const TextStyle(fontSize: 20)), // teks akhir
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context), // kembali ke layar sebelumnya
            child: const Text("Kembali"),
          ),
        ],
      )));
    }

    List<String> currentChoices = _gambarKuis[_currentSet]; // set kuis saat ini

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Pilih gambar yang benar",
                style: TextStyle(fontSize: 20)), // teks judul fase kuis
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
                    OutlinedButton(
                      onPressed: () =>
                          cekJawaban(currentChoices[0]), // cek jawaban
                      child: Image.asset(
                          "assets/images/${currentChoices[0]}.png"), // pilihan gambar
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          cekJawaban(currentChoices[1]), // cek jawaban
                      child: Image.asset(
                          "assets/images/${currentChoices[1]}.png"), // pilihan gambar
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          cekJawaban(currentChoices[2]), // cek jawaban
                      child: Image.asset(
                          "assets/images/${currentChoices[2]}.png"), // pilihan gambar
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          cekJawaban(currentChoices[3]), // cek jawaban
                      child: Image.asset(
                          "assets/images/${currentChoices[3]}.png"), // pilihan gambar
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

  void cekJawaban(String selectedOption) {
    // Jawaban yang benar adalah gambar yang sesuai dengan set saat ini
    String correctAnswer = _gambarDiingat[_currentSet];

    // Jika jawaban yang dipilih adalah jawaban yang benar, tingkatkan skor
    if (selectedOption == correctAnswer) {
      _score++; // tambah skor jika jawaban benar
    }

    // Setelah memeriksa jawaban, pindah ke set kuis berikutnya
    if (_currentSet < _gambarKuis.length - 1) {
      _currentSet++; // pindah ke set berikutnya
      _detik = _waktuKuis; // reset waktu untuk set kuis berikutnya
    } else {
      _timer.cancel(); // hentikan timer
      // Logika untuk akhir kuis (misalnya, menampilkan hasil akhir)
    }

    setState(() {}); // perbarui UI
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
