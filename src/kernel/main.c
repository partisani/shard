extern void main() {
    char* vram = 0xb8000;
    vram[0] = 'q';
    vram[1] = 0x10;
}
