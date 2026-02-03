#!/bin/bash
# Valentine App Asset Setup Script
# Run this script to download fonts, audio, and placeholder images

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Valentine App Asset Setup ===${NC}\n"

# Create directories
mkdir -p assets/fonts assets/audio assets/images

# Download Great Vibes Font
echo -e "${BLUE}1. Downloading Great Vibes Font...${NC}"
if command -v wget &> /dev/null; then
    wget -O assets/fonts/GreatVibes-Regular.ttf \
        "https://github.com/google/fonts/raw/main/ofl/greatvibes/GreatVibes-Regular.ttf" \
        && echo -e "${GREEN}✓ Font downloaded${NC}" \
        || echo -e "${BLUE}ℹ Download failed. Manual download instructions below.${NC}"
elif command -v curl &> /dev/null; then
    curl -L -o assets/fonts/GreatVibes-Regular.ttf \
        "https://github.com/google/fonts/raw/main/ofl/greatvibes/GreatVibes-Regular.ttf" \
        && echo -e "${GREEN}✓ Font downloaded${NC}" \
        || echo -e "${BLUE}ℹ Download failed. Manual download instructions below.${NC}"
else
    echo -e "${BLUE}ℹ wget/curl not found. Manual download required.${NC}"
fi

# Download audio files
echo -e "\n${BLUE}2. Downloading Romantic Background Music...${NC}"

# Home audio (soft romantic instrumental)
if command -v curl &> /dev/null; then
    echo "Searching Free Music Archive for romantic music..."
    # Note: These are example URLs; actual downloads may vary
    echo -e "${BLUE}ℹ Manual download required from Free Music Archive${NC}"
else
    echo -e "${BLUE}ℹ Manual download required.${NC}"
fi

# Create placeholder images
echo -e "\n${BLUE}3. Creating Placeholder Stock Images...${NC}"
python3 << 'EOF' 2>/dev/null || echo "ℹ Placeholder images could not be auto-generated. See manual steps below."
from PIL import Image, ImageDraw
import os

os.makedirs('assets/images', exist_ok=True)

# Create 7 day photos
colors = [
    (220, 20, 60),      # Rose - Crimson
    (255, 105, 180),    # Propose - Hot Pink
    (184, 134, 11),     # Chocolate - Dark Goldenrod
    (147, 112, 219),    # Teddy - Medium Purple
    (255, 20, 147),     # Promise - Deep Pink
    (255, 165, 0),      # Hug - Orange
    (220, 20, 60),      # Kiss - Crimson
]

day_names = ['rose', 'propose', 'chocolate', 'teddy', 'promise', 'hug', 'kiss']

for i, (color, day) in enumerate(zip(colors, day_names), 1):
    img = Image.new('RGB', (400, 300), color)
    draw = ImageDraw.Draw(img)
    draw.text((150, 130), f"Photo {i}\n({day.title()} Day)", fill=(255, 255, 255))
    img.save(f'assets/images/photo{i}.png')
    print(f'✓ Created assets/images/photo{i}.png')

# Create Valentine photos
for i in range(1, 7):
    img = Image.new('RGB', (400, 500), (255, 192, 203))
    draw = ImageDraw.Draw(img)
    draw.text((150, 220), f"Memory {i}\n(Valentine Day)", fill=(255, 255, 255))
    img.save(f'assets/images/valentine_memory{i}.png')
    print(f'✓ Created assets/images/valentine_memory{i}.png')
EOF

if [ -d "assets/images" ] && [ -n "$(ls -A assets/images 2>/dev/null)" ]; then
    echo -e "${GREEN}✓ Placeholder images created${NC}"
else
    echo -e "${BLUE}ℹ Placeholder images could not be created automatically.${NC}"
fi

echo -e "\n${GREEN}Setup complete!${NC}\n"

echo -e "${BLUE}=== MANUAL DOWNLOAD STEPS ===${NC}\n"

echo "1. FONT (Great Vibes)"
echo "   Download from: https://github.com/google/fonts/raw/main/ofl/greatvibes/GreatVibes-Regular.ttf"
echo "   Place at: assets/fonts/GreatVibes-Regular.ttf\n"

echo "2. AUDIO FILES"
echo "   Home Screen Audio:"
echo "     - Search: Free Music Archive → ambient, instrumental, romantic"
echo "     - Download MP3/WAV"
echo "     - Place at: assets/audio/home.wav\n"
echo "   Valentine Day Audio:"
echo "     - Similar romantic instrumental"
echo "     - Place at: assets/audio/valentine.wav\n"

echo "3. IMAGES"
echo "   Day Photos (photo1.png - photo7.png):"
echo "     - Use any stock images (Unsplash, Pexels, Pixabay)"
echo "     - Size: 400x300 recommended"
echo "     - Place at: assets/images/photo{1-7}.png\n"
echo "   Valentine Memories (valentine_memory1.png - valentine_memory6.png):"
echo "     - Your personal photos"
echo "     - Size: 400x500 recommended"
echo "     - Place at: assets/images/valentine_memory{1-6}.png\n"

echo -e "${BLUE}Free Music Archive: https://freemusicarchive.org${NC}"
echo -e "${BLUE}Stock Photos: unsplash.com, pexels.com, pixabay.com${NC}"
