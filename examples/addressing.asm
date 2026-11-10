; A base + index*scale + displacement memory form.
VALUE equ 16
entry:
    mov rax, 1
    mov rbx, [rdi+rcx*4+VALUE]
    add rax, rbx
    ret
