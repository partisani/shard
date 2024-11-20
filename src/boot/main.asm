format binary as 'bin'
use16

org 0x7c00
    
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    xor ax, ax
    mov ss, ax
    mov sp, 0x7c00

    jmp 0:_start

_start:
    int 0x13                    ; reset disk

    mov ax, 0x07e0
    mov es, ax
    mov bx, 0                   ; extended bootloader will be at es:bx (0x7e00)

    mov ah, 2                   ; read sectors
    mov al, 1                   ; 1 sector (512 bytes)
    mov ch, 0                   ; chs is weird, ignore ch
    mov cl, 2                   ; 2nd sector
    mov dl, 0x80                ; disk number
    mov dh, 0                   ; chs is weird, ignore dh
    int 0x13
    
    jc _err                     ; print 'e' and reset

    jmp main                    ; jump to extended bootloader    
    
_err:
    mov ah, 0x0e
    mov al, 'e'
    mov bh, 0
    int 0x10

    jmp 0x7c00

rb (0x7C00 + 510) - $           ; reserve 512 - (bytes of machine code written)
dw 0xAA55

org 0x7e00

main:
    mov ah, 0x0e
    mov al, 'a'
    mov bh, 0
    int 0x10
    hlt
