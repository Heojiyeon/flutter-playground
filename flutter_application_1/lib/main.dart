import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/pairList.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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

// 페이지 레이아웃
// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = LikePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            // 가로 영역 분할
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// home 화면
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var entireMessages = appState.entireMessages;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // for (var message in entireMessages) Text(message),
          Pairlist(listValue: entireMessages),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 좋아요 화면
class LikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favoriteMessages = appState.favoriteMessages;

    var messageSize = appState.favoriteMessages.length;

    IconData icon = Icons.favorite;

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        Text('You have $messageSize favorite message :',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        for (var message in favoriteMessages)
          ListTile(
            leading: Icon(
              icon,
              color: Colors.red,
            ),
            title: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          )
      ],
    ));
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    final secondStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pair.first,
              style: style,
              semanticsLabel: "${pair.first}",
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              pair.second,
              style: secondStyle,
              semanticsLabel: "${pair.second}",
            ),
          ],
        ),
      ),
    );
  }
}
