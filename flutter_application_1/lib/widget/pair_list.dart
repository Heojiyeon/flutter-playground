import 'package:flutter/material.dart';

// 단어 리스트 컴포넌트 분리
class Pairlist extends StatefulWidget {
  const Pairlist({super.key, required this.listValue});
  final List<dynamic> listValue;

  @override
  State<StatefulWidget> createState() => _PairlistState();
}

class _PairlistState extends State<Pairlist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var message in widget.listValue) Text(message),
      ],
    );
  }
}
