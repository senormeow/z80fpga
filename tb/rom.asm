    ORG 0000h
start:
    JP begin
    ORG 00A1h
begin:
    LD a, 00CCh
    OUT (0BBH), a
    nop
    nop
    IN a, (00h)