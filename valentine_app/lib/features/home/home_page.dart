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
import 'dart:math';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Stream<DateTime> _countdownStream;

  // Define unlock dates for each Valentine week day
  // Pages will be locked until their respective date arrives
  static const Map<int, int> pageUnlockDates = {
    // For testing: map actual days to Feb 1..7 so pages unlock earlier
    1: 1,   // Rose Day - Test unlock Feb 1
    2: 1,   // Propose Day - Test unlock Feb 2
    3: 1,   // Chocolate Day - Test unlock Feb 3
    4: 1,   // Teddy Day - Test unlock Feb 4
    5: 1,   // Promise Day - Test unlock Feb 5
    6: 1,   // Hug Day - Test unlock Feb 6
    7: 1,   // Kiss Day - Test unlock Feb 7
    8: 1,   // Valentine Day - Test unlock Feb 8
  };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    
    // Create a broadcast stream that emits the current time every second
    // Use asBroadcastStream() to allow multiple listeners
    _countdownStream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()).asBroadcastStream();
    
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
      1: 'Rose Day',
      2: 'Propose Day',
      3: 'Chocolate Day',
      4: 'Teddy Day',
      5: 'Promise Day',
      6: 'Hug Day',
      7: 'Kiss Day',
    };

  bool _locked(int day) {
    final now = DateTime.now();
    final unlockDate = pageUnlockDates[day];

    if (unlockDate == null) return true; // Safety: lock if day not found

    // Page is locked if current date is before the unlock date in February
    return now.month != 2 || now.day < unlockDate;
  }

  String _getCountdownText(int day) {
    final now = DateTime.now();
    final unlockDate = pageUnlockDates[day];
    
    if (unlockDate == null) return 'N/A';
    
    // Create unlock datetime for Feb [day] at 00:00:00
    final targetDate = DateTime(now.year, 2, unlockDate, 0, 0, 0);
    
    // If we're past the unlock date, return empty
    if (!now.isBefore(targetDate)) return '';
    
    final remaining = targetDate.difference(now);
    
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    
    return '$days days $hours hrs $minutes mins $seconds secs remaining';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valentine Week'),
        backgroundColor: AppTheme.primary,
        elevation: 0,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(child: Text('Valentine Week', style: TextStyle(fontSize: 20))),
              ..._days.entries.map((e) {
                final entry = e; // capture per-iteration value to avoid closure capture bug
                final locked = _locked(entry.key);
                return StreamBuilder<DateTime>(
                  stream: _countdownStream,
                  builder: (context, snapshot) {
                    return ListTile(
                      leading: Icon(locked ? Icons.lock : Icons.check, color: locked ? Colors.grey : AppTheme.primary),
                      title: Text(entry.value),
                      subtitle: locked ? Text(_getCountdownText(entry.key), style: const TextStyle(fontSize: 12)) : null,
                      onTap: locked
                          ? null
                          : () {
                              Widget page;
                              switch (entry.key) {
                                case 1:
                                  page = const RosePage();
                                  break;
                                case 2:
                                  page = const ProposePage();
                                  break;
                                case 3:
                                  page = const ChocolatePage();
                                  break;
                                case 4:
                                  page = const TeddyPage();
                                  break;
                                case 5:
                                  page = const PromisePage();
                                  break;
                                case 6:
                                  page = const HugPage();
                                  break;
                                case 7:
                                  page = const KissPage();
                                  break;
                                default:
                                  page = DayPage(day: entry.key);
                              }
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
                            },
                    );
                  },
                );
              }),
              StreamBuilder<DateTime>(
                stream: _countdownStream,
                builder: (context, snapshot) {
                  final locked = _locked(8);
                  final countdown = _getCountdownText(8);
                  return ListTile(
                    leading: Icon(locked ? Icons.lock : Icons.favorite, color: locked ? Colors.grey : Colors.pink),
                    title: const Text('Valentine Day'),
                    subtitle: locked && countdown.isNotEmpty ? Text(countdown, style: const TextStyle(fontSize: 12)) : null,
                    onTap: locked
                        ? null
                        : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ValentinePage())),
                  );
                },
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
                  Text('Hi Name, my love ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  _GlowingHeart(),
                ]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Welcome ♥'))),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                child: const Text('Open'),
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
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.pink.withValues(alpha: glow * 0.45), blurRadius: 12 * glow)]),
          child: const Icon(Icons.favorite, color: Colors.pink, size: 28),
        );
      },
    );
  }
}
