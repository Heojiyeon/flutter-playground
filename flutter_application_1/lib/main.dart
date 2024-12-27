import 'package:english_words/english_words.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  runApp(const MyApp());
}

// 전체 애플리케이션 관리
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// 상태 및 핸들러 함수 class
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  late String before;

  void getNext() {
    before = current.asString;
    current = WordPair.random();

    entireMessages.add(before);
    notifyListeners();
  }

  var favorites = <WordPair>[];
  var entireMessages = [];
  var favoriteMessages = [];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
      favoriteMessages.remove(current.asString);
    } else {
      favorites.add(current);
      favoriteMessages.add(current.asString);
    }

    notifyListeners();
  }
}
