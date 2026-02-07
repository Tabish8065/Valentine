import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
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
        return AppTheme.roseDay;
      case 8:
        return AppTheme.proposeDay;
      case 9:
        return AppTheme.chocolateDay;
      case 10:
        return AppTheme.teddyDay;
      case 11:
        return AppTheme.promiseDay;
      case 12:
        return AppTheme.hugDay;
      case 13:
        return AppTheme.kissDay;
      default:
        return AppTheme.primary;
    }
  }

  String get defaultNote {
    switch (day) {
      case 7:
        return 'My dearest Zainab,\n\n'
            'If I could give you a rose for every time you made my heart skip a beat, '
            'you would have an endless garden.\n\n'
            'You are the most beautiful thing that has ever happened to me. '
            'Your smile blooms brighter than any flower, and your love fills '
            'every corner of my world with colour.\n\n'
            'Happy Rose Day, my love \u{1F339}\n\n'
            'Forever yours';
      case 8:
        return 'My dearest Zainab,\n\n'
            'I have rehearsed a thousand speeches in my head, but when I look '
            'into your eyes, all I can say is this:\n\n'
            'You are the one I want to wake up next to every morning, the one I '
            'want to share every sunset with, and the one I want to grow old beside.\n\n'
            'I choose you — today, tomorrow, and every day after that. '
            'Will you keep choosing me too?\n\n'
            'Happy Propose Day \u{1F48D}\n\n'
            'All my love';
      case 9:
        return 'My dearest Zainab,\n\n'
            'They say chocolate is the sweetest thing in the world, but whoever '
            'said that never knew you.\n\n'
            'Your laughter is sweeter than the richest truffle, your voice '
            'more soothing than warm cocoa on a cold night, and your love '
            'melts my heart the way nothing else can.\n\n'
            'Life with you is the sweetest treat I never want to stop savouring.\n\n'
            'Happy Chocolate Day \u{1F36B}\n\n'
            'Sweetly yours';
      case 10:
        return 'My dearest Zainab,\n\n'
            'If I could wrap all my love into something you could hold close, '
            'it would still not be enough.\n\n'
            'But until I can be there to hold you myself, let this little teddy '
            'remind you that you are never alone. Squeeze it tight whenever '
            'you miss me, and know that I am thinking of you in that exact same moment.\n\n'
            'You are my comfort, my warmth, my home.\n\n'
            'Happy Teddy Day \u{1F9F8}\n\n'
            'Hugs always';
      case 11:
        return 'My dearest Zainab,\n\n'
            'Today I make you these promises, not because the calendar tells me to, '
            'but because my heart cannot hold them in any longer:\n\n'
            'I promise to be your safe place when the world feels heavy.\n'
            'I promise to celebrate your joy as if it were my own.\n'
            'I promise to choose patience when we stumble.\n'
            'I promise to love you louder on the quiet days.\n'
            'And I promise to never stop trying to be the reason you smile.\n\n'
            'Happy Promise Day \u{1F91D}\n\n'
            'With all my heart';
      case 12:
        return 'My dearest Zainab,\n\n'
            'There is a kind of peace I only find in your arms — the kind '
            'where the whole world goes quiet and nothing else matters.\n\n'
            'Every hug from you feels like coming home after the longest day, '
            'like a whisper that says "everything will be alright." '
            'I carry the warmth of your embrace with me wherever I go.\n\n'
            'One day, I will hold you and never have to let go.\n\n'
            'Happy Hug Day \u{1F917}\n\n'
            'Wrapped in your love';
      case 13:
        return 'My dearest Zainab,\n\n'
            'If I could freeze a single moment in time, it would be the one '
            'right before our lips meet — that heartbeat of anticipation '
            'where the whole universe holds its breath.\n\n'
            'Every kiss with you writes a story that words could never tell. '
            'It is tenderness, it is fire, it is a promise sealed without a sound.\n\n'
            'Tomorrow is Valentine\'s Day, and there is no one else I would '
            'rather share it with than you.\n\n'
            'Happy Kiss Day \u{1F618}\n\n'
            'Yours, always and completely';
      default:
        return 'My dearest Zainab,\n\n'
            'Every day with you is a gift I never want to stop unwrapping.\n\n'
            'I love you \u{1F495}\n\n'
            'Forever yours';
    }
  }

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  bool _noteVisible = false;

  void _openEnvelope() {
    setState(() => _noteVisible = true);
  }

  void _reset() {
    setState(() => _noteVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.icon ?? widget.defaultIcon;
    final color = widget.color ?? widget.defaultColor;
    final noteContent = widget.noteContent ?? widget.defaultNote;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Handwritten',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppTheme.textDark,
      ),
      body: Stack(
        children: [
          // Background gradient.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.homeGradient[0],
                  color.withValues(alpha: 0.12),
                  AppTheme.homeGradient[1],
                ],
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
                  // Envelope → Note transition with smooth crossfade + scale.
                  AnimatedSwitcher(
                    duration: Anim.medium,
                    switchInCurve: Anim.defaultOut,
                    switchOutCurve: Anim.defaultIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.92, end: 1.0)
                              .animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _noteVisible
                        ? const SizedBox.shrink(key: ValueKey('empty-env'))
                        : AnimatedEnvelope(
                            key: const ValueKey('envelope'),
                            onOpen: _openEnvelope,
                            accentColor: color,
                          ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: Anim.medium,
                    switchInCurve: Anim.defaultOut,
                    switchOutCurve: Anim.defaultIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _noteVisible
                        ? NotePaper(
                            key: const ValueKey('note'),
                            content: noteContent,
                          )
                        : const SizedBox.shrink(key: ValueKey('empty-note')),
                  ),
                  const SizedBox(height: 16),
                  // Reset button with animated appearance.
                  AnimatedSwitcher(
                    duration: Anim.fast,
                    switchInCurve: Anim.bounce,
                    child: _noteVisible
                        ? FloatingActionButton.small(
                            key: const ValueKey('reset-btn'),
                            onPressed: _reset,
                            backgroundColor: color,
                            child: const Icon(Icons.replay),
                          )
                        : const SizedBox.shrink(key: ValueKey('empty-btn')),
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
