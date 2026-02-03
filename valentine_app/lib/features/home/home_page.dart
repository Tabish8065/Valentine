import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../core/state/app_providers.dart';
import 'package:just_audio/just_audio.dart';
import '../days/day_page.dart';
import '../days/rose_page.dart';
import '../days/propose_page.dart';
import '../days/chocolate_page.dart';
import '../days/teddy_page.dart';
import '../days/promise_page.dart';
import '../days/hug_page.dart';
import '../days/kiss_page.dart';
import '../valentine/valentine_page.dart';
import 'dart:async';
import '../../widgets/falling_hearts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoNavigate());

    // start optional background audio for the home screen
    final player = ref.read(audioPlayerProvider);
    () async {
      try {
        await player.setAsset('assets/audio/home.wav');
        player.setLoopMode(LoopMode.one);
        player.setVolume(0.25);
        player.play();
      } catch (_) {}
    }();
  }

  Future<void> _maybeAutoNavigate() async {
    final now = DateTime.now();
    final day = valentineDayForDate(now);
    if (day != null) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      if (day == 14) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ValentinePage()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DayPage(day: day)));
      }
    }
  }

  @override
  void dispose() {
    // stop home audio when leaving
    try {
      final player = ref.read(audioPlayerProvider);
      player.stop();
    } catch (_) {}
    _ctrl.dispose();
    super.dispose();
  }

    final Map<int, String> _days = const {
      7: 'Rose Day',
      8: 'Propose Day',
      9: 'Chocolate Day',
      10: 'Teddy Day',
      11: 'Promise Day',
      12: 'Hug Day',
      13: 'Kiss Day',
    };

  bool _locked(int day) {
    return isBeforeDay(day, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(child: Text('Valentine Week', style: TextStyle(fontSize: 20))),
              ..._days.entries.map((e) {
                final locked = _locked(e.key);
                return ListTile(
                  leading: Icon(locked ? Icons.lock : Icons.check, color: locked ? Colors.grey : AppTheme.primary),
                  title: Text(e.value),
                  subtitle: locked ? Text('Locked until Feb ${e.key}') : null,
                  onTap: locked
                      ? null
                      : () {
                          Widget page;
                          switch (e.key) {
                            case 7:
                              page = const RosePage();
                              break;
                            case 8:
                              page = const ProposePage();
                              break;
                            case 9:
                              page = const ChocolatePage();
                              break;
                            case 10:
                              page = const TeddyPage();
                              break;
                            case 11:
                              page = const PromisePage();
                              break;
                            case 12:
                              page = const HugPage();
                              break;
                            case 13:
                              page = const KissPage();
                              break;
                            default:
                              page = DayPage(day: e.key);
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
                        },
                );
              }).toList(),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.pink),
                title: const Text('Valentine Day'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ValentinePage())),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFFFF0F5), Color(0xFFFFE6EB)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          const FallingHearts(),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) {
                  final t = _ctrl.value;
                  final dy = (t - 0.5) * 8.0;
                  final scale = 0.96 + 0.04 * (1 + (t - 0.5).abs() * -1);
                  return Transform.translate(
                    offset: Offset(0, dy),
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text('Hi Zainab, my love ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  _GlowingHeart(),
                ]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Welcome ♥'))),
                child: const Text('Open'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _GlowingHeart extends StatefulWidget {
  const _GlowingHeart();

  @override
  State<_GlowingHeart> createState() => _GlowingHeartState();
}

class _GlowingHeartState extends State<_GlowingHeart> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final glow = 0.6 + 0.4 * _c.value;
        return Container(
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.pink.withOpacity(glow * 0.45), blurRadius: 12 * glow)]),
          child: const Icon(Icons.favorite, color: Colors.pink, size: 28),
        );
      },
    );
  }
}
