gdt:
    .null:
    dq 0

    .code:
    dw 0xffff
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0

    .data:
    dw 0xffff
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0

gdtr:
    dw ($ - gdt - 1)
    dd gdt

code_seg = gdt.code - gdt
data_seg = gdt.data - gdt
    
