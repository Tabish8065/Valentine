import 'package:flutter/material.dart';
import '../../widgets/animated_envelope.dart';
import '../../widgets/day_icon.dart';
import '../../widgets/note_paper.dart';
import '../../widgets/falling_hearts.dart';

class DayPage extends StatefulWidget {
  final int day;
  final IconData? icon;
  final Color? color;
  final String? noteContent;

  const DayPage({
    super.key,
    required this.day,
    this.icon,
    this.color,
    this.noteContent,
  });

  String get title {
    switch (day) {
      case 7:
        return 'Rose Day';
      case 8:
        return 'Propose Day';
      case 9:
        return 'Chocolate Day';
      case 10:
        return 'Teddy Day';
      case 11:
        return 'Promise Day';
      case 12:
        return 'Hug Day';
      case 13:
        return 'Kiss Day';
      default:
        return 'Day';
    }
  }

  IconData get defaultIcon {
    switch (day) {
      case 7:
        return Icons.local_florist;
      case 8:
        return Icons.favorite_border;
      case 9:
        return Icons.cake;
      case 10:
        return Icons.toys;
      case 11:
        return Icons.handshake;
      case 12:
        return Icons.hail;
      case 13:
        return Icons.favorite;
      default:
        return Icons.heart_broken;
    }
  }

  Color get defaultColor {
    switch (day) {
      case 7:
        return Colors.red;
      case 8:
        return Colors.pink;
      case 9:
        return Colors.brown;
      case 10:
        return Colors.purple;
      case 11:
        return Colors.pinkAccent;
      case 12:
        return Colors.orange;
      case 13:
        return Colors.redAccent;
      default:
        return Colors.pink;
    }
  }

  String get defaultNote {
    switch (day) {
      case 7:
        return 'A rose for the beauty of your love.\n💐';
      case 8:
        return 'I want to spend my forever with you.\n💍';
      case 9:
        return 'Sweet as chocolate, that\'s you.\n🍫';
      case 10:
        return 'Hug this bear like I hug you.\n🧸';
      case 11:
        return 'I promise to love you always.\n🤝';
      case 12:
        return 'My favorite place is your arms.\n🤗';
      case 13:
        return 'Every kiss with you is magical.\n😘';
      default:
        return 'I love you.\n💕';
    }
  }

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  bool _noteVisible = false;

  void _openEnvelope() {
    setState(() {
      _noteVisible = true;
    });
  }

  void _reset() {
    setState(() {
      _noteVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.icon ?? widget.defaultIcon;
    final color = widget.color ?? widget.defaultColor;
    final noteContent = widget.noteContent ?? widget.defaultNote;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF0F5), color.withValues(alpha: 0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const FallingHearts(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DayIcon(icon: icon, color: color),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _noteVisible ? const SizedBox.shrink() : AnimatedEnvelope(onOpen: _openEnvelope, accentColor: color),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _noteVisible ? NotePaper(content: noteContent) : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  if (_noteVisible)
                    FloatingActionButton.small(
                      onPressed: _reset,
                      backgroundColor: color,
                      child: const Icon(Icons.replay),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
