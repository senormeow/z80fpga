org 0000h
start:
    JP begin
org 0010h
seek 0010h
begin:
    LD a, 00CCh
    OUT (0BBh), a
    nop
    LD b, 41h
print: 
    LD c, 11h
    OUT (c), b
    LD a, 01h
    OUT (12h), a
loop:
    IN a, (10h)
    cp 01h
    JP z, loop
    inc b
    jp nz, print
    LD a, 00FFh
    OUT (0xFF), a

    org 03FFh
    seek 03FFh
    nop

