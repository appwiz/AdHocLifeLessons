#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw, ImageFont
import sys

def create_quote_icon(size, output_path):
    """Create an app icon with double quotes on white background"""
    
    # Create a white square image
    img = Image.new('RGB', (size, size), 'white')
    draw = ImageDraw.Draw(img)
    
    # Calculate font size based on icon size (roughly 60% of the height)
    font_size = int(size * 0.6)
    
    try:
        # Try to use a nice serif font for the quotes
        font = ImageFont.truetype("/System/Library/Fonts/Times.ttc", font_size)
    except:
        try:
            # Fallback to system font
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
        except:
            # Final fallback to default font
            font = ImageFont.load_default()
    
    # Double quote character
    quote_text = '""'
    
    # Get text bounding box for centering
    bbox = draw.textbbox((0, 0), quote_text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Calculate position to center the text
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    # Draw the quotes in dark gray/black
    draw.text((x, y), quote_text, fill='#333333', font=font)
    
    # Save the image
    img.save(output_path, 'PNG')
    print(f"Created icon: {output_path} ({size}x{size})")

def main():
    # Base path for the app icon set
    icon_path = "/Users/rvd/Work/AdHocLifeLessons/AdHocLifeLessons/Assets.xcassets/AppIcon.appiconset"
    
    # Icon sizes needed based on the Contents.json
    icon_configs = [
        # iOS Universal
        (1024, "AppIcon-1024.png"),
        (1024, "AppIcon-1024-dark.png"),  # Dark appearance
        (1024, "AppIcon-1024-tinted.png"), # Tinted appearance
        
        # macOS
        (16, "AppIcon-16.png"),
        (32, "AppIcon-16@2x.png"),  # 16x16 @2x
        (32, "AppIcon-32.png"),
        (64, "AppIcon-32@2x.png"),  # 32x32 @2x
        (128, "AppIcon-128.png"),
        (256, "AppIcon-128@2x.png"), # 128x128 @2x
        (256, "AppIcon-256.png"),
        (512, "AppIcon-256@2x.png"), # 256x256 @2x
        (512, "AppIcon-512.png"),
        (1024, "AppIcon-512@2x.png"), # 512x512 @2x
    ]
    
    # Create all icon sizes
    for size, filename in icon_configs:
        output_path = os.path.join(icon_path, filename)
        create_quote_icon(size, output_path)
    
    print(f"\nAll {len(icon_configs)} app icons created successfully!")

if __name__ == "__main__":
    main()