import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_providers.dart';
import 'package:just_audio/just_audio.dart';

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
        await player.setAsset('assets/audio/valentine.wav');
        player.setLoopMode(LoopMode.one);
        player.setVolume(0.3);
        player.play();
      } catch (_) {}
    }();
  }

  @override
  void dispose() {
    try {
      final player = ref.read(audioPlayerProvider);
      player.stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memories = List.generate(6, (i) => 'assets/images/valentine_memory${i + 1}.png');
    return Scaffold(
      appBar: AppBar(title: const Text('Feb 14 - Valentine'), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 8),
          ...memories.asMap().entries.map((e) => _MemoryTile(index: e.key, imagePath: e.value)),
          const SizedBox(height: 32),
          const Text('I love you', style: TextStyle(fontSize: 32, fontFamily: 'Handwritten')),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _MemoryTile extends StatefulWidget {
  final int index;
  final String imagePath;
  const _MemoryTile({required this.index, required this.imagePath});

  @override
  State<_MemoryTile> createState() => _MemoryTileState();
}

class _MemoryTileState extends State<_MemoryTile> {
  bool _flipped = false;

  final List<String> _notes = [
    'Our first moment together...',
    'You made me smile that day 💕',
    'One of my favorite memories',
    'Your laugh is my favorite sound',
    'Every moment with you is special',
    'Forever starts with you',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _flipped = !_flipped),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (w, a) => ScaleTransition(scale: a, child: w),
          child: _flipped
              ? Container(
                  key: ValueKey('note_${widget.index}'),
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                  border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _notes[widget.index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontFamily: 'Handwritten', height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      const Text('(Tap to see photo)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                )
              : Container(
                  key: ValueKey('photo_${widget.index}'),
                  height: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.pink[100],
                        child: const Center(child: Text('Photo\n(Replace with your image)', textAlign: TextAlign.center)),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
