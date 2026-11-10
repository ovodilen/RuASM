; Conditional control flow with a label on its own line.
entry:
    mov eax, 0
    test eax, eax
    jne nonzero
    mov eax, 1
    ret
nonzero:
    mov eax, 2
    ret
