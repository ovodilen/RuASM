; Typed integer data is emitted little-endian.
header:
    db 0x52, 0x55, 0x41, 0x53
    dw 0x1234
    dd 0x12345678
    dq 0x0123456789abcdef
