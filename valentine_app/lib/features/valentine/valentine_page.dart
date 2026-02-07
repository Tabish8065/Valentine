import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/state/app_providers.dart';

// ── Data model for each memory milestone ────────────────────────────────────
class _MemoryMilestone {
  final String imagePath;
  final String label;
  final String note;
  final IconData icon;

  const _MemoryMilestone({
    required this.imagePath,
    required this.label,
    required this.note,
    required this.icon,
  });
}

const List<_MemoryMilestone> _milestones = [
  _MemoryMilestone(
    imagePath: 'assets/images/valentine_memory1.jpg',
    label: 'Unforgettable Day',
    note: 'A happy moment together... \nI will try that this stays forever and the journey has just started we have miles to go further.',
    icon: Icons.flag_outlined,
  ),
  _MemoryMilestone(
    imagePath: 'assets/images/valentine_memory2.jpg',
    label: 'Warmthness of love',
    note: 'Your cuddle made me feel the love you were trying to show me. I felt the warmthness of you love. \u{1F495}',
    icon: Icons.auto_awesome,
  ),
  _MemoryMilestone(
    imagePath: 'assets/images/valentine_memory3.jpg',
    label: 'Birthday Celebration',
    note: 'The unforgettable enjoyment of celebrating your birthday together. \nI hope we can celebrate many more together in the future.',
    icon: Icons.explore_outlined,
  ),
  _MemoryMilestone(
    imagePath: 'assets/images/valentine_memory4.jpg',
    label: 'Laughter & Joy',
    note: 'A movie night filled with laughter and joy. \nThe ride back to home was even more memorable, with cool breeze and you. \u{1F604}',
    icon: Icons.emoji_emotions_outlined,
  ),
  _MemoryMilestone(
    imagePath: 'assets/images/valentine_memory5.jpg',
    label: 'A Precious Day',
    note: 'The day when the noida journey began. The day of a long ride in cool breeze and you with me.',
    icon: Icons.diamond_outlined,
  ),
  _MemoryMilestone(
    imagePath: 'assets/images/valentine_memory6.png',
    label: 'Not the end',
    note: 'Forever starts with you. Its not the end of the journey, I am waiting for you in hyderabad.',
    icon: Icons.favorite_border,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
class ValentinePage extends ConsumerStatefulWidget {
  const ValentinePage({super.key});

  @override
  ConsumerState<ValentinePage> createState() => _ValentinePageState();
}

class _ValentinePageState extends ConsumerState<ValentinePage> {
  @override
  void initState() {
    super.initState();
    final player = ref.read(audioPlayerProvider);
    () async {
      try {
        await playBackgroundAudio(player, 'assets/audio/valentine.mp3');
      } catch (e) {
        debugPrint('Audio error (valentine): $e');
      }
    }();
  }

  @override
  void dispose() {
    try {
      ref.read(audioPlayerProvider).stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Our Treasure Map',
          style: TextStyle(
            fontFamily: 'Handwritten',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppTheme.valentineGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 100,
            bottom: 48,
          ),
          child: Column(
            children: [
              // ── Treasure map header ──
              const _TreasureMapHeader(),
              const SizedBox(height: 32),

              // ── Journey milestones ──
              _TreasureTrail(milestones: _milestones),

              const SizedBox(height: 16),

              // ── Grand finale: the treasure ──
              const _GrandTreasureFinale(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Treasure map header with compass & scroll feel ──────────────────────────
class _TreasureMapHeader extends StatefulWidget {
  const _TreasureMapHeader();

  @override
  State<_TreasureMapHeader> createState() => _TreasureMapHeaderState();
}

class _TreasureMapHeaderState extends State<_TreasureMapHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Anim.slow);
    _fade = CurvedAnimation(parent: _ctrl, curve: Anim.defaultIn);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Anim.bounce),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: Column(
        children: [
          // Compass icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.warmCream,
              border: Border.all(
                color: AppTheme.roseGold,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.roseGold.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.explore,
              color: AppTheme.roseGoldDark,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Follow the trail of our love...',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Handwritten',
              color: AppTheme.textMedium,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap each memory to reveal its secret',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textLight,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Treasure trail with winding dotted path ─────────────────────────────────
class _TreasureTrail extends StatelessWidget {
  final List<_MemoryMilestone> milestones;
  const _TreasureTrail({required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(milestones.length, (index) {
        final isOdd = index % 2 == 1;
        return Column(
          children: [
            // Winding dotted path connector (except before the first item).
            if (index > 0)
              SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomPaint(
                  painter: _DottedPathPainter(
                    fromRight: (index - 1) % 2 == 1,
                    toRight: isOdd,
                  ),
                ),
              ),
            // The milestone row.
            _MilestoneRow(
              milestone: milestones[index],
              index: index,
              isOdd: isOdd,
              total: milestones.length,
            ),
          ],
        );
      }),
    );
  }
}

// ── A single milestone row (pin + card) ─────────────────────────────────────
class _MilestoneRow extends StatelessWidget {
  final _MemoryMilestone milestone;
  final int index;
  final bool isOdd;
  final int total;
  const _MilestoneRow({
    required this.milestone,
    required this.index,
    required this.isOdd,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pin = _MilestonePin(index: index, icon: milestone.icon);
    final card = Expanded(
      flex: 3,
      child: _StaggeredTreasureCard(
        milestone: milestone,
        index: index,
      ),
    );
    final label = Expanded(
      flex: 1,
      child: _MilestoneLabel(label: milestone.label, index: index),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isOdd
            ? [
                card,
                const SizedBox(width: 12),
                pin,
                const SizedBox(width: 8),
                label,
              ]
            : [
                label,
                const SizedBox(width: 8),
                pin,
                const SizedBox(width: 12),
                card,
              ],
      ),
    );
  }
}

// ── Milestone label ─────────────────────────────────────────────────────────
class _MilestoneLabel extends StatelessWidget {
  final String label;
  final int index;
  const _MilestoneLabel({required this.label, required this.index});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontFamily: 'Handwritten',
        color: AppTheme.textMedium,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ── Milestone pin (numbered marker) ─────────────────────────────────────────
class _MilestonePin extends StatefulWidget {
  final int index;
  final IconData icon;
  const _MilestonePin({required this.index, required this.icon});

  @override
  State<_MilestonePin> createState() => _MilestonePinState();
}

class _MilestonePinState extends State<_MilestonePin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Anim.medium);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Anim.bounce),
    );
    Future.delayed(Anim.staggerDelay * (widget.index + 1), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.scale(scale: _scale.value, child: child);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pin head
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: AppTheme.pinGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppTheme.warmCream, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.45),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${widget.index + 1}',
                style: const TextStyle(
                  color: AppTheme.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Pin tail
          Container(
            width: 3,
            height: 10,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Staggered entrance for each treasure card ───────────────────────────────
class _StaggeredTreasureCard extends StatefulWidget {
  final _MemoryMilestone milestone;
  final int index;
  const _StaggeredTreasureCard({
    required this.milestone,
    required this.index,
  });

  @override
  State<_StaggeredTreasureCard> createState() =>
      _StaggeredTreasureCardState();
}

class _StaggeredTreasureCardState extends State<_StaggeredTreasureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Anim.slow);
    _fade = CurvedAnimation(parent: _ctrl, curve: Anim.defaultIn);
    final isOdd = widget.index % 2 == 1;
    _slide = Tween<double>(begin: isOdd ? -40.0 : 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Anim.defaultOut),
    );

    Future.delayed(Anim.staggerDelay * (widget.index + 1), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(_slide.value, 0),
            child: child,
          ),
        );
      },
      child: _TreasureCard(
        milestone: widget.milestone,
        index: widget.index,
      ),
    );
  }
}

// ── Treasure card with flip to reveal note ──────────────────────────────────
class _TreasureCard extends StatefulWidget {
  final _MemoryMilestone milestone;
  final int index;
  const _TreasureCard({required this.milestone, required this.index});

  @override
  State<_TreasureCard> createState() => _TreasureCardState();
}

class _TreasureCardState extends State<_TreasureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Anim.cardFlip,
      vsync: this,
    );
    _curved = CurvedAnimation(
      parent: _controller,
      curve: Anim.cardFlipCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_flipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _flipped = !_flipped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _curved,
        builder: (context, child) {
          final angle = _curved.value * pi;
          final isBack = _curved.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _TreasureNoteCard(
                      note: widget.milestone.note,
                      icon: widget.milestone.icon,
                    ),
                  )
                : _TreasurePhotoCard(
                    imagePath: widget.milestone.imagePath,
                    label: widget.milestone.label,
                  ),
          );
        },
      ),
    );
  }
}

