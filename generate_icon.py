#!/usr/bin/env python3
"""Generate a simple game icon for CatchTheBall."""
import struct
import zlib

def create_png(width, height, pixels):
    """Create a minimal PNG file from pixel data."""
    def png_chunk(chunk_type, data):
        chunk_len = len(data)
        chunk = struct.pack('>I', chunk_len) + chunk_type + data
        crc = zlib.crc32(chunk_type + data) & 0xffffffff
        return chunk + struct.pack('>I', crc)
    
    # PNG signature
    signature = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr = png_chunk(b'IHDR', ihdr_data)
    
    # IDAT chunk (image data)
    raw_data = b''
    for y in range(height):
        raw_data += b'\x00'  # filter type
        for x in range(width):
            raw_data += bytes(pixels[y][x])
    
    compressed = zlib.compress(raw_data, 9)
    idat = png_chunk(b'IDAT', compressed)
    
    # IEND chunk
    iend = png_chunk(b'IEND', b'')
    
    return signature + ihdr + idat + iend

def create_icon():
    size = 192
    pixels = []
    
    for y in range(size):
        row = []
        for x in range(size):
            # Normalized coordinates
            nx = (x - size/2) / (size/2)
            ny = (y - size/2) / (size/2)
            dist = (nx**2 + ny**2) ** 0.5
            
            # Background gradient (dark blue to dark purple)
            if dist > 0.95:
                r, g, b = 20, 20, 40
            else:
                # Background
                r = int(15 + 25 * (1 - dist))
                g = int(15 + 20 * (1 - dist))
                b = int(35 + 45 * (1 - dist))
                
                # Draw paddle at bottom (y=0.65 to 0.75, x=-0.4 to 0.4)
                if 0.60 <= ny <= 0.72 and -0.42 <= nx <= 0.42:
                    r, g, b = 50, 200, 100
                
                # Draw balls
                balls = [
                    (-0.3, -0.4, 0.12, (255, 80, 80)),   # red ball
                    (0.1, -0.15, 0.1, (80, 180, 255)),   # blue ball
                    (0.35, -0.5, 0.08, (255, 200, 50)),  # gold ball
                ]
                
                for bx, by, br, (br_c, bg_c, bb_c) in balls:
                    dx = nx - bx
                    dy = ny - by
                    bd = (dx**2 + dy**2) ** 0.5
                    if bd < br:
                        r, g, b = br_c, bg_c, bb_c
                        # Highlight
                        if bd < br * 0.4 and dx < 0 and dy < 0:
                            r = min(255, r + 80)
                            g = min(255, g + 80)
                            b = min(255, b + 80)
            
            row.append((r, g, b))
        pixels.append(row)
    
    return create_png(size, size, pixels)

if __name__ == '__main__':
    icon_data = create_icon()
    with open('/home/claude/godot-android-game/project/assets/icon.png', 'wb') as f:
        f.write(icon_data)
    print(f"Icon created: {len(icon_data)} bytes")
