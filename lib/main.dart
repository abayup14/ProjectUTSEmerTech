import 'package:flutter/material.dart';
import 'package:project_uts_emertech/screen/game.dart';
import 'package:project_uts_emertech/screen/high_score.dart';
import 'package:project_uts_emertech/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String user_login = "";

Future<String> cekUserLogin() async {
  final prefs = await SharedPreferences.getInstance();
  String user_login = prefs.getString("username") ?? "";
  return user_login;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  cekUserLogin().then((String res) {
    if (res == "") {
      runApp(MyLogin());
    } else {
      user_login = res;
      runApp(const MyApp());
    }
  });
}

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("user_id");
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemorImage',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MemorImage'),
      routes: {
        "high_score": (context) => HighScore(),
        "game": (context) => Game(),
      },
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Selamat datang $user_login"),
          const Text(
              'Cara Bermain:',
            ),
            const Text(
              '- Quiz ini akan memberikan anda 5 gambar untuk diingat',
            ),
            const Text(
              '- Anda diberikan waktu 3 untuk mengingat setiap gambar',
            ),
            const Text(
              '- Setelah itu anda akan diberikan pilihan 4 gambar',
            ),
            const Text(
              '- Anda perlu memilih salah satu gambar sesuai dengan yang anda ingat',
            ),
            const Text(
              '- Akan diberikan waktu 30 detik untuk memilih tiap gambar',
            ),
            TextButton(
              child: Text("PLAY"),
              onPressed: () {
                Navigator.popAndPushNamed(context, "game");
            },
        ),
          ],
        ),
      ),
      drawer:
          funDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Drawer funDrawer() {
    return Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome $user_login"),
              accountEmail: Text("$user_login@email.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
            ),
            ListTile(
              title: const Text("High Score"),
              leading: const Icon(Icons.games),
              onTap: () {
                Navigator.popAndPushNamed(context, "high_score");
              },
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                doLogout();
              },
            )
          ],
        ));
  }
}
