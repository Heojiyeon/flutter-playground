// 좋아요 화면
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

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
