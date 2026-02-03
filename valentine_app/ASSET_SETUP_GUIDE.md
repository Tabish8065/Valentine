# Asset Setup Guide — Valentine App

This guide provides step-by-step instructions to download and set up all required assets (fonts, audio, images).

---

## Quick Start

### Windows Users
```bash
setup_assets.bat
```

### macOS/Linux Users
```bash
bash setup_assets.sh
```

Then follow the manual steps below.

---

## 1. Font Setup: Great Vibes

### Option A: Automatic (if using script)
The setup script will attempt to download the font automatically.

### Option B: Manual Download

1. **Download the font:**
   - URL: https://github.com/google/fonts/raw/main/ofl/greatvibes/GreatVibes-Regular.ttf
   - Or visit: https://fonts.google.com/specimen/Great+Vibes → "Get font" button

2. **Place the file:**
   ```
   valentine_app/
   └── assets/
       └── fonts/
           └── GreatVibes-Regular.ttf  ← Place here
   ```

3. **Verify in pubspec.yaml** (already configured):
   ```yaml
   fonts:
     - family: Handwritten
       fonts:
         - asset: assets/fonts/GreatVibes-Regular.ttf
   ```

---

## 2. Audio Setup: Romantic Background Music

### Home Screen Audio (`home.wav`)

1. **Find royalty-free romantic/ambient music:**
   - **Free Music Archive:** https://freemusicarchive.org
     - Search: "ambient", "romantic", "instrumental"
     - Filter: Instrument → Ambient
   - **Other sources:**
     - YouTube Audio Library (youtube.com/audio_library)
     - Pixabay Music (pixabay.com/music)
     - Bensound (bensound.com) – "Romantic" category

2. **Recommended specs:**
   - Duration: 2–4 minutes (will loop)
   - Volume: medium to low
   - Genres: ambient, instrumental, lo-fi, piano

3. **Download & place:**
   ```
   valentine_app/
   └── assets/
       └── audio/
           └── home.wav  ← Place here
   ```

### Valentine Day Audio (`valentine.wav`)

Repeat the same process for Valentine Day (can be the same track or a different one).

```
valentine_app/
└── assets/
    └── audio/
        └── valentine.wav  ← Place here
```

### Suggested Tracks (Free Music Archive)

- **"A New Beginning"** by Ólafur Arnalds
- **"Ambient Piano"** by Keys of Moon
- **"Love Will Find You"** by Podington Bear

---

## 3. Image Setup: Day Photos & Memories

### Day Photos (photo1.png – photo7.png)

These are used as placeholders for each Valentine Week day.

1. **Find stock images:**
   - **Unsplash:** https://unsplash.com (search "love", "romantic", "flowers")
   - **Pexels:** https://pexels.com
   - **Pixabay:** https://pixabay.com

2. **Recommended for each day:**
   - **photo1.png** (Rose Day) – red roses, flowers
   - **photo2.png** (Propose Day) – engagement rings, couples
   - **photo3.png** (Chocolate Day) – chocolate, sweets
   - **photo4.png** (Teddy Day) – teddy bears, plush toys
   - **photo5.png** (Promise Day) – hands together, promise, commitment
   - **photo6.png** (Hug Day) – hugging couples, warmth
   - **photo7.png** (Kiss Day) – romantic couples, love

3. **Image specs:**
   - Size: 400×300 pixels (recommended)
   - Format: PNG or JPG
   - License: Royalty-free (CC0 preferred)

4. **Place files:**
   ```
   valentine_app/
   └── assets/
       └── images/
           ├── photo1.png   (Rose Day)
           ├── photo2.png   (Propose Day)
           ├── photo3.png   (Chocolate Day)
           ├── photo4.png   (Teddy Day)
           ├── photo5.png   (Promise Day)
           ├── photo6.png   (Hug Day)
           └── photo7.png   (Kiss Day)
   ```

### Valentine Day Memory Photos (valentine_memory1.png – valentine_memory6.png)

These are **your personal photos** that display as flip cards on Feb 14.

1. **Select your photos:**
   - Any personal memories, screenshots, or moments
   - Can be anything meaningful to Zainab

2. **Image specs:**
   - Size: 400×500 pixels (portrait, recommended)
   - Format: PNG or JPG
   - Count: 6 photos (can add more by editing the code)

3. **Place files:**
   ```
   valentine_app/
   └── assets/
       └── images/
           ├── valentine_memory1.png
           ├── valentine_memory2.png
           ├── valentine_memory3.png
           ├── valentine_memory4.png
           ├── valentine_memory5.png
           └── valentine_memory6.png
   ```

4. **To add/change memories:**
   Edit `lib/features/valentine/valentine_page.dart` in the `_notes` list:
   ```dart
   final List<String> _notes = [
     'Your custom note for memory 1',
     'Your custom note for memory 2',
     // ... etc
   ];
   ```

---

## Complete Directory Structure

After setup, your `assets/` folder should look like:

```
valentine_app/
└── assets/
    ├── audio/
    │   ├── home.wav           (2–4 min ambient music)
    │   └── valentine.wav      (2–4 min romantic music)
    ├── fonts/
    │   └── GreatVibes-Regular.ttf
    └── images/
        ├── photo1.png         (Rose Day placeholder)
        ├── photo2.png         (Propose Day placeholder)
        ├── photo3.png         (Chocolate Day placeholder)
        ├── photo4.png         (Teddy Day placeholder)
        ├── photo5.png         (Promise Day placeholder)
        ├── photo6.png         (Hug Day placeholder)
        ├── photo7.png         (Kiss Day placeholder)
        ├── valentine_memory1.png
        ├── valentine_memory2.png
        ├── valentine_memory3.png
        ├── valentine_memory4.png
        ├── valentine_memory5.png
        └── valentine_memory6.png
```

---

## Testing Locally

1. **Download and place all assets** in the correct directories
2. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```
3. **Test:**
   - Tap the "Open" button on Home screen
   - Open the drawer and tap each day
   - Tap Feb 14 to see memory photos

---

## Troubleshooting

### Images not showing?
- Verify file names match exactly (case-sensitive)
- Check file paths in `pubspec.yaml` (should be `assets/images/`)
- Ensure image files are in the correct directory

### Audio not playing?
- Verify file paths and names
- Check app volume is not muted
- If assets are missing, the app will silently skip audio (no crash)

### Font not rendering?
- Download the full TTF file (not WOFF or other formats)
- Verify filename matches `pubspec.yaml` exactly
- Run `flutter clean && flutter pub get` after placing font

### On Android: "Failed to load asset"?
- Make sure `android/app/src/main/AndroidManifest.xml` has proper permissions
- Clean and rebuild: `flutter clean && flutter pub get && flutter run`

---

## Next Steps

1. ✅ Download and place assets
2. ✅ Run `flutter pub get`
3. ✅ Test with `flutter run`
4. ✅ Build APK: `flutter build apk --release`
5. ✅ Install on device

---

## Free Resources Summary

| Resource | Purpose | Links |
|----------|---------|-------|
| **Great Vibes Font** | Handwritten text | [Google Fonts](https://fonts.google.com/specimen/Great+Vibes) |
| **Ambient Music** | Background audio | [Free Music Archive](https://freemusicarchive.org), [YouTube Audio](https://www.youtube.com/audiolibrary) |
| **Stock Photos** | Placeholder images | [Unsplash](https://unsplash.com), [Pexels](https://pexels.com), [Pixabay](https://pixabay.com) |

---

**Happy Valentine App building!** 💖
