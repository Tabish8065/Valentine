import 'package:flutter/material.dart';

class NotePaper extends StatelessWidget {
  final String? content;
  const NotePaper({this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Text(
        content ?? 'My dearest Zainab,\n\nYou make every day special.\n\nLove,',
        style: const TextStyle(fontSize: 16, height: 1.6, fontFamily: 'Handwritten', fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );
  }
}