// ── Treasure-styled photo card ──────────────────────────────────────────────
class _TreasurePhotoCard extends StatelessWidget {
  final String imagePath;
  final String label;
  const _TreasurePhotoCard({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.roseGoldLight,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.roseGoldDark.withValues(alpha: 0.2),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.blush, AppTheme.champagne],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 36,
                          color: AppTheme.roseGold,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textMedium,
                            fontFamily: 'Handwritten',
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Subtle gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primaryDark.withValues(alpha: 0.35),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // "Tap to reveal" hint
              Positioned(
                bottom: 6,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 12,
                      color: AppTheme.textOnPrimary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'tap',
                      style: TextStyle(
                        color: AppTheme.textOnPrimary.withValues(alpha: 0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Treasure note card (flip back side) ─────────────────────────────────────
class _TreasureNoteCard extends StatelessWidget {
  final String note;
  final IconData icon;
  const _TreasureNoteCard({required this.note, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: AppTheme.noteCardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.roseGoldLight,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.roseGoldDark.withValues(alpha: 0.2),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: AppTheme.deepCoral),
              const SizedBox(height: 10),
              Text(
                note,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Handwritten',
                  height: 1.5,
                  color: AppTheme.textMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dotted winding path painter ─────────────────────────────────────────────
class _DottedPathPainter extends CustomPainter {
  final bool fromRight;
  final bool toRight;

  _DottedPathPainter({required this.fromRight, required this.toRight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.pathColor.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Start and end x positions based on direction.
    final startX = fromRight ? size.width * 0.3 : size.width * 0.7;
    final endX = toRight ? size.width * 0.3 : size.width * 0.7;

    path.moveTo(startX, 0);
    path.cubicTo(
      startX,
      size.height * 0.3,
      endX,
      size.height * 0.7,
      endX,
      size.height,
    );

    // Draw dashed path.
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + 5).clamp(0.0, metric.length);
        final extractedPath = metric.extractPath(start, end);
        canvas.drawPath(extractedPath, paint);
        distance += 10; // 5 on, 5 off
      }
    }

    // Draw small decorative dots at intervals.
    final dotPaint = Paint()
      ..color = AppTheme.pathColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    for (final metric in pathMetrics) {
      for (double d = 0; d < metric.length; d += 20) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 1.5, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DottedPathPainter oldDelegate) =>
      fromRight != oldDelegate.fromRight || toRight != oldDelegate.toRight;
}

// ── Grand Treasure Finale ───────────────────────────────────────────────────
class _GrandTreasureFinale extends StatefulWidget {
  const _GrandTreasureFinale();

  @override
  State<_GrandTreasureFinale> createState() => _GrandTreasureFinaleState();
}

class _GrandTreasureFinaleState extends State<_GrandTreasureFinale>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  late final AnimationController _glowCtrl;
  late final CurvedAnimation _glowCurved;

  late final AnimationController _sparkleCtrl;

  bool _revealed = false;
  late final AnimationController _revealCtrl;
  late final Animation<double> _revealFade;
  late final Animation<double> _revealScale;

  @override
  void initState() {
    super.initState();

    // Entrance animation – delayed to appear after milestones.
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = CurvedAnimation(parent: _entranceCtrl, curve: Anim.defaultIn);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Anim.bounce),
    );
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _entranceCtrl.forward();
    });

    // Continuous golden glow pulse.
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowCurved = CurvedAnimation(parent: _glowCtrl, curve: Anim.gentle);

    // Sparkle rotation.
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Reveal animation for the hidden message.
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _revealFade = CurvedAnimation(parent: _revealCtrl, curve: Anim.defaultIn);
    _revealScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _revealCtrl, curve: Anim.bounce),
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _glowCtrl.dispose();
    _sparkleCtrl.dispose();
    _revealCtrl.dispose();
    super.dispose();
  }

  void _onTreasureTapped() {
    if (!_revealed) {
      setState(() => _revealed = true);
      _revealCtrl.forward();
    } else {
      setState(() => _revealed = false);
      _revealCtrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: Column(
        children: [
          // Dotted path leading to treasure.
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: _FinalPathPainter(),
            ),
          ),

          // ── The treasure chest ──
          GestureDetector(
            onTap: _onTreasureTapped,
            child: AnimatedBuilder(
              animation: _glowCurved,
              builder: (context, child) {
                final glowIntensity = 0.3 + 0.7 * _glowCurved.value;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.deepCoral
                            .withValues(alpha: 0.18 * glowIntensity),
                        AppTheme.primary
                            .withValues(alpha: 0.08 * glowIntensity),
                        Colors.transparent,
                      ],
                      radius: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.deepCoral
                            .withValues(alpha: 0.3 * glowIntensity),
                        blurRadius: 32 * glowIntensity,
                        spreadRadius: 6 * glowIntensity,
                      ),
                      BoxShadow(
                        color: AppTheme.roseGold
                            .withValues(alpha: 0.15 * glowIntensity),
                        blurRadius: 48 * glowIntensity,
                        spreadRadius: 8 * glowIntensity,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Sparkle ring.
                  AnimatedBuilder(
                    animation: _sparkleCtrl,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _sparkleCtrl.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: _SparklePainter(),
                    ),
                  ),
                  // Central treasure icon.
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.deepCoral, AppTheme.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: AppTheme.blush,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.5),
                          blurRadius: 18,
                          spreadRadius: 3,
                        ),
                        BoxShadow(
                          color: AppTheme.roseGold.withValues(alpha: 0.3),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: AppTheme.textOnPrimary,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // "X marks the spot" label.
          Text(
            _revealed ? '' : 'X marks the spot',
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Handwritten',
              color: AppTheme.textMedium,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 4),

          if (!_revealed)
            const Text(
              'Tap to reveal the treasure',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textLight,
                fontStyle: FontStyle.italic,
              ),
            ),

          const SizedBox(height: 16),

          // ── Revealed treasure message ──
          AnimatedBuilder(
            animation: _revealCtrl,
            builder: (context, child) {
              return Opacity(
                opacity: _revealFade.value,
                child: Transform.scale(
                  scale: _revealScale.value,
                  child: child,
                ),
              );
            },
            child: _revealed ? _buildTreasureMessage() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTreasureMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.warmCream, AppTheme.blush, AppTheme.warmCream],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.roseGold,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepCoral.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: AppTheme.roseGoldDark.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '\u2728',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 12),
          const Text(
            'The Greatest Treasure',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Handwritten',
              color: AppTheme.textDark,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Every path I have ever walked\nled me to you.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Handwritten',
              color: AppTheme.textMedium,
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: AppTheme.roseGold,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You are my forever treasure.\nI love you with all my heart.\nHappy Valentine day. I hope I was able to make each of your day feel special.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Handwritten',
              color: AppTheme.textDark,
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            '\u2665',
            style: TextStyle(
              fontSize: 32,
              color: AppTheme.deepCoral,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Final path painter (leading to treasure) ────────────────────────────────
class _FinalPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.roseGold.withValues(alpha: 0.55)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.7,
      size.width * 0.5,
      size.height,
    );

    // Dashed.
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + 6).clamp(0.0, metric.length);
        final extractedPath = metric.extractPath(start, end);
        canvas.drawPath(extractedPath, paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Sparkle painter (rotating decorative dots around treasure) ───────────────
class _SparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 4;

    final paint = Paint()..style = PaintingStyle.fill;

    const sparkleCount = 8;
    for (int i = 0; i < sparkleCount; i++) {
      final angle = (2 * pi / sparkleCount) * i;
      final x = cx + radius * cos(angle);
      final y = cy + radius * sin(angle);

      // Alternate between rose-gold and deep coral sparkles.
      final isGold = i % 2 == 0;
      paint.color = isGold
          ? AppTheme.roseGold.withValues(alpha: 0.7)
          : AppTheme.deepCoral.withValues(alpha: 0.55);

      final sparkleSize = isGold ? 3.0 : 2.0;

      // Draw a small diamond / 4-pointed star.
      final starPath = Path();
      starPath.moveTo(x, y - sparkleSize);
      starPath.lineTo(x + sparkleSize * 0.5, y);
      starPath.lineTo(x, y + sparkleSize);
      starPath.lineTo(x - sparkleSize * 0.5, y);
      starPath.close();
      canvas.drawPath(starPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
