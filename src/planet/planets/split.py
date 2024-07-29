# split.py
# Utility to split planet textures into 512x512 chunks for processing and stuff

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the daysant license.
# daysant@proton.me

# USAGE
# python split.py /path/to/image/directory
#
# This will look for an image "source.png" in the directory, and then
# split it into 5ds12x512 chunks indexed by number, saved as e.g. 121.png.
# 
# For STRUGGLE & STARS, make sure it is an appropriate image type (such as a
# heightmap, province map, or terrain map) that measures exactly 8192x4096


import os
import sys
from PIL import Image

def split_image(image_path):
    with Image.open(image_path) as img:
        width, height = img.size
        
        chunk_size = 512
        chunk_count = 1
        
        for y in range(0, height, chunk_size):
            for x in range(0, width, chunk_size):
                box = (x, y, min(x + chunk_size, width), min(y + chunk_size, height))
                
                chunk = img.crop(box)
                
                chunk_filename = f"{chunk_count}.png"
                chunk_path = os.path.join(os.path.dirname(image_path), chunk_filename)
                chunk.save(chunk_path)
                
                chunk_count += 1

                print(f"{chunk_count-1}/128")

def main():
    if len(sys.argv) != 2:
        print("Usage: python split.py /path/to/image/directory")
        sys.exit(1)
    
    image_dir = sys.argv[1]
    source_image = "source.png"
    
    image_path = os.path.join(image_dir, source_image)
    
    if os.path.exists(image_path):
        split_image(image_path)
    else:
        print("source.png not found")

if __name__ == "__main__":
    main()