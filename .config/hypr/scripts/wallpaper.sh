#!/bin/bash
# Dependencies: swww
# Cycles through wallpapers in ~/walls sequentially

WALL_DIR="$HOME/walls"
INDEX_FILE="$HOME/.cache/wallindex"

# Check if walls directory exists
if [ ! -d "$WALL_DIR" ]; then
    echo "Error: Directory $WALL_DIR does not exist"
    exit 1
fi

# Find all image files in the walls directory (including subdirectories)
mapfile -t WALLPAPERS < <(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | sort)

# Check if any wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No image files found in $WALL_DIR"
    exit 1
fi

# Read current index, default to 0 if file doesn't exist
if [ -f "$INDEX_FILE" ]; then
    CURRENT_INDEX=$(cat "$INDEX_FILE")
else
    CURRENT_INDEX=0
fi

# Get the next wallpaper
NEXT_WALL="${WALLPAPERS[$CURRENT_INDEX]}"

# Calculate next index (round-robin back to 0 after reaching the end)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# Ensure cache directory exists
if [ ! -d "$(dirname "$INDEX_FILE")" ]; then
    mkdir -p "$(dirname "$INDEX_FILE")"
fi

# Save the next index for the next run
echo "$NEXT_INDEX" > "$INDEX_FILE"

echo "Setting wallpaper [$((CURRENT_INDEX + 1))/${#WALLPAPERS[@]}]: $NEXT_WALL"

# Set wallpaper using hyprpaper
swww img "$NEXT_WALL" --transition-type center --transition-fps 165 --transition-duration 1

# Optional: Reload other applications to apply the new color scheme
# Uncomment the lines below if needed:
# pywalfox update    # Update Firefox with pywalfox

echo "Wallpaper and color scheme updated successfully!"
