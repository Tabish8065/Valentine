@echo off
REM Valentine App Asset Setup Script (Windows)
REM Run: setup_assets.bat

setlocal enabledelayedexpansion

echo.
echo ===== Valentine App Asset Setup =====
echo.

REM Create directories
echo Creating asset directories...
mkdir assets\fonts 2>nul
mkdir assets\audio 2>nul
mkdir assets\images 2>nul

echo.
echo 1. Downloading Great Vibes Font...
echo.
echo   Download manually from:
echo   https://github.com/google/fonts/raw/main/ofl/greatvibes/GreatVibes-Regular.ttf
echo.
echo   Save to: assets\fonts\GreatVibes-Regular.ttf
echo.

echo 2. Downloading Romantic Audio Files...
echo.
echo   HOME AUDIO:
echo   - Visit: https://freemusicarchive.org
echo   - Search: "romantic" or "ambient"
echo   - Download MP3/WAV (duration 2-4 minutes)
echo   - Save to: assets\audio\home.wav
echo.
echo   VALENTINE AUDIO:
echo   - Similar romantic/ambient track
echo   - Save to: assets\audio\valentine.wav
echo.

echo 3. Stock Photo Images...
echo.
echo   For each day (photo1.png - photo7.png):
echo   - Download from: unsplash.com, pexels.com, or pixabay.com
echo   - Recommended size: 400x300 pixels
echo   - Format: PNG or JPG
echo   - Save to: assets\images\photo{1-7}.png
echo.
echo   For Valentine memories (valentine_memory1.png - valentine_memory6.png):
echo   - Your personal photos
echo   - Recommended size: 400x500 pixels
echo   - Save to: assets\images\valentine_memory{1-6}.png
echo.

echo.
echo ===== DIRECTORY STRUCTURE =====
echo.
echo assets/
echo   ├── audio/
echo   │   ├── home.wav
echo   │   └── valentine.wav
echo   ├── fonts/
echo   │   └── GreatVibes-Regular.ttf
echo   └── images/
echo       ├── photo1.png (Rose Day)
echo       ├── photo2.png (Propose Day)
echo       ├── photo3.png (Chocolate Day)
echo       ├── photo4.png (Teddy Day)
echo       ├── photo5.png (Promise Day)
echo       ├── photo6.png (Hug Day)
echo       ├── photo7.png (Kiss Day)
echo       ├── valentine_memory1.png
echo       ├── valentine_memory2.png
echo       ├── valentine_memory3.png
echo       ├── valentine_memory4.png
echo       ├── valentine_memory5.png
echo       └── valentine_memory6.png
echo.

echo ===== QUICK DOWNLOAD LINKS =====
echo.
echo Font (Great Vibes):
echo https://github.com/google/fonts/raw/main/ofl/greatvibes/GreatVibes-Regular.ttf
echo.
echo Free Music:
echo https://freemusicarchive.org
echo.
echo Free Stock Photos:
echo https://unsplash.com
echo https://pexels.com
echo https://pixabay.com
echo.
echo.

pause
