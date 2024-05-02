import 'package:project_uts_emertech/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// int score = 0;

// void resultMain() {
//   gameScore().then((int res) {
//        score = res;
//     });
//   runApp(Result())
// }

// Future<int> gameScore() async {
//     final prefs = await SharedPreferences.getInstance();
//     int score = prefs.getInt("game_score") ?? 0;
//     print(score);
//     return score;
//   }

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  
  @override
  void initState() {
    
    print(game_score);
    super.initState();

    checkHighscore();
  }

  List<String> titles = [
    "Sfortunato Indovinatore",
    "Neofita dell'Indovinello",
    "Principiante dell'Indovinello",
    "Abile Indovinatore",
    "Esperto dell'Indovinello",
    "Maestro dell'Indovinello"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Result"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Your Score:',
              ),
              Text(
                game_score.toString() + "/5",
              ),
              Text(
                "Your Title : " + this.titles[game_score],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "game");
                  },
                  child: Text("Play Again")),
              ElevatedButton(
                  onPressed: () {
                    getScore().then((List res) {
                      top_scores = res;
                      print(top_scores);
                    });
                    getUser().then((List result) {
                      top_users = result;
                      print(top_users);
                    });
                    Navigator.popAndPushNamed(context, "high_score");
                  },
                  child: Text("Highscores")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "OK");
                  },
                  child: Text("Main Menu"))
            ],
          ),
        ));
  }

  void setScores(int number) async {
    //later, we use web service here to check the user id and password
    final prefs = await SharedPreferences.getInstance();
    if (number == 0) {
      prefs.setInt("top_score2", top_scores[0]);
      prefs.setString("top_user2", top_users[0].toString());
      prefs.setInt("top_score3", top_scores[1]);
      prefs.setString("top_user3", top_users[1].toString());
      prefs.setInt("top_score1", game_score);
      prefs.setString("top_user1", user_login);
      main();
    } else if (number == 1) {
      prefs.setInt("top_score3", top_scores[1]);
      prefs.setString("top_user3", top_users[1].toString());
      prefs.setInt("top_score2", game_score);
      prefs.setString("top_user2", user_login);
    } else {
      prefs.setInt("top_score3", game_score);
      prefs.setString("top_user3", user_login);
    }
    // prefs.setInt("top_score" + number.toString(), game_score);
    // prefs.setString("top_user" + number.toString(), user_login);
    main();
  }

  void checkHighscore() {
    getScore().then((List scores) {
      print(scores);
      top_scores = scores;
    });
    getUser().then((List users) {
      top_users = users;
    });
    if (top_scores.length == 0) {
      top_scores = [
        0,
        0,
        0,
      ];
      top_users = ["", "", ""];
    }
    for (int i = 0; i < 3; i++) {
      if (top_scores[i] <= game_score) {
        setScores(i);
        break;
      }
    }
  }

  // Future<int> getGameScore() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int score = prefs.getInt("game_score") ?? 0;
  //   return score;
  // }
}
