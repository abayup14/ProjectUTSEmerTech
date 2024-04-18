import 'package:project_uts_emertech/main.dart';
import 'package:project_uts_emertech/screen/high_score.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int score;
  Result(this.score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: Center(child: Column(
        children: <Widget>[
            const Text(
              'Your Score:',
            ),
            Text(
              this.score.toString(),
            ),
            ],
      ),
      )
    );
  }

  void setScore(int number) async {
  //later, we use web service here to check the user id and password
  final prefs = await SharedPreferences.getInstance();
  if (number==0) {
    prefs.setInt("top_score2", top_scores[0]);
    prefs.setString("top_user2", top_users[0]);
    prefs.setInt("top_score3", top_scores[1]);
    prefs.setString("top_user3", top_users[1]);
    prefs.setInt("top_score1", score );
    prefs.setString("top_user1", user_login);
    main();
  } else if (number==1) {
    prefs.setInt("top_score3", top_scores[1]);
    prefs.setString("top_user3", top_users[1]);
    prefs.setInt("top_score2", score );
    prefs.setString("top_user2", user_login);
  } else {
    prefs.setInt("top_score3", score );
    prefs.setString("top_user3", user_login);
  }
  prefs.setInt("top_score"+number.toString(), score );
  prefs.setString("top_user"+number.toString(), user_login);
  main();
  }
  
  void checkHighscore(){
    getScore().then((List scores){
      top_scores=scores;
    });
    getScore().then((List users){
      top_users=users;
    });
    for ( int i =0  ; i<3  ; i++ ){
        if (top_scores[i]<=score) {
          setScore(i);
        }
      }
  }
  
}
