import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/page_transitions.dart';
import '../../core/state/app_providers.dart';
import '../../widgets/falling_hearts.dart';

import '../days/day_page.dart';
import '../days/rose_page.dart';
import '../days/propose_page.dart';
import '../days/chocolate_page.dart';
import '../days/teddy_page.dart';
import '../days/promise_page.dart';
import '../days/hug_page.dart';
import '../days/kiss_page.dart';
import '../valentine/valentine_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────
  late final AnimationController _bobCtrl;
  late final CurvedAnimation _bobCurved;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _buttonSlide;
  late final Animation<double> _buttonFade;

  // Single timer for countdown instead of multiple StreamBuilders.
  Timer? _countdownTimer;

  // ── Unlock dates ───────────────────────────────────────────────────────────
  static const Map<int, int> pageUnlockDates = {
    1: 1, // Rose Day
    2: 1, // Propose Day
    3: 1, // Chocolate Day
    4: 1, // Teddy Day
    5: 1, // Promise Day
    6: 1, // Hug Day
    7: 1, // Kiss Day
    8: 1, // Valentine Day
  };

  final Map<int, String> _days = const {
    1: 'Rose Day',
    2: 'Propose Day',
    3: 'Chocolate Day',
    4: 'Teddy Day',
    5: 'Promise Day',
    6: 'Hug Day',
    7: 'Kiss Day',
  };

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // Gentle bobbing animation with smooth sine‑curve.
    _bobCtrl = AnimationController(vsync: this, duration: Anim.heartBob)
      ..repeat(reverse: true);
    _bobCurved = CurvedAnimation(parent: _bobCtrl, curve: Anim.gentle);

    // Staggered entrance for title + button.
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _buttonSlide = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.35, 0.75, curve: Curves.easeIn),
      ),
    );
    _entranceCtrl.forward();

    // Single 1‑second timer for countdown refresh.
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) setState(() {});
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoNavigate());

    // Background audio.
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
        Navigator.of(context).push(ScaleFadeRoute(page: const ValentinePage()));
      } else {
        Navigator.of(context).push(FadeSlideRoute(page: DayPage(day: day)));
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    try {
      ref.read(audioPlayerProvider).stop();
    } catch (_) {}
    _bobCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool _locked(int day) {
    final now = DateTime.now();
    final unlockDate = pageUnlockDates[day];
    if (unlockDate == null) return true;
    return now.month != 2 || now.day < unlockDate;
  }

  String _getCountdownText(int day) {
    final now = DateTime.now();
    final unlockDate = pageUnlockDates[day];
    if (unlockDate == null) return 'N/A';
    final targetDate = DateTime(now.year, 2, unlockDate);
    if (!now.isBefore(targetDate)) return '';
    final remaining = targetDate.difference(now);
    final d = remaining.inDays;
    final h = remaining.inHours % 24;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;
    return '$d days $h hrs $m mins $s secs remaining';
  }

  void _navigateToDay(int key) {
    Widget page;
    switch (key) {
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
        page = DayPage(day: key);
    }
    Navigator.of(context).push(FadeSlideRoute(page: page));
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Valentine Week',
          style: TextStyle(
            fontFamily: 'Handwritten',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.textOnPrimary,
          ),
        ),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textOnPrimary),
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Background gradient.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.homeGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const FallingHearts(),
          Center(
            child: AnimatedBuilder(
              animation: _entranceCtrl,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Floating title with smooth bob ──
                    Opacity(
                      opacity: _titleFade.value,
                      child: Transform.translate(
                        offset: Offset(0, _titleSlide.value),
                        child: AnimatedBuilder(
                          animation: _bobCurved,
                          builder: (context, child) {
                            final dy = (_bobCurved.value - 0.5) * 6.0;
                            final scale = 0.97 + 0.03 * _bobCurved.value;
                            return Transform.translate(
                              offset: Offset(0, dy),
                              child: Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Hi Zainab, my love ',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Handwritten',
                                  color: AppTheme.textDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const _GlowingHeart(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ── Button with staggered fade‑in ──
                    Opacity(
                      opacity: _buttonFade.value,
                      child: Transform.translate(
                        offset: Offset(0, _buttonSlide.value),
                        child: ElevatedButton(
                          onPressed: () => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                const SnackBar(content: Text('Welcome ♥')),
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.textOnPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            shadowColor: AppTheme.primary.withValues(alpha: 0.4),
                          ),
                          child: const Text(
                            'Open My Heart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Drawer (rebuilt once per second via single Timer.periodic) ──────────
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppTheme.warmCream,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.favorite, color: AppTheme.blush, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Valentine Week',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Handwritten',
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A week of love, just for you',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textOnPrimary.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            ..._days.entries.map((entry) {
              final locked = _locked(entry.key);
              return ListTile(
                leading: Icon(
                  locked ? Icons.lock_outline : Icons.favorite,
                  color: locked
                      ? AppTheme.roseGoldLight.withValues(alpha: 0.5)
                      : AppTheme.primary,
                ),
                title: Text(
                  entry.value,
                  style: TextStyle(
                    color: locked ? AppTheme.textLight : AppTheme.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: locked
                    ? Text(
                        _getCountdownText(entry.key),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight.withValues(alpha: 0.7),
                        ),
                      )
                    : null,
                onTap: locked ? null : () => _navigateToDay(entry.key),
              );
            }),
            const Divider(color: AppTheme.roseGoldLight, indent: 16, endIndent: 16),
            Builder(builder: (_) {
              final locked = _locked(8);
              final countdown = _getCountdownText(8);
              return ListTile(
                leading: Icon(
                  locked ? Icons.lock_outline : Icons.favorite,
                  color: locked
                      ? AppTheme.roseGoldLight.withValues(alpha: 0.5)
                      : AppTheme.deepCoral,
                ),
                title: Text(
                  'Valentine Day',
                  style: TextStyle(
                    color: locked ? AppTheme.textLight : AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: locked && countdown.isNotEmpty
                    ? Text(
                        countdown,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight.withValues(alpha: 0.7),
                        ),
                      )
                    : null,
                onTap: locked
                    ? null
                    : () => Navigator.of(context).push(
                          ScaleFadeRoute(page: const ValentinePage()),
                        ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Glowing Heart ────────────────────────────────────────────────────────────
class _GlowingHeart extends StatefulWidget {
  const _GlowingHeart();

  @override
  State<_GlowingHeart> createState() => _GlowingHeartState();
}

class _GlowingHeartState extends State<_GlowingHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: Anim.heartGlow)
      ..repeat(reverse: true);
    _curved = CurvedAnimation(parent: _c, curve: Anim.gentle);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      builder: (context, child) {
        final glow = 0.55 + 0.45 * _curved.value;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepCoral.withValues(alpha: glow * 0.5),
                blurRadius: 18 * glow,
                spreadRadius: 2 * glow,
              ),
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: glow * 0.25),
                blurRadius: 28 * glow,
                spreadRadius: 4 * glow,
              ),
            ],
          ),
          child: Transform.scale(
            scale: 0.92 + 0.08 * _curved.value,
            child: child,
          ),
        );
      },
      child: const Icon(Icons.favorite, color: AppTheme.deepCoral, size: 30),
    );
  }
}
