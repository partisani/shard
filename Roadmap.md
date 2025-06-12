# Shar/d OS
A modern & experimental operating system inspired by Plan9.
## Why?
Because Plan9, and i want to.

## Architecture
### Bootloader
BOOTBOOT loading a small ramdisk with a format similar to this:
```
     - Magic bytes and padding
0000   0052 414D 0000 0000
     - Bootshard positions
     -
     - Each one is 4 bytes in length and points to
     - a bootshard in the ramdisk. Bootshards are a
     - type of shard that lives in the ramdisk and
     - can be loaded just by a pointer inside the first
     - bytes of the bootimage.
     -
     - There should exist at most 16 of them, from positions
     - 0x8 to 0x48
0008   0000 0048 0000 0096
....   .... .... .... ....
0048 - Bootshards go from here on...
     - Sadly BOOTBOOT still expects the FS driver to use filenames
     - but a number can be used instead.
```
