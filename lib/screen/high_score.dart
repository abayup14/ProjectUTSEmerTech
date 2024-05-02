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
        body: Center(
          child: Column(
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
        ));
  }
}


