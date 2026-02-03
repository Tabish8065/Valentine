# Valentine Week Surprise App 💖

A personalized Flutter application for Valentine Week with daily surprise messages for Zainab.

## Features

- **Home Screen** — Animated greeting with falling heart particles
- **7 Valentine Days** — Rose → Kiss (Feb 7–13) with day-specific animations
- **Valentine's Day Special** — Memory photos and flip animations (Feb 14)
- **Envelope Animations** — Envelope flap open, note reveal, replay button
- **Background Music** — Optional soft romantic audio for Home and Valentine pages
- **Date-Based Unlock** — Days lock automatically until their date arrives
- **Riverpod State Management** — Clean, reactive state handling

## Setup

### Prerequisites
- Flutter 3.10+
- Android/iOS SDK

### Installation

```bash
flutter pub get
flutter run
```

### Assets & Customization

#### Audio Files
Place audio files in `assets/audio/`:
- `home.wav` — Background music for home screen
- `valentine.wav` — Background music for Valentine Day page

Recommended: Use royalty-free tracks from [Free Music Archive](https://freemusicarchive.org) or similar.

#### Fonts
Place the handwritten font in `assets/fonts/`:
- `GreatVibes-Regular.ttf` — Download from [Google Fonts](https://fonts.google.com/specimen/Great+Vibes)

The app will gracefully degrade if fonts/audio are missing.

#### Photos
To add memories to Valentine Day, place photos in `assets/images/` and update `lib/features/valentine/valentine_page.dart`.

## Architecture

```
lib/
  main.dart                              — App entry point
  core/
    theme/app_theme.dart                — Light theme definition
    utils/date_utils.dart               — Date utilities
    state/app_providers.dart            — Riverpod providers
  features/
    home/home_page.dart                 — Home screen with falling hearts
    days/
      day_page.dart                     — Shared day page logic
      rose_page.dart, propose_page.dart, ... — Day wrappers
    valentine/valentine_page.dart       — Feb 14 special page
  widgets/
    falling_hearts.dart                 — Background animation
    day_icon.dart                       — Animated day icon
    animated_envelope.dart              — Envelope with flap animation
    note_paper.dart                     — Note content display
```

## Animations

- **Day Icon**: Zoom-in + glow entrance
- **Envelope**: Wiggle loop, flap open on tap
- **Note**: Slide-up fade-in with handwritten style
- **Falling Hearts**: Infinite particle loop in background
- **Glowing Heart**: Breath pulse animation on home screen

## Customization

### Add Custom Day Content

Edit each day wrapper (e.g., `lib/features/days/rose_page.dart`):

```dart
class RosePage extends StatelessWidget {
  const RosePage({super.key});

  @override
  Widget build(BuildContext context) => DayPage(
    day: 7,
    icon: Icons.local_florist,
    color: Colors.red,
    noteContent: 'Your custom message here',
  );
}
```

### Adjust Audio Volume

In `lib/core/state/app_providers.dart`, modify the `setVolume()` call (0.0–1.0):

```dart
player.setVolume(0.5); // increase to 50%
```

## Testing

```bash
flutter test
flutter build apk --release
flutter install
```

## Future Enhancements

- Add real audio files and photos
- Add confetti animations
- Add interactive puzzles
- Add custom message voice recordings
- Server-based message updates

## License

Personal project. Built with ❤️ for Zainab.
