format binary as 'bin'
use16

KERNEL_LOCATION = 0x1000

org 0x7c00
    
    mov ax, 0x0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    xor ax, ax
    mov ss, ax
    mov sp, 0x7c00

    push dx

    jmp 0:_start
    
_start:
    mov al, 3                   ; video mode 3
    int 0x10                    ; ah is already 0, switch video mode

    pop dx                      ; restore drive number (dl)
    int 0x13                    ; ah is already 0, reset disk
    push dx                     ; save drive number
    
    mov si, msg.boot
    call _puts

    mov si, kernel_dap          ; kernel disk address packet
    pop dx                      ; restore drive number (dl)
    mov ah, 0x42
    int 0x13                    ; read from disk with lba mode

    mov ah, 1                   ; get status of last disk operation
    int 0x13                    ; basically, only useful in debugger
    
    mov si, msg.disk_read_err
    jc _err
    
    cli                         ; disable interrupts temporarily
    lgdt [gdtr]                 ; load gdt

    mov eax, cr0                ; save cr0
    or eax, 1                   ; enable PE bit
    mov cr0, eax                ; write it back

    in al, 0x92
    or al, 2                    ; i assume wherever you are running this
    out 0x92, al                ; piece of code, has support for FAST A20

    mov ax, data_seg            ; setting registers correctly
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x90000
    mov esp, ebp

    jmp code_seg:KERNEL_LOCATION

_puts:
    mov ah, 0x0e                ; teletype output interrupt code
    lodsb                       ; load byte
    cmp al, 0
    jz .end                     ; if zero, return
    int 0x10                    ; print character
    jmp _puts                   ; loop
    .end: ret
    
_err:
    call _puts
    cli
    hlt

align 4                         ; it needs to be 4 byte aligned
kernel_dap:                     ; DAP = Disk Address Packet
    db 16                       ; packet size
    db 0                        ; padding
    .block_count:
    dw 9                        ; how many blocks to load
    .write_addrs:
    dw KERNEL_LOCATION          ; offset to write blocks to
    dw 0                        ; segment to write blocks to
    .read_from:
    dd 1                        ; start from block #
    dd 0                        ; extra bytes
    
msg:
    .disk_read_err: db "Could not read kernel.", 13, 10, 0
    .boot: db "Initialized.", 13, 10, 0

include "gdt.asm"
        
rb (0x7C00 + 510) - $           ; reserve 512 - (bytes of machine code written)
dw 0xAA55
