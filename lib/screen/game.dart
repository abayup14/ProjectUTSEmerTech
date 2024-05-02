import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  late Timer _timer;
  int _memorizationDuration = 3; // 3 detik per gambar di fase mengingat
  int _quizDuration = 30; // 30 detik per set kuis
  int _remainingTime = 0; // waktu tersisa

  bool _quizStarted = false; // apakah kuis sudah dimulai
  bool _memorizationPhase = true; // apakah fase mengingat masih berlangsung

  int _memorizationIndex = 0; // indeks gambar di fase mengingat
  List<String> _memorizedImages = []; // gambar-gambar yang diingat
  List<List<String>> _quizSets = []; // set kuis dengan 4 pilihan
  int _currentSet = 0; // set kuis saat ini
  int _score = 0; // skor pemain

  @override
  void initState() {
    super.initState();
    _memorizedImages = generateMemorizationImages(
        5); // menghasilkan 5 gambar untuk fase mengingat
    _remainingTime = _memorizationDuration; // waktu awal untuk fase mengingat
    startMemorization(); // mulai fase mengingat
  }

  void startMemorization() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--; // kurangi waktu
        if (_remainingTime <= 0) {
          if (_memorizationIndex < _memorizedImages.length - 1) {
            _memorizationIndex++; // pindah ke gambar berikutnya
            _remainingTime =
                _memorizationDuration; // reset waktu untuk gambar berikutnya
          } else {
            _memorizationPhase = false; // fase mengingat selesai
            _quizStarted = true; // fase kuis dimulai
            _quizSets = generateQuizSets(); // buat set kuis
            _currentSet = 0; // set kuis pertama
            _remainingTime = _quizDuration; // reset waktu untuk kuis
            _timer.cancel(); // hentikan timer fase mengingat
            startQuiz(); // mulai fase kuis
          }
        }
      });
    });
  }

  void startQuiz() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--; // kurangi waktu
        if (_remainingTime <= 0) {
          if (_currentSet < _quizSets.length - 1) {
            _currentSet++; // pindah ke set berikutnya
            _remainingTime =
                _quizDuration; // reset waktu untuk set kuis berikutnya
          } else {
            _timer.cancel(); // hentikan timer
            // Logika akhir game atau fase kuis selesai
          }
        }
      });
    });
  }

  List<String> generateMemorizationImages(int count) {
    Random random = Random();
    Set<String> images = Set();

    while (images.length < count) {
      int setNumber = 1 + random.nextInt(20); // set acak 1-20
      int imageNumber = 1 + random.nextInt(4); // gambar dalam set 1-4
      String imageName = "c-$setNumber-$imageNumber"; // format gambar
      images.add(imageName);
    }

    return images.toList(); // kembalikan daftar gambar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MemorImage"),
      ),
      body: Center(
        child: _memorizationPhase
            ? memorizationUI() // UI untuk fase mengingat
            : quizUI(), // UI untuk fase kuis
      ),
    );
  }

  Widget memorizationUI() {
    return Column(
      children: [
        Text("Ingat gambar-gambar ini",
            style: TextStyle(fontSize: 20)), // teks judul
        if (_memorizationIndex < _memorizedImages.length)
          Image.asset(
              "assets/images/${_memorizedImages[_memorizationIndex]}.png"), // gambar fase mengingat
        Text("Waktu tersisa: ${formatTime(_remainingTime)}",
            style: TextStyle(fontSize: 20)), // waktu tersisa
      ],
    );
  }

  Widget quizUI() {
    if (_currentSet >= _quizSets.length) {
      return Column(
        children: [
          Text("Game selesai! Skor Anda: $_score",
              style: TextStyle(fontSize: 20)), // teks akhir
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context), // kembali ke layar sebelumnya
            child: Text("Kembali"),
          ),
        ],
      );
    }

    List<String> currentChoices = _quizSets[_currentSet]; // set kuis saat ini

    return Column(
      children: [
        Text("Pilih gambar yang benar",
            style: TextStyle(fontSize: 20)), // teks judul fase kuis
        Text("Waktu tersisa: ${formatTime(_remainingTime)}",
            style: TextStyle(fontSize: 20)), // teks waktu tersisa
        Row(
          children: [
            for (int i = 0; i < 4; i++) // 4 pilihan gambar
              ElevatedButton(
                onPressed: () => checkAnswer(currentChoices[i]), // cek jawaban
                child: Image.asset(
                    "assets/images/${currentChoices[i]}.png"), // pilihan gambar
              ),
          ],
        ),
        Text("Skor: $_score", style: TextStyle(fontSize: 20)), // teks skor
      ],
    );
  }

  void checkAnswer(String selectedOption) {
    // Jawaban yang benar adalah gambar yang sesuai dengan set saat ini
    String correctAnswer = _memorizedImages[_currentSet];

    // Jika jawaban yang dipilih adalah jawaban yang benar, tingkatkan skor
    if (selectedOption == correctAnswer) {
      _score++; // tambah skor jika jawaban benar
    }

    // Setelah memeriksa jawaban, pindah ke set kuis berikutnya
    if (_currentSet < _quizSets.length - 1) {
      _currentSet++; // pindah ke set berikutnya
      _remainingTime = _quizDuration; // reset waktu untuk set kuis berikutnya
    } else {
      _timer.cancel(); // hentikan timer
      // Logika untuk akhir kuis (misalnya, menampilkan hasil akhir)
    }

    setState(() {}); // perbarui UI
  }

  List<List<String>> generateQuizSets() {
    List<List<String>> quizSets = [];
    Random random = Random();

    for (var memorizedImage in _memorizedImages) {
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
