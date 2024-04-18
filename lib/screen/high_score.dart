
import 'package:project_uts_emertech/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HighScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("High Score"),
      ),
      body: Center(child: Column(
        children: <Widget>[
            const Text(
              'High Score:',
            ),
            Text(
              "1st : " + top_users[0] + " -> " + top_scores[0].toString(),
            ),
            Text(
              "2nd : " + top_users[1] + " -> " + top_scores[1].toString(),
            ),
            Text(
              "3rd : " + top_users[2] + " -> " + top_scores[2].toString(),
            ),
            ],
      ),
      )
    );
  }
}
Future<List> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user1 = prefs.getString("top_user1") ?? '';
  String user2 = prefs.getString("top_user2") ?? '';
  String user3 = prefs.getString("top_user3") ?? '';
  List users =[user1,user2,user3];
  return users;
}
Future<List> getScore() async {
  final prefs = await SharedPreferences.getInstance();
  int score1 = prefs.getInt("top_score1") ?? 0;
  int score2 = prefs.getInt("top_score2") ?? 0;
  int score3 = prefs.getInt("top_score3") ?? 0;
  List scores = [score1,score2,score3];
  return scores;
}