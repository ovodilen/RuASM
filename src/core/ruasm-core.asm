get_line:
 mov rbx,ir_active+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,line_source_pointer+IMAGE_VA
 mov [rbx],r12
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 mov rbx,line_source_number+IMAGE_VA
 mov [rbx],rax
 mov rsi,r12
 mov rdi,line_buffer+IMAGE_VA
 xor rcx,rcx
get_line_loop:
 cmp rsi,r13
 je get_line_done
 db 0x0f, 0xb6
 db 0x06                         ; movzx eax,byte [rsi]
 add rsi,1
 cmp rax,10
 je get_line_done
 cmp rax,13
 je get_line_loop
 cmp rax,0
 je syntax_error
 cmp rcx,4095
 je input_error
 db 0xaa                         ; stosb
 add rcx,1
 jmp get_line_loop
get_line_done:
 xor rax,rax
 db 0xaa
 mov r12,rsi
 ret

; IR v2: one immutable 32-bit record per physical source line.
; Bits 0..17: source offset; 18..25: statement kind; 26..31: ISA index.
; The ISA record supplies form/metadata at dispatch; they are not duplicated.
; This keeps the 196607-line maximum within 786428 bytes of statement IR.
build_statement_ir:
 mov rbx,ir_source_base+IMAGE_VA
 mov [rbx],r12
 xor rax,rax
 mov rbx,ir_needs_layout+IMAGE_VA
 mov [rbx],rax
 mov rbx,ir_count+IMAGE_VA
 mov [rbx],rax
 mov rbx,diag_line+IMAGE_VA
 mov [rbx],rax
build_statement_ir_loop:
 cmp r12,r13
 je build_statement_ir_done
 call get_line
 mov rbx,line_source_pointer+IMAGE_VA
 mov rax,[rbx]
 mov rbx,ir_source_base+IMAGE_VA
 mov rcx,[rbx]
 sub rax,rcx
 mov rbx,ir_offset+IMAGE_VA
 mov [rbx],rax
 mov rbx,ir_count+IMAGE_VA
 mov rcx,[rbx]
 db 0x48,0xc1,0xe1,0x02
 mov r8,statement_ir+IMAGE_VA
 add r8,rcx
 mov rsi,line_buffer+IMAGE_VA
 call classify_statement
 mov rdx,rax
 db 0x48,0xc1,0xea,0x08
 db 0x48,0x83,0xe2,0x3f
 db 0x48,0xc1,0xe2,0x1a
 mov rcx,rax
 db 0x48,0x83,0xe1,0xff
 db 0x48,0xc1,0xe1,0x12
 db 0x48,0x09,0xca
 mov rbx,ir_offset+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0x09,0xd0
 db 0x41,0x89,0x00
 mov rbx,ir_count+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp build_statement_ir_loop
build_statement_ir_done:
 mov rbx,ir_source_base+IMAGE_VA
 mov r12,[rbx]
 mov rbx,diag_line+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,ir_cursor+IMAGE_VA
 mov [rbx],rax
 mov rbx,ir_needs_layout+IMAGE_VA
 mov rax,[rbx]
 xor rax,1
 mov [rbp+0],rax
 ret

; Return packed statement metadata in RAX. Kinds: 0 blank/comment, 1 label,
; 2 EQU, 3 data, 4 instruction, 255 unknown (left for normal diagnostics).
; The ISA table owns form metadata.
classify_statement:
 call skip_spaces
 db 0x0f,0xb6,0x06
 cmp rax,0
 je classify_statement_blank
 cmp rax,59
 je classify_statement_blank
 call parse_token
 cmp rax,0
 je classify_statement_blank
 mov r10,rsi
 mov rdx,rax
 mov rsi,token_buffer+IMAGE_VA
 add rsi,rdx
 sub rsi,1
 db 0x0f,0xb6,0x06
 cmp rax,58
 je classify_statement_label
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,lit_equ+IMAGE_VA
 call string_equal
 cmp rax,1
 je classify_statement_unknown
 mov rsi,token_buffer+IMAGE_VA
 db 0x0f,0xb6,0x06
 db 0x48,0x83,0xe0,0x7f
 mov rdx,isa_table+IMAGE_VA+512
 add rdx,rax
 db 0x0f,0xb6,0x02
 mov rbx,isa_table+IMAGE_VA+640
 add rbx,rax
classify_statement_isa_loop:
 db 0x44,0x0f,0xb6,0x1b
 cmp r11,255
 je classify_statement_equ_probe
 mov rax,r11
 db 0x48,0xc1,0xe0,0x03
 mov rdx,isa_table+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x0a
 mov rax,lit_db-1+IMAGE_VA
 add rax,rcx
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,rax
 call string_equal
 cmp rax,1
 je classify_statement_isa_found
 add rbx,1
 jmp classify_statement_isa_loop
classify_statement_isa_found:
 mov rax,r11
 db 0x48,0xc1,0xe0,0x03
 mov rbx,isa_table+IMAGE_VA
 add rbx,rax
 db 0x0f,0xb6,0x4b,0x01
 mov rax,4
 cmp rcx,1
 jne classify_statement_isa_kind_ready
 mov rax,3
classify_statement_isa_kind_ready:
 mov rdx,r11
 db 0x48,0xc1,0xe2,0x08
 db 0x48,0x09,0xd0
 db 0x0f,0xb6,0x53,0x02
 db 0x48,0xc1,0xe2,0x10
 db 0x48,0x09,0xd0
 db 0x0f,0xb6,0x53,0x03
 db 0x48,0xc1,0xe2,0x18
 db 0x48,0x09,0xd0
 ret
classify_statement_equ_probe:
 mov rsi,r10
 call skip_separators
 call parse_token
 cmp rax,0
 je classify_statement_unknown
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,lit_equ+IMAGE_VA
 call string_equal
 cmp rax,1
 jne classify_statement_unknown
 mov rax,1
 mov rbx,ir_needs_layout+IMAGE_VA
 mov [rbx],rax
 mov rax,2
 ret
classify_statement_label:
 mov rax,1
 mov rbx,ir_needs_layout+IMAGE_VA
 mov [rbx],rax
 ret
classify_statement_blank:
 xor rax,rax
 ret
classify_statement_unknown:
 mov rax,255
 ret

; Fetch a source line through its prebuilt IR record. The normal line parser
; still owns operand validation; IR supplies stable boundaries and dispatch.
get_ir_line:
 mov rbx,ir_cursor+IMAGE_VA
 mov rcx,[rbx]
 db 0x48,0xc1,0xe1,0x02
 mov rsi,statement_ir+IMAGE_VA
 add rsi,rcx
 db 0x8b,0x06                  ; load packed dword and zero-extend EAX
 mov rdx,rax
 db 0x48,0xc1,0xea,0x12       ; statement kind = bits 18..25
 db 0x48,0x81,0xe2,0xff,0x00,0x00,0x00
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x1a       ; ISA index = bits 26..31
 db 0x48,0xc1,0xe1,0x08
 db 0x48,0x09,0xca
 mov rbx,ir_current_meta+IMAGE_VA
 mov [rbx],rdx
 db 0x25,0xff,0xff,0x03,0x00 ; source offset = bits 0..17
 mov rbx,ir_source_base+IMAGE_VA
 mov r12,[rbx]
 add r12,rax
 call get_line
 mov rbx,ir_active+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 ret

; Parse one line. Tokens are separated by whitespace and commas.
process_line:
 mov rbx,diag_column+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,diag_code+IMAGE_VA
 mov [rbx],rax
 call skip_spaces
 ; A semicolon in column 1 (after indentation) starts a full-line comment.
 db 0x0f, 0xb6, 0x06
 cmp rax,59
 je process_done
 call parse_token
 cmp rax,0
 je process_done
 mov r8,rsi                    ; pointer after first token
 mov r9,rax                    ; preserve token length
 mov rbx,diag_column+IMAGE_VA
 mov rax,[rbx]
 mov rbx,diag_symbol_column+IMAGE_VA
 mov [rbx],rax
 mov rbx,r9
 ; A token ending in ':' is a label declaration.
 cmp rbx,0
 je process_done
 mov rsi,token_buffer+IMAGE_VA
 add rsi,rbx
 sub rsi,1
 db 0x0f, 0xb6, 0x06
 cmp rax,58
 jne not_label
 xor rax,rax
 db 0x88, 0x06
 call validate_symbol_name
 call define_label
 mov rsi,r8
 call skip_spaces
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 je process_done
 cmp rdx,59
 jne syntax_error
 ret
not_label:
 ; IR statements already carry the ISA record index for normal source passes.
 mov rbx,ir_active+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne isa_lookup
 mov rbx,ir_current_meta+IMAGE_VA
 mov rax,[rbx]
 mov rdx,rax
 db 0x48,0x81,0xe2,0xff,0x00,0x00,0x00
 cmp rdx,2
 je handle_equ
 cmp rdx,3
 je isa_ir_dispatch
 cmp rdx,4
 jne isa_lookup
isa_ir_dispatch:
 mov rdx,rax
 db 0x48,0xc1,0xea,0x08
 db 0x48,0x81,0xe2,0xff,0x00,0x00,0x00
 db 0x48,0xc1,0xe2,0x03
 mov rbx,isa_table+IMAGE_VA
 add rbx,rdx
 jmp isa_dispatch_found
isa_lookup:
 ; Non-IR calls use the same first-byte candidate index as Statement IR.
 mov rsi,token_buffer+IMAGE_VA
 db 0x0f,0xb6,0x06
 db 0x48,0x83,0xe0,0x7f
 mov rdx,isa_table+IMAGE_VA+512
 add rdx,rax
 db 0x0f,0xb6,0x02
 mov rbx,isa_table+IMAGE_VA+640
 add rbx,rax
isa_dispatch_loop:
 db 0x44,0x0f,0xb6,0x1b
 cmp r11,255
 je isa_lookup_setcc
 add rbx,1
 mov rax,r11
 db 0x48,0xc1,0xe0,0x03
 mov rdx,isa_table+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x0a
 mov rax,lit_db-1+IMAGE_VA
 add rax,rcx
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,rax
 call string_equal
 cmp rax,1
 jne isa_dispatch_loop
 mov rbx,rdx
 jmp isa_dispatch_found
; SETcc and CMOVcc share one exact-token matcher with symbol reservation.
isa_lookup_setcc:
 mov rsi,token_buffer+IMAGE_VA
 call isa_match_condition_mnemonic
 cmp rax,1
 jne handle_equ
 mov rbx,op_misc+IMAGE_VA
 mov [rbx+64],rdx
 mov [rbx+88],rcx
 cmp rcx,1
 je handle_cmovcc
 jmp handle_setcc

; Pure matcher: RAX=1 on match, RDX=condition code, RCX=1 for CMOVcc/0 for SETcc.
; No global parser state is changed; the dispatch caller commits the decoded result.
isa_match_condition_mnemonic:
 xor rcx,rcx
 db 0x0f,0xb6,0x06
 cmp rax,99
 je isa_match_cmovcc
 cmp rax,115
 jne isa_match_condition_none
 add rsi,1
 db 0x0f,0xb6,0x06
 cmp rax,101
 jne isa_match_condition_none
 add rsi,1
 db 0x0f,0xb6,0x06
 cmp rax,116
 jne isa_match_condition_none
 add rsi,1
 jmp isa_match_condition_suffix
isa_match_cmovcc:
 db 0x0f,0xb6,0x46,1
 cmp rax,109
 jne isa_match_condition_none
 db 0x0f,0xb6,0x46,2
 cmp rax,111
 jne isa_match_condition_none
 db 0x0f,0xb6,0x46,3
 cmp rax,118
 jne isa_match_condition_none
 add rsi,4
 mov rcx,1
isa_match_condition_suffix:
 mov rbx,condition_suffix_table+IMAGE_VA
isa_match_condition_loop:
 db 0x0f,0xb6,0x03
 db 0x0f,0xb6,0x16
 cmp rax,rdx
 jne isa_match_condition_next
 db 0x0f,0xb6,0x43,1
 db 0x0f,0xb6,0x56,1
 cmp rax,rdx
 jne isa_match_condition_next
 cmp rdx,0
 je isa_match_condition_found
 db 0x0f,0xb6,0x56,2
 cmp rdx,0
 jne isa_match_condition_next
isa_match_condition_found:
 db 0x0f,0xb6,0x43,2
 mov rdx,rax
 mov rax,1
 ret
isa_match_condition_next:
 add rbx,3
 cmp rbx,condition_suffix_table_end+IMAGE_VA
 jne isa_match_condition_loop
isa_match_condition_none:
 xor rax,rax
 ret

isa_dispatch_found:
 db 0x0f                         ; movzx eax,byte [rbx+1]
 db 0xb6, 0x43, 1
 cmp rax,1
 je handle_db
 cmp rax,5
 je handle_mov
 cmp rax,10
 je handle_jmp
 cmp rax,11
 je handle_call
 cmp rax,12
 je handle_je
 cmp rax,13
 je handle_jne
 cmp rax,18
 je handle_test
 cmp rax,39
 je handle_alu
 cmp rax,19
 je handle_lea
 cmp rax,20
 je handle_xchg
 cmp rax,21
 je handle_push
 cmp rax,22
 je handle_pop
 cmp rax,23
 je handle_inc
 cmp rax,24
 je handle_dec
 cmp rax,25
 je handle_not
 cmp rax,26
 je handle_neg
 cmp rax,27
 je handle_isa_fixed
 cmp rax,28
 je handle_shl
 cmp rax,29
 je handle_shr
 cmp rax,30
 je handle_sar
 cmp rax,31
 je handle_rol
 cmp rax,32
 je handle_ror
 cmp rax,33
 je handle_rcl
 cmp rax,34
 je handle_rcr
 cmp rax,35
 je handle_bswap
 cmp rax,36
 je handle_movzx
 cmp rax,37
 je handle_movsx
cmp rax,38
 je handle_muldiv
 cmp rax,40
 je handle_jcc
 cmp rax,41
 je handle_bitops
 jmp handle_equ

; SETcc r/m8. The destination is a low-byte GPR or an inferred byte memory
; location. Condition codes use the architectural 0..15 encoding order.
handle_setcc:
 call parse_one
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,2
 je handle_setcc_register
 cmp rax,3
 je handle_setcc_memory
 jmp syntax_error
handle_setcc_register:
 mov r9,[rbx+8]
 mov rax,r9
 db 0x48,0x83,0xe0,0x0c
 cmp rax,0
 je handle_setcc_opcode
 db 0x48,0xc1,0xe8,3
 add rax,0x40
 call emit_byte
handle_setcc_opcode:
 mov rax,0x0f
 call emit_byte
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+64]
 add rax,0x90
 call emit_byte
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 add rax,0xc0
 call emit_byte
 ret
handle_setcc_memory:
 mov rbx,op1+IMAGE_VA
 xor r9,r9
 mov r10,1
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+64]
 add rax,0x190
 mov r15,rax
 call emit_mem
 ret


; CMOVcc r16/r32/r64, r16/r32/r64 or inferred-width memory.
; The condition suffix is shared with Jcc/SETcc; opcode is 0F 40+cc.
handle_cmovcc:
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je handle_cmovcc_r64
 cmp rax,5
 je handle_cmovcc_r32
 cmp rax,6
 je handle_cmovcc_r16
 jmp syntax_error
handle_cmovcc_r64:
 mov r10,8
 jmp handle_cmovcc_width_ready
handle_cmovcc_r32:
 mov r10,4
 jmp handle_cmovcc_width_ready
handle_cmovcc_r16:
 mov r10,2
handle_cmovcc_width_ready:
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+80],r10
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,3
 je handle_cmovcc_memory
 mov rdx,op1+IMAGE_VA
 mov rdx,[rdx]
 cmp rax,rdx
 jne syntax_error
 mov r10,[rbx+8]
 ; 66 for 16-bit; REX.R selects destination and REX.B selects source.
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+80]
 cmp rax,2
 jne handle_cmovcc_rex
 mov rax,0x66
 call emit_byte
handle_cmovcc_rex:
 mov rax,0x40
 mov rdx,op_misc+IMAGE_VA
 mov rcx,[rdx+80]
 cmp rcx,8
 jne handle_cmovcc_rex_r
 add rax,8
handle_cmovcc_rex_r:
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je handle_cmovcc_rex_b
 add rax,4
handle_cmovcc_rex_b:
 cmp r10,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je handle_cmovcc_rex_emit
 add rax,1
handle_cmovcc_rex_emit:
 cmp rax,0x40
 je handle_cmovcc_opcode
 call emit_byte
handle_cmovcc_opcode:
 mov rax,0x0f
 call emit_byte
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+64]
 add rax,0x40
 call emit_byte
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 db 0x48,0xc1,0xe0,0x03
 mov rcx,r10
 db 0x48,0x83,0xe1,0x07
 add rax,rcx
 add rax,0xc0
 call emit_byte
 ret
handle_cmovcc_memory:
 mov rbx,op2+IMAGE_VA
 mov rdx,op_misc+IMAGE_VA
 mov r10,[rdx+80]
 mov rax,[rdx+64]
 add rax,0x140
 mov r15,rax
 call emit_mem
 ret

handle_jmp:
 xor rax,rax
 db 0x0f,0xb6,0x43,0x04
 mov [rbp+40],rax
 xor rax,rax
 mov [rbp+48],rax
 mov [rbp+56],rax
 xor rax,rax
 db 0x0f,0xb6,0x43,0x05
 mov [rbp+72],rax
 jmp handle_branch
handle_call:
 xor rax,rax
 db 0x0f,0xb6,0x43,0x04
 mov [rbp+40],rax
 xor rax,rax
 mov [rbp+48],rax
 mov [rbp+56],rax
 xor rax,rax
 mov [rbp+72],rax
 jmp handle_branch
handle_je:
 mov rax,0x0f
 mov [rbp+40],rax
 mov rax,0x84
 mov [rbp+48],rax
 mov rax,1
 mov [rbp+56],rax
 mov rax,0x74
 mov [rbp+72],rax
 jmp handle_branch
handle_jne:
 mov rax,0x0f
 mov [rbp+40],rax
 mov rax,0x85
 mov [rbp+48],rax
 mov rax,1
 mov [rbp+56],rax
 mov rax,0x75
 mov [rbp+72],rax
 jmp handle_branch

; All x86 condition codes share one table-described handler.
; Record byte 4 = near opcode's second byte (80..8F), byte 5 = short opcode (70..7F).
handle_jcc:
 mov rax,0x0f
 mov [rbp+40],rax
 mov rax,1
 mov [rbp+56],rax
 db 0x0f,0xb6,0x43,4
 mov [rbp+48],rax
 db 0x0f,0xb6,0x43,5
 mov [rbp+72],rax
 jmp handle_branch

; Exact two-cycle detection for label/EQU layouts. Two compact snapshots hold
; each symbol's value and kind/status (16 bytes per symbol). Branch count and
; output size complete the state; branch maps cannot change without count change
; during resolving scans.
branch_cycle_check:
 mov rbx,branch_short_count+IMAGE_VA
 mov rdx,[rbx]
 cmp rdx,0
 jne branch_cycle_has_short
 mov rbx,branch_cycle_history+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 ret
branch_cycle_has_short:
 mov rbx,branch_cycle_history+IMAGE_VA
 mov rcx,[rbx]
 cmp rcx,0
 je branch_cycle_first
 cmp rcx,1
 je branch_cycle_second
 ; Compare the current complete symbol state with the state two scans ago.
 mov rbx,branch_cycle_size_b+IMAGE_VA
 mov rax,[rbp+8]
 mov rdx,[rbx]
 cmp rax,rdx
 jne branch_cycle_advance
 mov rbx,branch_cycle_short_b+IMAGE_VA
 mov rax,[rbx]
 mov rbx,branch_short_count+IMAGE_VA
 mov rdx,[rbx]
 cmp rax,rdx
 jne branch_cycle_advance
 mov rbx,branch_cycle_count_b+IMAGE_VA
 mov rax,[rbp+16]
 mov rdx,[rbx]
 cmp rax,rdx
 jne branch_cycle_advance
 mov rsi,label_table+IMAGE_VA
 mov rdi,branch_cycle_snapshot_b+IMAGE_VA
 mov rcx,[rbp+16]
branch_cycle_compare_loop:
 cmp rcx,0
 je branch_cycle_detected
 mov rax,[rsi+64]
 mov rdx,[rdi]
 cmp rax,rdx
 jne branch_cycle_advance
 mov rax,[rsi+72]
 mov rdx,[rdi+8]
 cmp rax,rdx
 jne branch_cycle_advance
 add rsi,80
 add rdi,16
 sub rcx,1
 jmp branch_cycle_compare_loop
branch_cycle_detected:
 mov rax,1
 ret
branch_cycle_first:
 ; The first changed scan initializes snapshot A.
 mov rbx,branch_cycle_history+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 mov rsi,label_table+IMAGE_VA
 mov rdi,branch_cycle_snapshot_a+IMAGE_VA
 mov rcx,[rbp+16]
 jmp branch_cycle_save_a_loop
branch_cycle_second:
 ; Shift A to B, then save the current scan in A.
 mov rsi,branch_cycle_snapshot_a+IMAGE_VA
 mov rdi,branch_cycle_snapshot_b+IMAGE_VA
 mov rcx,[rbp+16]
branch_cycle_shift_loop:
 cmp rcx,0
 je branch_cycle_shift_meta
 mov rax,[rsi]
 mov [rdi],rax
 mov rax,[rsi+8]
 mov [rdi+8],rax
 add rsi,16
 add rdi,16
 sub rcx,1
 jmp branch_cycle_shift_loop
branch_cycle_shift_meta:
 mov rbx,branch_cycle_size_a+IMAGE_VA
 mov rax,[rbx]
 mov rbx,branch_cycle_size_b+IMAGE_VA
 mov [rbx],rax
 mov rbx,branch_cycle_short_a+IMAGE_VA
 mov rax,[rbx]
 mov rbx,branch_cycle_short_b+IMAGE_VA
 mov [rbx],rax
 mov rbx,branch_cycle_count_a+IMAGE_VA
 mov rax,[rbx]
 mov rbx,branch_cycle_count_b+IMAGE_VA
 mov [rbx],rax
 mov rbx,branch_cycle_history+IMAGE_VA
 mov rax,2
 mov [rbx],rax
 mov rsi,label_table+IMAGE_VA
 mov rdi,branch_cycle_snapshot_a+IMAGE_VA
 mov rcx,[rbp+16]
branch_cycle_save_a_loop:
 cmp rcx,0
 je branch_cycle_save_a_meta
 mov rax,[rsi+64]
 mov [rdi],rax
 mov rax,[rsi+72]
 mov [rdi+8],rax
 add rsi,80
 add rdi,16
 sub rcx,1
 jmp branch_cycle_save_a_loop
branch_cycle_save_a_meta:
 mov rbx,branch_cycle_size_a+IMAGE_VA
 mov rax,[rbp+8]
 mov [rbx],rax
 mov rbx,branch_short_count+IMAGE_VA
 mov rdx,[rbx]
 mov rbx,branch_cycle_short_a+IMAGE_VA
 mov [rbx],rdx
 mov rbx,branch_cycle_count_a+IMAGE_VA
 mov rax,[rbp+16]
 mov [rbx],rax
 xor rax,rax
 ret
branch_cycle_advance:
 ; Not the same state as two scans ago: roll the snapshots forward.
 mov rsi,branch_cycle_snapshot_a+IMAGE_VA
 mov rdi,branch_cycle_snapshot_b+IMAGE_VA
 mov rcx,[rbp+16]
 jmp branch_cycle_shift_loop

; Beta1 EQU dependency graph. Matrix row = EQU owner, column = referenced EQU.
; Each row has 1024 bits (128 bytes); duplicate references are counted once.
resolve_equ_graph:
 mov rbx,equ_graph_built+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je resolve_equ_graph_evaluate
 call build_equ_graph
 call sort_equ_graph
 mov rbx,equ_graph_built+IMAGE_VA
 mov rax,1
 mov [rbx],rax
resolve_equ_graph_evaluate:
 mov rbx,equ_saved_r12+IMAGE_VA
 mov [rbx],r12
 mov rbx,equ_saved_r14+IMAGE_VA
 mov [rbx],r14
 mov rbx,equ_graph_order_index+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
resolve_equ_graph_eval_loop:
 mov rbx,equ_graph_order_index+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_order_count+IMAGE_VA
 mov rcx,[rdx]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne resolve_equ_graph_eval_done
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x03
 mov rsi,equ_graph_order+IMAGE_VA
 add rsi,rcx
 mov rax,[rsi]
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x03
 mov rsi,equ_line_ptrs+IMAGE_VA
 add rsi,rcx
 mov r12,[rsi]
 mov rsi,equ_line_numbers+IMAGE_VA
 add rsi,rcx
 mov rax,[rsi]
 sub rax,1
 mov rbx,diag_line+IMAGE_VA
 mov [rbx],rax
 call get_line
 mov rsi,line_buffer+IMAGE_VA
 call process_line
 mov rbx,equ_graph_order_index+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp resolve_equ_graph_eval_loop
resolve_equ_graph_eval_done:
 mov rbx,equ_saved_r12+IMAGE_VA
 mov r12,[rbx]
 mov rbx,equ_saved_r14+IMAGE_VA
 mov r14,[rbx]
 ret

; Build the graph by parsing each EQU through the production expression parser.
build_equ_graph:
 mov rbx,equ_saved_r12+IMAGE_VA
 mov [rbx],r12
 mov rbx,equ_saved_r14+IMAGE_VA
 mov [rbx],r14
 mov rbx,equ_graph_index+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
build_equ_graph_find_loop:
 mov rbx,equ_graph_index+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne build_equ_graph_empty
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 cmp rdx,0
 jne build_equ_graph_clear
 mov rbx,equ_graph_index+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp build_equ_graph_find_loop
build_equ_graph_empty:
 mov rbx,equ_graph_order_count+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_graph_capture+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_saved_r12+IMAGE_VA
 mov r12,[rbx]
 mov rbx,equ_saved_r14+IMAGE_VA
 mov r14,[rbx]
 ret
build_equ_graph_clear:
 ; Matrix (0x20000) and edge counts (0x2000) are contiguous.
 mov rdi,equ_graph_bits+IMAGE_VA
 xor rax,rax
 mov rcx,17408
 db 0xf3,0x48,0xab            ; rep stosq, clear 0x22000 bytes
 mov rbx,equ_graph_index+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_graph_capture+IMAGE_VA
 mov rax,1
 mov [rbx],rax
build_equ_graph_loop:
 mov rbx,equ_graph_index+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne build_equ_graph_done
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 cmp rdx,0
 je build_equ_graph_next
 ; Restore the original source line associated with this EQU entry.
 mov rbx,equ_graph_index+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x03
 mov rdx,equ_line_ptrs+IMAGE_VA
 add rdx,rax
 mov r12,[rdx]
 mov rdx,equ_line_numbers+IMAGE_VA
 add rdx,rax
 mov rax,[rdx]
 sub rax,1
 mov rdx,diag_line+IMAGE_VA
 mov [rdx],rax
 call get_line
 mov rsi,line_buffer+IMAGE_VA
 call process_line
build_equ_graph_next:
 mov rbx,equ_graph_index+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp build_equ_graph_loop
build_equ_graph_done:
 mov rbx,equ_graph_capture+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_changed+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_saved_r12+IMAGE_VA
 mov r12,[rbx]
 mov rbx,equ_saved_r14+IMAGE_VA
 mov r14,[rbx]
 ret

; Kahn topological sort. Zero remaining edges means all EQU dependencies resolved.
; Ties are broken by symbol-table index for deterministic order.
sort_equ_graph:
 mov rdi,equ_graph_done+IMAGE_VA
 xor rax,rax
 mov rcx,1024
 db 0xf3,0xaa                  ; rep stosb
 mov rbx,equ_graph_i+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_graph_equ_count+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_graph_order_count+IMAGE_VA
 mov [rbx],rax
sort_equ_init_loop:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne sort_equ_init_done
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x03
 mov rcx,equ_graph_remaining+IMAGE_VA
 add rcx,rax
 cmp rdx,0
 je sort_equ_init_label
 mov rbx,equ_graph_counts+IMAGE_VA
 add rbx,rax
 mov rdx,[rbx]
 mov [rcx],rdx
 mov rbx,equ_graph_equ_count+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp sort_equ_init_next
sort_equ_init_label:
 xor rdx,rdx
 mov [rcx],rdx
sort_equ_init_next:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp sort_equ_init_loop
sort_equ_init_done:
 mov rbx,equ_graph_equ_count+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 je sort_equ_graph_done
sort_equ_outer:
 mov rbx,equ_graph_order_count+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_equ_count+IMAGE_VA
 mov rcx,[rdx]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne sort_equ_graph_done
 mov rbx,equ_graph_found+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_graph_i+IMAGE_VA
 mov [rbx],rax
sort_equ_find_ready:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne sort_equ_check_found
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 cmp rdx,0
 je sort_equ_find_next
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x12
 cmp rdx,0
 jne sort_equ_find_next
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x03
 mov rbx,equ_graph_remaining+IMAGE_VA
 add rbx,rax
 mov rcx,[rbx]
 cmp rcx,0
 jne sort_equ_find_next
 ; Select the lowest-index ready EQU.
 mov rbx,equ_graph_found+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 mov rcx,1
 db 0x88,0x0a              ; mov byte [rdx],cl
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x03
 mov rbx,equ_graph_order_count+IMAGE_VA
 mov rcx,[rbx]
 db 0x48,0xc1,0xe1,0x03
 mov rbx,equ_graph_order+IMAGE_VA
 add rbx,rcx
 mov [rbx],rax
 mov rbx,equ_graph_target+IMAGE_VA
 mov [rbx],rax
 ; Release all owners whose row contains this dependency.
 mov rbx,equ_graph_j+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
sort_equ_release_loop:
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne sort_equ_release_done
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 cmp rdx,0
 je sort_equ_release_next
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x12
 cmp rdx,1
 je sort_equ_release_next
 ; matrix address = owner*128 + (target/64)*8.
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x07
 mov rdx,equ_graph_target+IMAGE_VA
 mov rdx,[rdx]
 mov rcx,rdx
 db 0x48,0xc1,0xe9,0x06,0x48,0xc1,0xe1,0x03
 add rax,rcx
 mov rbx,equ_graph_bits+IMAGE_VA
 add rbx,rax
 mov rcx,rdx
 db 0x48,0x83,0xe1,0x3f
 mov rdx,1
 db 0x48,0xd3,0xe2
 mov rax,[rbx]
 db 0x48,0x85,0xd0
 je sort_equ_release_next
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x03
 mov rbx,equ_graph_remaining+IMAGE_VA
 add rbx,rax
 mov rax,[rbx]
 cmp rax,0
 je sort_equ_release_next
 sub rax,1
 mov [rbx],rax
sort_equ_release_next:
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp sort_equ_release_loop
sort_equ_release_done:
 mov rbx,equ_graph_order_count+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp sort_equ_outer
sort_equ_find_next:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp sort_equ_find_ready
sort_equ_check_found:
 mov rbx,equ_graph_found+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je sort_equ_outer
 jmp find_actual_equ_cycle
sort_equ_graph_done:
 ret

; Follow unresolved edges until a node repeats. This reports an actual cycle
; member even when the first blocked EQU only depends on a cycle.
find_actual_equ_cycle:
 mov rbx,equ_graph_i+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
find_cycle_start:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne equ_cycle_error
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 cmp rdx,0
 je find_cycle_start_next
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x12
 cmp rdx,2
 je find_cycle_report
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 mov rcx,2
 db 0x88,0x0a
 mov rbx,equ_graph_j+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
find_cycle_edge_scan:
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+16]
 cmp rax,rcx
 db 0x0f,0x93,0xc2          ; setae dl
 cmp dl,0
 jne equ_cycle_error
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x06
 mov rcx,rax
 db 0x48,0xc1,0xe1,0x04
 add rdx,rcx
 add rdx,label_table+IMAGE_VA
 mov rdx,[rdx+72]
 cmp rdx,0
 je find_cycle_edge_next
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x12
 cmp rdx,1
 je find_cycle_edge_next
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x07
 mov rdx,equ_graph_j+IMAGE_VA
 mov rdx,[rdx]
 mov rcx,rdx
 db 0x48,0xc1,0xe9,0x06,0x48,0xc1,0xe1,0x03
 add rax,rcx
 mov rbx,equ_graph_bits+IMAGE_VA
 add rbx,rax
 mov rcx,rdx
 db 0x48,0x83,0xe1,0x3f
 mov rdx,1
 db 0x48,0xd3,0xe2
 mov rax,[rbx]
 db 0x48,0x85,0xd0
 je find_cycle_edge_next
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 mov rdx,equ_graph_done+IMAGE_VA
 add rdx,rax
 db 0x0f,0xb6,0x12
 cmp rdx,2
 je find_cycle_repeated
 mov rbx,equ_graph_i+IMAGE_VA
 mov rdx,equ_graph_j+IMAGE_VA
 mov rax,[rdx]
 mov [rbx],rax
 jmp find_cycle_start
find_cycle_repeated:
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 mov rbx,equ_graph_i+IMAGE_VA
 mov [rbx],rax
 jmp find_cycle_report
find_cycle_edge_next:
 mov rbx,equ_graph_j+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp find_cycle_edge_scan
find_cycle_start_next:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp find_cycle_start
find_cycle_report:
 mov rbx,equ_graph_i+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0xc1,0xe0,0x03
 mov rdx,equ_line_numbers+IMAGE_VA
 add rdx,rax
 mov rax,[rdx]
 mov rbx,diag_line+IMAGE_VA
 mov [rbx],rax
 mov rbx,diag_column+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 jmp equ_cycle_error

; JMP/JE/JNE relax monotonically from near to short. CALL remains rel32.
; The one-bit-per-source-line map survives every layout scan.
handle_branch:
 mov rsi,r8
 call skip_separators
 call parse_token
 mov rbx,diag_column+IMAGE_VA
 mov rax,[rbx]
 mov rbx,diag_symbol_column+IMAGE_VA
 mov [rbx],rax
 call skip_spaces
 db 0x0f, 0xb6, 0x06
 cmp rax,0
 je branch_operand_ok
 cmp rax,59
 jne syntax_error
branch_operand_ok:
 mov rax,[rbp+0]
 cmp rax,0
 je branch_emit_near
 mov rsi,token_buffer+IMAGE_VA
 call lookup_label
 mov rbx,diag_symbol_column+IMAGE_VA
 mov rax,[rbx]
 mov rbx,diag_column+IMAGE_VA
 mov [rbx],rax
 mov rax,[rbp+32]
 cmp rax,1
 jne undefined_symbol_error
 mov rax,[rbp+72]
 cmp rax,0
 je branch_emit_near
 ; Locate this source line's relaxation bit: qword index = line / 64.
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 mov rcx,rax
 db 0x48, 0xc1, 0xe8, 0x06
 db 0x48, 0xc1, 0xe0, 0x03
 mov rbx,branch_short_map+IMAGE_VA
 add rbx,rax
 db 0x48, 0x83, 0xe1, 0x3f
 mov rdx,1
 db 0x48, 0xd3, 0xe2
 mov rax,[rbx]
 db 0x48, 0x21, 0xd0            ; and rax,rdx
 cmp rax,0
 jne branch_use_short
 ; A short branch that became invalid after a label-dependent instruction
 ; changed size is permanently demoted to near. This second map is separate.
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 mov rcx,rax
 db 0x48, 0xc1, 0xe8, 0x06
 db 0x48, 0xc1, 0xe0, 0x03
 mov rbx,branch_forced_map+IMAGE_VA
 add rbx,rax
 db 0x48, 0x83, 0xe1, 0x3f
 mov rdx,1
 db 0x48, 0xd3, 0xe2
 mov rax,[rbx]
 db 0x48, 0x21, 0xd0            ; and rax,rdx
 cmp rax,0
 jne branch_emit_near
 ; New candidates are considered only during the resolve/layout pass.
 mov rax,[rbp+0]
 cmp rax,2
 jne branch_emit_near
 ; For a forward target, use the current near-sized next IP. Shrinking this
 ; branch shifts target and next IP equally; later shrinks only help.
 ; For a backward target, the label already has this pass's updated address.
 mov rax,[rbp+24]
 mov rbx,[rbp+8]
 cmp rax,rbx
 db 0x0f, 0x97, 0xc1            ; seta cl: target is forward
 db 0x0f, 0xb6, 0xc9            ; movzx ecx,cl
 cmp rcx,1
 je branch_candidate_forward
 add rbx,2
 sub rax,rbx
 jmp branch_candidate_range
branch_candidate_forward:
 mov rdx,[rbp+56]
 add rdx,5
 add rbx,rdx
 sub rax,rbx
 ; The target address is from the previous scan. Correct for branch
 ; bytes already removed earlier in this scan.
 mov rbx,branch_layout_shrink+IMAGE_VA
 mov rdx,[rbx]
 sub rax,rdx
branch_candidate_range:
 mov [rbp+64],rax
 mov rbx,ir_offset+IMAGE_VA
 mov rdx,[rbx]
 add rdx,1
 mov [rbx],rdx
 mov rcx,rax
 db 0x48, 0x0f, 0xbe, 0xc9    ; movsx rcx,cl
 cmp rax,rcx
 jne branch_emit_near
 mov rbx,ir_offset+IMAGE_VA
 mov rdx,[rbx]
 sub rdx,1
 mov [rbx],rdx
 ; Commit this branch as short and force another layout scan.
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 mov rcx,rax
 db 0x48, 0xc1, 0xe8, 0x06
 db 0x48, 0xc1, 0xe0, 0x03
 mov rbx,branch_short_map+IMAGE_VA
 add rbx,rax
 db 0x48, 0x83, 0xe1, 0x3f
 mov rdx,1
 db 0x48, 0xd3, 0xe2
 mov rax,[rbx]
 db 0x48, 0x09, 0xd0            ; or rax,rdx
 mov [rbx],rax
 ; Record the near-to-short size reduction for later forward targets.
 mov rbx,branch_layout_shrink+IMAGE_VA
 mov rax,[rbx]
 mov rcx,[rbp+56]
 add rcx,3
 add rax,rcx
 mov [rbx],rax
 mov rbx,equ_changed+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 mov rbx,branch_short_count+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp branch_use_short
branch_use_short:
 ; During layout scans, displacement contents are irrelevant; only size matters.
 ; The final pass validates and emits the signed rel8 displacement.
 mov rax,[rbp+0]
 cmp rax,1
 jne branch_short_measure
 mov rax,[rbp+24]
 mov rbx,[rbp+8]
 add rbx,2
 sub rax,rbx
 mov [rbp+64],rax
 mov rcx,rax
 db 0x48, 0x0f, 0xbe, 0xc9    ; movsx rcx,cl
 cmp rax,rcx
 jne branch_demote_near
 jmp branch_short_emit
branch_short_measure:
 xor rax,rax
 mov [rbp+64],rax
branch_short_emit:
 mov rax,[rbp+72]
 call emit_byte
 mov rax,[rbp+64]
 call emit_byte
 ret
branch_demote_near:
 ; The final pass found a rel8 that no longer fits after other layout sizes
 ; stabilized. Mark this line forced-near, remove its short bit, and restart.
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 mov rcx,rax
 db 0x48, 0xc1, 0xe8, 0x06
 db 0x48, 0xc1, 0xe0, 0x03
 mov rbx,branch_forced_map+IMAGE_VA
 add rbx,rax
 db 0x48, 0x83, 0xe1, 0x3f
 mov rdx,1
 db 0x48, 0xd3, 0xe2
 mov rax,[rbx]
 db 0x48, 0x09, 0xd0            ; or rax,rdx
 mov [rbx],rax
 ; Clear the corresponding short bit.
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 mov rcx,rax
 db 0x48, 0xc1, 0xe8, 0x06
 db 0x48, 0xc1, 0xe0, 0x03
 mov rbx,branch_short_map+IMAGE_VA
 add rbx,rax
 db 0x48, 0x83, 0xe1, 0x3f
 mov rdx,1
 db 0x48, 0xd3, 0xe2
 db 0x48, 0xf7, 0xd2            ; not rdx
 mov rax,[rbx]
 db 0x48, 0x21, 0xd0            ; and rax,rdx
 mov [rbx],rax
 mov rbx,branch_short_count+IMAGE_VA
 mov rax,[rbx]
 sub rax,1
 mov [rbx],rax
 ; Restart layout mode. The forced-near bit prevents this branch oscillating.
 mov rbx,equ_changed+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 ; process_line was entered with one outstanding CALL return address.
 ; This path restarts main_loop directly, so discard that frame first.
 add rsp,8
 mov rax,2
 mov [rbp+0],rax
 xor rax,rax
 mov [rbp+8],rax
 mov rbx,diag_line+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_source+IMAGE_VA
 mov r12,[rbx]
 mov r14,output_buffer+IMAGE_VA
 jmp main_loop
branch_emit_near:
 mov rax,[rbp+40]
 call emit_byte
 mov rax,[rbp+56]
 cmp rax,0
 je branch_prefix_ready
 mov rax,[rbp+48]
 call emit_byte
branch_prefix_ready:
 mov rax,[rbp+0]
 cmp rax,0
 je branch_zero_disp
 mov rax,[rbp+24]
 mov rbx,[rbp+8]
 add rbx,4
 sub rax,rbx
 mov [rbp+64],rax
 jmp branch_disp_loop_init
branch_zero_disp:
 xor rax,rax
 mov [rbp+64],rax
branch_disp_loop_init:
 mov r11,4
branch_disp_loop:
 mov rax,[rbp+64]
 call emit_byte
 mov rax,[rbp+64]
 db 0x48, 0xc1, 0xe8, 0x08
 mov [rbp+64],rax
 sub r11,1
 cmp r11,0
 jne branch_disp_loop
 ret

; Declarative fixed-opcode forms use the current ISA record in RBX.
; Record: name offset, handler ID, form ID, metadata byte, opcode[0], opcode[1].
; For instruction records, metadata byte is opcode length. For data records DB/DW/DD/DQ,
; handler 1 + form 0 selects the shared data handler and metadata byte is element width.
; Form 1 is a zero-operand instruction with a fixed 1- or 2-byte opcode.
handle_isa_fixed:
 mov rsi,r8
 call skip_spaces
 db 0x0f, 0xb6, 0x16             ; movzx edx,byte [rsi]
 cmp rdx,0
 je handle_isa_fixed_arity_ok
 cmp rdx,59
 jne syntax_error
handle_isa_fixed_arity_ok:
 db 0x0f, 0xb6, 0x43, 3          ; movzx eax,byte [rbx+3]
 cmp rax,1
 je handle_isa_fixed_one_byte
 cmp rax,2
 jne syntax_error
 db 0x0f, 0xb6, 0x43, 4          ; movzx eax,byte [rbx+4]
 call emit_byte
 db 0x0f, 0xb6, 0x43, 5          ; movzx eax,byte [rbx+5]
 call emit_byte
 ret
handle_isa_fixed_one_byte:
 db 0x0f, 0xb6, 0x43, 4          ; movzx eax,byte [rbx+4]
 call emit_byte
 ret

; --- one-operand validation ---
parse_one:
 mov rdi,op1+IMAGE_VA
 call parse_operand
 mov rsi,r8
 call skip_spaces
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 je parse_one_ok
 cmp rdx,59
 jne syntax_error
parse_one_ok:
 ret

; --- PUSH/POP register and immediate forms ---
; Register opcode bases are declared in isa_table (form 2).
handle_push:
 db 0x0f, 0xb6, 0x43, 4
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+56],rax
 call parse_one
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je push_register
 cmp rax,4
 je push_immediate
 jmp syntax_error
push_register:
 mov r9,[rbx+8]
 jmp emit_isa_opcode_plus_register
push_immediate:
 mov r15,[rbx+16]
 mov rax,r15
 add rax,128
 db 0x48, 0xc1, 0xe8, 0x08
 cmp rax,0
 jne push_imm32_check
 mov rax,0x6a
 call emit_byte
 mov rax,r15
 call emit_byte
 ret
push_imm32_check:
 mov rax,r15
 mov rcx,0x80000000
 add rax,rcx
 db 0x48, 0xc1, 0xe8, 0x20
 cmp rax,0
 jne syntax_error
 mov rax,0x68
 call emit_byte
 mov rbx,r15
 mov r11,4
 call emit_le
 ret

handle_pop:
 db 0x0f, 0xb6, 0x43, 4
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+56],rax
 call parse_one
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne syntax_error
 mov r9,[rbx+8]
 jmp emit_isa_opcode_plus_register

; R9=register index, op_misc+56=table-declared opcode base.
emit_isa_opcode_plus_register:
 mov rax,r9
 cmp rax,8
 db 0x0f, 0x92, 0xc1
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je emit_isa_opcode_reg_low
 mov rax,0x41
 call emit_byte
emit_isa_opcode_reg_low:
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+56]
 mov rcx,r9
 db 0x48, 0x83, 0xe1, 0x07
 add rax,rcx
 call emit_byte
 ret

; --- BSWAP r32/r64 ---
handle_bswap:
 call parse_one
 mov rbx,op1+IMAGE_VA
 mov rdx,[rbx]
 mov r9,[rbx+8]
 cmp rdx,1
 je bswap_width_valid
 cmp rdx,5
 jne syntax_error
bswap_width_valid:
 mov rax,0x40
 mov rcx,0x48
 cmp rdx,1
 db 0x48,0x0f,0x44,0xc1
 xor rcx,rcx
 cmp r9,8
 db 0x0f,0x93,0xc1
 add rax,rcx
 cmp rax,0x40
 je bswap_opcode
 call emit_byte
bswap_opcode:
 mov rax,0x0f
 call emit_byte
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 add rax,0xc8
 call emit_byte
 ret

; --- MOVZX/MOVSX r16/r32/r64, r/m8 ---
handle_movzx:
 mov rax,0xb6
 jmp handle_extend_byte_save
handle_movsx:
 mov rax,0xbe
handle_extend_byte_save:
 mov rbx,op_misc+IMAGE_VA
 mov [rbx+56],rax
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rdx,[rbx]
 mov r9,[rbx+8]
 cmp rdx,1
 db 0x0f,0x94,0xc1
 cmp rdx,5
 db 0x0f,0x94,0xc0
 db 0x08,0xc1
 cmp rdx,6
 db 0x0f,0x94,0xc0
 db 0x08,0xc1
 cmp cl,1
 jne syntax_error
 mov r10,2
 mov rcx,4
 cmp rdx,5
 db 0x4c,0x0f,0x44,0xd1
 mov rcx,8
 cmp rdx,1
 db 0x4c,0x0f,0x44,0xd1
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+72],r10
 mov rdx,op_misc+IMAGE_VA
 mov r10,[rdx+72]
 mov r15,[rdx+56]
 add r15,0x100
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,3
 je emit_mem
 cmp rax,2
 jne syntax_error
 mov r10,[rbx+8]
 mov rdx,op_misc+IMAGE_VA
 mov rcx,[rdx+72]
 cmp rcx,2
 jne extend_rex_start
 mov rax,0x66
 call emit_byte
extend_rex_start:
 mov rax,0x40
 mov rdx,op_misc+IMAGE_VA
 mov rcx,[rdx+72]
 cmp rcx,8
 mov rcx,0x48
 db 0x48,0x0f,0x44,0xc1
 xor rcx,rcx
 cmp r9,8
 db 0x0f,0x93,0xc1
 db 0x48,0xc1,0xe1,0x02
 add rax,rcx
 xor rcx,rcx
 cmp r10,8
 db 0x0f,0x93,0xc1
 add rax,rcx
 xor r11,r11
 cmp r10,4
 db 0x41,0x0f,0x93,0xc3
 xor rdx,rdx
 cmp r10,8
 db 0x0f,0x92,0xc2
 db 0x41,0x20,0xd3
 mov rdx,rax
 xor rcx,rcx
 cmp rax,0x40
 db 0x0f,0x95,0xc1
 db 0x44,0x08,0xd9
 cmp cl,1
 jne extend_register_opcode
 mov rax,rdx
 call emit_byte
extend_register_opcode:
 mov rax,0x0f
 call emit_byte
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+56]
 call emit_byte
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 db 0x48,0xc1,0xe0,0x03
 mov rcx,r10
 db 0x48,0x83,0xe1,0x07
 add rax,rcx
 add rax,0xc0
 call emit_byte
 ret
 ; --- BT/BTS/BTR/BTC: matching-width GPR pairs, inferred memory or register imm8 ---
; Descriptor byte 4 is the 0F A3/AB/B3/BB register-index opcode;
; descriptor byte 5 is the Group-8 extension used by 0F BA /4..7 ib.
; Memory width is inferred from the bit-index register. LOCK and memory+imm8
; are deliberately outside this release contract.
handle_bitops:
 db 0x0f,0xb6,0x43,4
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+88],rax
 db 0x0f,0xb6,0x43,5
 mov [rdx+96],rax
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,3
 je bitops_memory
 call bitops_width
 mov rbx,op_misc+IMAGE_VA
 mov [rbx+80],r10
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,4
 je bitops_immediate
 mov rdx,op1+IMAGE_VA
 mov rcx,[rdx]
 cmp rax,rcx
 jne syntax_error
 mov r9,[rdx+8]
 mov r10,[rbx+8]
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+88]
 add rax,0x100
 mov r15,rax
 jmp emit_rr_width
bitops_memory:
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 call bitops_width
 mov r9,[rbx+8]
 mov rbx,op1+IMAGE_VA
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+88]
 add rax,0x100
 mov r15,rax
 jmp emit_mem
bitops_width:
 mov r10,8
 cmp rax,1
 je bitops_width_ok
 mov r10,4
 cmp rax,5
 je bitops_width_ok
 mov r10,2
 cmp rax,6
 jne syntax_error
bitops_width_ok:
 ret
bitops_immediate:
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48,0xc1,0xe8,0x08
 cmp rax,0
 jne range_error
 mov rbx,op_misc+IMAGE_VA
 mov [rbx+112],r15
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rdx,op_misc+IMAGE_VA
 mov r10,[rdx+80]
 cmp r10,2
 jne bitops_imm_rex
 mov rax,0x66
 call emit_byte
bitops_imm_rex:
 mov r11,0x40
 cmp r10,8
 jne bitops_imm_reg
 add r11,8
bitops_imm_reg:
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je bitops_imm_rex_ready
 add r11,1
bitops_imm_rex_ready:
 cmp r11,0x40
 je bitops_imm_opcode
 mov rax,r11
 call emit_byte
bitops_imm_opcode:
 mov rax,0x0f
 call emit_byte
 mov rax,0xba
 call emit_byte
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+96]
 db 0x48,0xc1,0xe0,0x03
 mov rcx,r9
 db 0x48,0x83,0xe1,0x07
 add rax,rcx
 add rax,0xc0
 call emit_byte
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+112]
 call emit_byte
 ret

; --- MUL/IMUL/DIV/IDIV: one register operand (r64 or low r8) ---
; The current ISA record supplies opcode base F6 and Group-3 extension 4..7.
; r64 uses REX.W + F7; low-byte registers use F6 without REX.
handle_muldiv:
 db 0x0f, 0xb6, 0x43, 4          ; movzx eax,byte [rbx+4] opcode base
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+56],rax
 db 0x0f, 0xb6, 0x43, 5          ; movzx eax,byte [rbx+5] group extension
 mov [rdx+64],rax
 call parse_one
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je muldiv_r64
 cmp rax,2
 je muldiv_r8
 jmp syntax_error
muldiv_r64:
 mov r9,[rbx+8]
 mov rax,0x48
 cmp r9,8
 db 0x0f, 0x92, 0xc1
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je muldiv_rex_ready
 add rax,1
muldiv_rex_ready:
 call emit_byte
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+56]
 add rax,1                      ; F6 -> F7 for 64-bit operand
 call emit_byte
 jmp muldiv_modrm
muldiv_r8:
 mov r9,[rbx+8]
 mov rax,0x40
 cmp r9,8
 db 0x0f,0x92,0xc1
 cmp cl,1
 je muldiv_r8_force_check
 add rax,1
muldiv_r8_force_check:
 cmp rax,0x40
 jne muldiv_r8_emit_rex
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je muldiv_r8_opcode
muldiv_r8_emit_rex:
 call emit_byte
muldiv_r8_opcode:
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+56]
 call emit_byte
 jmp muldiv_modrm
muldiv_modrm:
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+64]
 db 0x48, 0xc1, 0xe0, 0x03      ; group extension -> ModR/M reg field
 mov rcx,r9
 db 0x48, 0x83, 0xe1, 0x07      ; register low three bits
 add rax,rcx
 add rax,0xc0
 call emit_byte
 ret

; --- SHL/SHR/SAR and ROL/ROR/RCL/RCR: r64/r8 with imm8 or CL ---
handle_rol:
 mov rax,0
 jmp handle_shift
handle_ror:
 mov rax,1
 jmp handle_shift
handle_rcl:
 mov rax,2
 jmp handle_shift
handle_rcr:
 mov rax,3
 jmp handle_shift
handle_shl:
 mov rax,4
 jmp handle_shift
handle_shr:
 mov rax,5
 jmp handle_shift
handle_sar:
 mov rax,7
handle_shift:
 mov rbx,op_misc+IMAGE_VA
 mov [rbx+8],rax
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je shift_dst_r64
 cmp rax,2
 je shift_dst_r8
 jmp syntax_error
shift_dst_r64:
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,4
 je shift_r64_imm
 cmp rax,2
 je shift_r64_cl
 jmp syntax_error
shift_dst_r8:
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,4
 je shift_r8_imm
 cmp rax,2
 je shift_r8_cl
 jmp syntax_error

shift_r64_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48, 0xc1, 0xe8, 0x08
 cmp rax,0
 jne syntax_error
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x48
 cmp r9,8
 db 0x0f, 0x92, 0xc1
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je shift_r64_imm_rex_ready
 add rax,1
shift_r64_imm_rex_ready:
 call emit_byte
 mov rax,0xc1
 cmp r15,1
 jne shift_r64_imm_opcode_ready
 mov rax,0xd1
shift_r64_imm_opcode_ready:
 call emit_byte
 jmp shift_r64_modrm
shift_r64_cl:
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx+8]
 cmp rax,1
 jne syntax_error
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x48
 cmp r9,8
 db 0x0f, 0x92, 0xc1
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je shift_r64_cl_rex_ready
 add rax,1
shift_r64_cl_rex_ready:
 call emit_byte
 mov rax,0xd3
 call emit_byte
 jmp shift_r64_modrm
shift_r64_modrm:
 mov rbx,op_misc+IMAGE_VA
 mov rdx,[rbx+8]
 db 0x48, 0xc1, 0xe2, 0x03
 mov rax,r9
 db 0x48, 0x83, 0xe0, 0x07
 add rax,rdx
 add rax,0xc0
 call emit_byte
 ; Immediate value 1 is encoded by D1 and has no trailing byte.
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,4
 jne shift_done
 cmp r15,1
 je shift_done
 mov rax,r15
 call emit_byte
 ret

shift_r8_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48, 0xc1, 0xe8, 0x08
 cmp rax,0
 jne syntax_error
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x40
 cmp r9,8
 db 0x0f,0x92,0xc1
 cmp cl,1
 je shift_r8_imm_force_check
 add rax,1
shift_r8_imm_force_check:
 cmp rax,0x40
 jne shift_r8_imm_emit_rex
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je shift_r8_imm_opcode
shift_r8_imm_emit_rex:
 call emit_byte
shift_r8_imm_opcode:
 mov rax,0xc0
 cmp r15,1
 jne shift_r8_imm_opcode_ready
 mov rax,0xd0
shift_r8_imm_opcode_ready:
 call emit_byte
 jmp shift_r8_modrm
shift_r8_cl:
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx+8]
 cmp rax,1
 jne syntax_error
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x40
 cmp r9,8
 db 0x0f,0x92,0xc1
 cmp cl,1
 je shift_r8_cl_force_check
 add rax,1
shift_r8_cl_force_check:
 cmp rax,0x40
 jne shift_r8_cl_emit_rex
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je shift_r8_cl_opcode
shift_r8_cl_emit_rex:
 call emit_byte
shift_r8_cl_opcode:
 mov rax,0xd2
 call emit_byte
shift_r8_modrm:
 mov rbx,op_misc+IMAGE_VA
 mov rdx,[rbx+8]
 db 0x48, 0xc1, 0xe2, 0x03
 mov rax,r9
 db 0x48, 0x83, 0xe0, 0x07
 add rax,rdx
 add rax,0xc0
 call emit_byte
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,4
 jne shift_done
 cmp r15,1
 je shift_done
 mov rax,r15
 call emit_byte
shift_done:
 ret

; --- LEA and XCHG ---
handle_lea:
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 mov r9,[rbx+8]
 cmp rax,1
 je lea_width64
 cmp rax,5
 je lea_width32
 cmp rax,6
 je lea_width16
 jmp syntax_error
lea_width64:
 mov r10,8
 jmp lea_memory
lea_width32:
 mov r10,4
 jmp lea_memory
lea_width16:
 mov r10,2
lea_memory:
 mov rbx,op2+IMAGE_VA
 mov rax,[rbx]
 cmp rax,3
 jne syntax_error
 mov r15,0x8d
 jmp emit_mem

handle_xchg:
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 mov rbx,op2+IMAGE_VA
 mov rdx,[rbx]
 cmp rax,1
 jne xchg_non64
 cmp rdx,1
 jne syntax_error
 mov r15,0x87
 jmp emit_rr
xchg_non64:
 cmp rax,5
 je xchg_width32
 cmp rax,6
 je xchg_width16
 jmp syntax_error
xchg_width32:
 cmp rdx,5
 jne syntax_error
 mov rbx,op_misc+IMAGE_VA
 mov rax,4
 mov [rbx+80],rax
 jmp xchg_width_emit
xchg_width16:
 cmp rdx,6
 jne syntax_error
 mov rbx,op_misc+IMAGE_VA
 mov rax,2
 mov [rbx+80],rax
xchg_width_emit:
 mov r15,0x87
 jmp emit_rr_width

; --- unary register operations: r8/r16/r32/r64 ---
handle_inc:
 mov rax,0xfe
 mov rdx,0
 jmp handle_unary_gpr
handle_dec:
 mov rax,0xfe
 mov rdx,1
 jmp handle_unary_gpr
handle_not:
 mov rax,0xf6
 mov rdx,2
 jmp handle_unary_gpr
handle_neg:
 mov rax,0xf6
 mov rdx,3
handle_unary_gpr:
 mov rbx,op_misc+IMAGE_VA
 mov [rbx],rax
 mov [rbx+8],rdx
 call parse_one
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je unary_gpr_r64
 cmp rax,2
 je unary_gpr_r8
 cmp rax,5
 je unary_gpr_r32
 cmp rax,6
 jne syntax_error
 mov r10,2
 jmp unary_gpr_ready
unary_gpr_r64:
 mov r10,8
 jmp unary_gpr_ready
unary_gpr_r8:
 mov r10,1
 jmp unary_gpr_ready
unary_gpr_r32:
 mov r10,4
unary_gpr_ready:
 mov r9,[rbx+8]
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx]
 cmp r10,1
 je unary_gpr_opcode_ready
 add rax,1
unary_gpr_opcode_ready:
 mov [rbx],rax
 cmp r10,2
 jne unary_gpr_rex
 mov rax,0x66
 call emit_byte
unary_gpr_rex:
 mov rax,0x40
 cmp r10,8
 jne unary_gpr_rex_b
 add rax,8
unary_gpr_rex_b:
 mov rdx,r9
 db 0x48,0x83,0xe2,0x08
 cmp rdx,0
 je unary_gpr_rex_no_b
 add rax,1
unary_gpr_rex_no_b:
 cmp rax,0x40
 jne unary_gpr_emit_rex
 cmp r10,1
 jne unary_gpr_opcode
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je unary_gpr_opcode
 mov rax,0x40
 call emit_byte
 jmp unary_gpr_opcode
unary_gpr_emit_rex:
 call emit_byte
unary_gpr_opcode:
 mov rax,[rbx]
 call emit_byte
 mov rax,[rbx+8]
 db 0x48,0xc1,0xe0,0x03
 add rax,0xc0
 mov rdx,r9
 db 0x48,0x83,0xe2,0x07
 add rax,rdx
 call emit_byte
 ret

; Emit declarative records from the same table used by parser dispatch.
; Alpha6 vertical slice: zero-operand and register-opcode forms are table-driven.
; cli_write_stdout is supplied by the Linux/Windows host suffix.
cli_emit_isa_model:
 mov rbx,isa_table+IMAGE_VA
 xor r12,r12
cli_isa_model_loop:
 db 0x0f, 0xb6, 0x03             ; movzx eax,byte [rbx]
 cmp rax,0
 je cli_isa_model_done
 db 0x0f, 0xb6, 0x43, 2          ; movzx eax,byte [rbx+2] form_id
 cmp rax,1
 je cli_isa_model_include
 cmp rax,2
 je cli_isa_model_include
 cmp rax,3
 je cli_isa_model_include
 cmp rax,4
 je cli_isa_model_include
 cmp rax,5
 je cli_isa_model_include
 cmp rax,6
 je cli_isa_model_include
 cmp rax,7
 jne cli_isa_model_next
cli_isa_model_include:
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+64],rax
 cmp r12,0
 je cli_isa_model_no_comma
 mov rsi,msg_json_comma+IMAGE_VA
 mov rdx,1
 call cli_write_stdout
cli_isa_model_no_comma:
 mov rsi,msg_isa_record_open+IMAGE_VA
 mov rdx,msg_isa_record_open_end-msg_isa_record_open
 call cli_write_stdout
 mov rax,lit_db-1+IMAGE_VA
 db 0x0f, 0xb6, 0x0b             ; movzx ecx,byte [rbx]
 add rax,rcx
 mov r13,rax
 mov rsi,r13
 xor rdx,rdx
cli_isa_model_name_length:
 db 0x0f, 0xb6, 0x06
 cmp rax,0
 je cli_isa_model_name_ready
 add rsi,1
 add rdx,1
 jmp cli_isa_model_name_length
cli_isa_model_name_ready:
 mov rsi,r13
 call cli_write_stdout
 mov rdx,op_misc+IMAGE_VA
 mov rax,[rdx+64]
 cmp rax,2
 je cli_isa_model_middle_r64
 cmp rax,3
 je cli_isa_model_middle_alu
 cmp rax,4
 je cli_isa_model_middle_test
 cmp rax,5
 je cli_isa_model_middle_branch
 cmp rax,6
 je cli_isa_model_middle_group3
 cmp rax,7
 je cli_isa_model_middle_call
 mov rsi,msg_isa_record_middle_none+IMAGE_VA
 mov rdx,msg_isa_record_middle_none_end-msg_isa_record_middle_none
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_r64:
 mov rsi,msg_isa_record_middle_r64+IMAGE_VA
 mov rdx,msg_isa_record_middle_r64_end-msg_isa_record_middle_r64
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_alu:
 mov rsi,msg_isa_record_middle_alu+IMAGE_VA
 mov rdx,msg_isa_record_middle_alu_end-msg_isa_record_middle_alu
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_test:
 mov rsi,msg_isa_record_middle_test+IMAGE_VA
 mov rdx,msg_isa_record_middle_test_end-msg_isa_record_middle_test
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_branch:
 db 0x0f,0xb6,0x43,0x01
 cmp rax,10
 je cli_isa_model_middle_jmp
 mov rsi,msg_isa_record_middle_jcc+IMAGE_VA
 mov rdx,msg_isa_record_middle_jcc_end-msg_isa_record_middle_jcc
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_jmp:
 mov rsi,msg_isa_record_middle_jmp+IMAGE_VA
 mov rdx,msg_isa_record_middle_jmp_end-msg_isa_record_middle_jmp
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_call:
 mov rsi,msg_isa_record_middle_call+IMAGE_VA
 mov rdx,msg_isa_record_middle_call_end-msg_isa_record_middle_call
 call cli_write_stdout
 jmp cli_isa_model_middle_done
cli_isa_model_middle_group3:
 mov rsi,msg_isa_record_middle_group3+IMAGE_VA
 mov rdx,msg_isa_record_middle_group3_end-msg_isa_record_middle_group3
 call cli_write_stdout
cli_isa_model_middle_done:
 db 0x0f, 0xb6, 0x73, 3          ; movzx esi,byte [rbx+3] opcode length
 mov r14,rsi
 xor r15,r15
cli_isa_model_hex_loop:
 cmp r15,r14
 je cli_isa_model_record_done
 mov rsi,rbx
 add rsi,4
 add rsi,r15
 db 0x0f, 0xb6, 0x06             ; movzx eax,byte [rsi]
 mov rcx,rax
 db 0x48, 0xc1, 0xe9, 4          ; shr rcx,4
 db 0x48, 0x83, 0xe1, 0x0f          ; and rcx,15
 mov rsi,lit_hex_digits+IMAGE_VA
 add rsi,rcx
 mov rdx,1
 call cli_write_stdout
 mov rsi,rbx
 add rsi,4
 add rsi,r15
 db 0x0f, 0xb6, 0x06
 mov rcx,rax
 db 0x48, 0x83, 0xe1, 0x0f          ; and rcx,15
 mov rsi,lit_hex_digits+IMAGE_VA
 add rsi,rcx
 mov rdx,1
 call cli_write_stdout
 add r15,1
 jmp cli_isa_model_hex_loop
cli_isa_model_record_done:
 mov rsi,msg_isa_record_close_prefix+IMAGE_VA
 mov rdx,msg_isa_record_close_prefix_end-msg_isa_record_close_prefix
 call cli_write_stdout
 db 0x0f,0xb6,0x43,0x06
 add rax,48
 mov rdx,op_misc+IMAGE_VA
 db 0x88,0x42,0x58
 mov rsi,rdx
 add rsi,88
 mov rdx,1
 call cli_write_stdout
 mov rsi,msg_isa_record_close_middle+IMAGE_VA
 mov rdx,msg_isa_record_close_middle_end-msg_isa_record_close_middle
 call cli_write_stdout
 db 0x0f,0xb6,0x43,0x07
 add rax,48
 mov rdx,op_misc+IMAGE_VA
 db 0x88,0x42,0x59
 mov rsi,rdx
 add rsi,89
 mov rdx,1
 call cli_write_stdout
 mov rsi,msg_isa_record_close_end+IMAGE_VA
 mov rdx,msg_isa_record_close_end_end-msg_isa_record_close_end
 call cli_write_stdout
 add r12,1
cli_isa_model_next:
 add rbx,8
 jmp cli_isa_model_loop
cli_isa_model_done:
 mov rsi,msg_isa_model_close+IMAGE_VA
 mov rdx,msg_isa_model_close_end-msg_isa_model_close
 call cli_write_stdout
 ret

process_done:
 ret

; Skip spaces/tabs/commas. RSI advances.
skip_spaces:
 db 0x0f, 0xb6, 0x06
 cmp rax,32
 je skip_space_one
 cmp rax,9
 je skip_space_one
 ret
skip_space_one:
 add rsi,1
 jmp skip_spaces

skip_separators:
 db 0x0f, 0xb6, 0x06
 cmp rax,32
 je skip_sep_one
 cmp rax,9
 je skip_sep_one
 cmp rax,44
 je skip_sep_one
 ret
skip_sep_one:
 add rsi,1
 jmp skip_separators

; Parse token from RSI to token_buffer, stopping at NUL/space/tab/comma/semicolon.
parse_token:
 mov rdi,rsi
 mov r11,line_buffer+IMAGE_VA
 sub rdi,r11
 cmp rdi,4095
 db 0x0f, 0x97
 db 0xc1                         ; seta cl: this is not a source-line cursor
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je parse_token_column_done
 add rdi,1
 mov rax,rdi
 mov rdi,diag_column+IMAGE_VA
 mov [rdi],rax
parse_token_column_done:
 mov rdi,token_buffer+IMAGE_VA
 xor rcx,rcx
parse_token_loop:
 db 0x0f, 0xb6, 0x06
 cmp rax,0
 je parse_token_done
 cmp rax,32
 je parse_token_done
 cmp rax,9
 je parse_token_done
 cmp rax,44
 je parse_token_done
 cmp rax,59
 je parse_token_done
 cmp rcx,65
 je syntax_error
 db 0xaa
 add rsi,1
 add rcx,1
 jmp parse_token_loop
parse_token_done:
 xor rax,rax
 db 0xaa
 mov rax,rcx
 ret

; Return RAX=1 if zero-terminated strings at RSI and RDI match.
string_equal:
string_equal_loop:
 db 0x0f, 0xb6, 0x06
 db 0x3a, 0x07
 jne string_not_equal
 cmp al,0
 je string_is_equal
 add rsi,1
 add rdi,1
 jmp string_equal_loop
string_not_equal:
 xor rax,rax
 ret
string_is_equal:
 mov rax,1
 ret

; Emit AL to output cursor R14. Pass 0 only measures, pass 1 writes.
emit_byte:
 mov rsi,rax
 mov rax,[rbp+8]
 cmp rax,0x10000
 je output_limit_error
 mov rax,[rbp+0]
 cmp rax,1
 je emit_byte_real
 mov rax,[rbp+8]
 add rax,1
 mov [rbp+8],rax
 mov rax,rsi
 ret
emit_byte_real:
 mov rdi,r14
 mov rax,rsi
 db 0x88, 0x07
 add r14,1
 mov rax,[rbp+8]
 add rax,1
 mov [rbp+8],rax
 mov rax,rsi
 ret

; ---------------------------------------------------------------------------
; RUASM 1.1.0 operand layer: expressions, EQU, register/memory operands.
; Convention: rbp=state, r12/r13/r14 are global cursors and are never touched.
; r8 = line cursor after the mnemonic. Pseudo conditional jumps (ja/jb/...)
; are expanded by the development generator into SETcc+CMP+JE and clobber RCX.
; ---------------------------------------------------------------------------

; Stable machine-readable diagnostic categories (diag_code is reset per line).
range_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 jmp syntax_error
identifier_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,2
 mov [rbx],rax
 jmp syntax_error
duplicate_symbol_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,3
 mov [rbx],rax
 jmp syntax_error
undefined_symbol_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,4
 mov [rbx],rax
 jmp syntax_error
symbol_limit_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,5
 mov [rbx],rax
 jmp syntax_error
output_limit_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,6
 mov [rbx],rax
 jmp syntax_error
equ_cycle_error:
 mov rbx,diag_code+IMAGE_VA
 mov rax,7
 mov [rbx],rax
 xor rsi,rsi
 jmp syntax_error

; Validate token_buffer as an ASCII identifier and reject keyword/register names.
; First character: [A-Za-z_]. Remaining characters: [A-Za-z0-9_].
validate_symbol_name:
 mov r10,1
 mov rsi,token_buffer+IMAGE_VA
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 je identifier_error
 mov rax,rdx
 sub rax,48
 cmp rax,10
 db 0x0f, 0x92, 0xc1            ; setb cl: first byte is a digit
 db 0x0f, 0xb6, 0xc9            ; movzx ecx,cl
 cmp rcx,1
 je identifier_error
 call is_ident
 cmp rax,1
 jne identifier_error
 add rsi,1
validate_symbol_tail:
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 je validate_symbol_reserved
 cmp r10,63
 je identifier_error
 call is_ident
 cmp rax,1
 jne identifier_error
 add r10,1
 add rsi,1
 jmp validate_symbol_tail
validate_symbol_reserved:
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,lit_db+IMAGE_VA
 call string_equal
 cmp rax,1
 je identifier_error
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,lit_equ+IMAGE_VA
 call string_equal
 cmp rax,1
 je identifier_error
 mov rbx,isa_table+IMAGE_VA
validate_symbol_isa_loop:
 db 0x0f, 0xb6, 0x13
 cmp rdx,0
 je validate_symbol_condition_prefix
 mov rdi,lit_db+IMAGE_VA
 add rdi,rdx
 sub rdi,1
 mov rsi,token_buffer+IMAGE_VA
 call string_equal
 cmp rax,1
 je identifier_error
 add rbx,8
 jmp validate_symbol_isa_loop
validate_symbol_condition_prefix:
 mov rsi,token_buffer+IMAGE_VA
 call isa_match_condition_mnemonic
 cmp rax,1
 je identifier_error
 mov rbx,reg_table+IMAGE_VA
 mov rcx,64
validate_symbol_register_loop:
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,rbx
 call string_equal
 cmp rax,1
 je identifier_error
 add rbx,8
 sub rcx,1
 cmp rcx,0
 jne validate_symbol_register_loop
 ret

; --- symbol table (entry = 64-byte name, 8-byte value, 8-byte kind; stride 80) ---
; 256 deterministic hash buckets and a separate collision-link array preserve
; the 80-byte entry layout and the 1024-symbol language limit.
; find_symbol: RSI=NUL-terminated name -> RAX=entry pointer or 0.
find_symbol:
 mov rdi,symbol_found_saved_rbx+IMAGE_VA
 mov [rdi],rbx
 mov r9,rsi
 mov rdi,rsi
 db 0x31,0xc0                  ; xor eax,eax
 mov rcx,64
 db 0xf2,0xae                  ; repne scasb: find NUL within the name buffer
 db 0x0f,0xb6,0x06              ; movzx eax,byte [rsi]
 db 0xc1,0xc0,0x05              ; rol eax,5
 db 0x0f,0xb6,0x56,0x01         ; movzx edx,byte [rsi+1]
 db 0x31,0xd0                  ; db 0x31,0xd0                  ; xor eax,edx
 db 0xc1,0xc0,0x05              ; rol eax,5
 db 0x0f,0xb6,0x57,0xfe         ; movzx edx,byte [rdi-2]
 db 0x31,0xd0                  ; xor eax,edx
 mov rdx,63
 sub rdx,rcx
 xor rax,rdx
 db 0x25,0xff,0x00,0x00,0x00  ; and eax,255 (zero-extends RAX)
 db 0xc1,0xe0,0x03              ; shl eax,3
 mov rbx,input_buffer+0xe0000+IMAGE_VA
 add rbx,rax
 mov r10,[rbx]
 xor r11,r11
find_symbol_loop:
 cmp r10,0
 je find_symbol_missing
 sub r10,1
 mov r11,r10
 db 0x49,0xc1,0xe3,0x06         ; shl r11,6
 mov rdx,r10
 db 0x48,0xc1,0xe2,0x04         ; shl rdx,4
 add r11,rdx
 add r11,label_table+IMAGE_VA
 mov rsi,r9
 mov rdi,r11
 call string_equal
 cmp rax,1
 je find_symbol_found
 xor r11,r11
 mov rbx,input_buffer+0xe1000+IMAGE_VA
 mov rdx,r10
 db 0x48,0xc1,0xe2,0x03         ; shl rdx,3
 add rbx,rdx
 mov r10,[rbx]
 jmp find_symbol_loop
find_symbol_found:
 mov rax,r11
 mov rdi,symbol_found_index+IMAGE_VA
 mov [rdi],r10
 mov rdi,symbol_found_saved_rbx+IMAGE_VA
 mov rbx,[rdi]
 ret
find_symbol_missing:
 xor rax,rax
 mov rdi,symbol_found_saved_rbx+IMAGE_VA
 mov rbx,[rdi]
 ret

; add_symbol: RSI=name, RDX=value. Clobbers RAX,RBX,RCX,RSI,RDI,RDX,R10,R11.
add_symbol:
 mov rax,[rbp+16]
 cmp rax,1024
 jne add_symbol_room
 mov rbx,diag_symbol_column+IMAGE_VA
 mov rax,[rbx]
 mov rbx,diag_column+IMAGE_VA
 mov [rbx],rax
 jmp symbol_limit_error
add_symbol_room:
 mov r10,rax
 mov rcx,rax
 db 0x48                         ; shl rcx,6
 db 0xc1, 0xe1, 0x06
 mov rbx,rax
 db 0x48                         ; shl rbx,4
 db 0xc1, 0xe3, 0x04
 add rcx,rbx
 mov rdi,label_table+IMAGE_VA
 add rdi,rcx
 mov r11,rdi
add_symbol_copy:
 db 0x0f                         ; movzx eax,byte [rsi]
 db 0xb6, 0x06
 mov [rdi],al
 cmp rax,0
 je add_symbol_done
 add rsi,1
 add rdi,1
 jmp add_symbol_copy
add_symbol_done:
 mov [r11+64],rdx
 db 0x41,0x0f,0xb6,0x03         ; movzx eax,byte [r11]
 db 0xc1,0xc0,0x05              ; rol eax,5
 db 0x41,0x0f,0xb6,0x53,0x01    ; movzx edx,byte [r11+1]
 db 0x31,0xd0                  ; xor eax,edx
 db 0xc1,0xc0,0x05              ; rol eax,5
 db 0x0f,0xb6,0x57,0xff         ; movzx edx,byte [rdi-1]
 db 0x31,0xd0                  ; xor eax,edx
 mov rdx,rdi
 sub rdx,r11
 xor rax,rdx
 db 0x25,0xff,0x00,0x00,0x00  ; and eax,255 (zero-extends RAX)
 db 0xc1,0xe0,0x03              ; shl eax,3
 mov rbx,input_buffer+0xe0000+IMAGE_VA
 add rbx,rax
 mov rax,[rbx]
 mov rdi,input_buffer+0xe1000+IMAGE_VA
 mov rdx,r10
 db 0x48,0xc1,0xe2,0x03         ; shl rdx,3
 add rdi,rdx
 mov [rdi],rax
 mov rdx,r10
 add rdx,1
 mov [rbx],rdx
 mov rax,[rbp+16]
 add rax,1
 mov [rbp+16],rax
 ret

; define_label: token_buffer (without the trailing colon) at current offset.
define_label:
 mov rsi,token_buffer+IMAGE_VA
 call find_symbol
 cmp rax,0
 je define_label_new
 mov rdx,[rbp+0]
 cmp rdx,0
 jne define_label_existing
 mov rbx,diag_symbol_column+IMAGE_VA
 mov rax,[rbx]
 mov rbx,diag_column+IMAGE_VA
 mov [rbx],rax
 jmp duplicate_symbol_error
define_label_existing:
 mov rdx,[rax+64]
 mov rcx,[rbp+8]
 cmp rdx,rcx
 je define_label_done
 mov [rax+64],rcx
 mov rdx,[rbp+0]
 cmp rdx,2
 jne define_label_done
 mov rdx,1
 mov rbx,equ_changed+IMAGE_VA
 mov [rbx],rdx
 ret
define_label_done:
 ret
define_label_new:
 mov rsi,token_buffer+IMAGE_VA
 mov rdx,[rbp+8]
 call add_symbol
 mov rsi,token_buffer+IMAGE_VA
 call find_symbol
 mov rdx,1
 ret

; lookup_label: token_buffer -> [rbp+24]=value, [rbp+32]=found flag.
lookup_label:
 mov rsi,token_buffer+IMAGE_VA
 call find_symbol
 cmp rax,0
 je lookup_label_missing
 ; Branch targets must be labels (kind 0), never EQU constants.
 mov rcx,[rax+72]
 cmp rcx,0
 jne syntax_error
 mov rax,[rax+64]
 mov [rbp+24],rax
 mov rax,1
 mov [rbp+32],rax
 ret
lookup_label_missing:
 xor rax,rax
 mov [rbp+32],rax
 ret

; --- character class: RDX=char -> RAX=1 if [0-9A-Za-z_] ---
is_ident:
 mov rax,rdx
 sub rax,48
 cmp rax,10
 ; jb is_ident_yes (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je is_ident_yes
 mov rax,rdx
 sub rax,65
 cmp rax,26
 ; jb is_ident_yes (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je is_ident_yes
 mov rax,rdx
 sub rax,97
 cmp rax,26
 ; jb is_ident_yes (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je is_ident_yes
 cmp rdx,95
 je is_ident_yes
 xor rax,rax
 ret
is_ident_yes:
 mov rax,1
 ret

; --- typed expression AST v1: postorder nodes, 16 bytes each ---
; Node qword 0: kind:u8, operator:u8, symbol_length:u8, reserved.
; Node qword 1: literal value / source symbol pointer / child IDs.
; The root table stores start_node:u32 | root_node:u32 for each operand slot.
get_current_expr_meta:
 mov rbx,expr_ast_generic_mode+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je get_current_expr_meta_generic
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 cmp rbx,0
 je get_current_expr_meta_none
 mov rax,typed_operand_ir+IMAGE_VA
 sub rbx,rax
 mov rax,typed_expr_meta_ir+IMAGE_VA
 add rax,rbx
 mov rbx,rax
 ret
get_current_expr_meta_generic:
 mov rbx,expr_ast_target+IMAGE_VA
 mov rbx,[rbx]
 ret
get_current_expr_meta_none:
 xor rbx,rbx
 ret

; Generic source-backed expression cache for EQU and DB/DW/DD/DQ.
; RSI points to the expression's first source byte in line_buffer. The key is
; its absolute source-byte offset, so comma-separated data expressions are
; distinct and every later layout pass reuses the same immutable AST.
prepare_generic_expr_ast:
 mov rbx,line_source_pointer+IMAGE_VA
 mov rax,[rbx]
 mov rbx,ir_source_base+IMAGE_VA
 mov rdx,[rbx]
 sub rax,rdx
 mov rdx,rsi
 mov rbx,line_buffer+IMAGE_VA
 sub rdx,rbx
 add rax,rdx
 ; Cache slots are 8 bytes; distinct expression starts are at least 2 bytes apart.
 db 0x48,0xc1,0xe0,0x02
 mov rbx,generic_expr_meta+IMAGE_VA
 add rbx,rax
 mov rdx,expr_ast_target+IMAGE_VA
 mov [rdx],rbx
 mov rdx,expr_ast_generic_mode+IMAGE_VA
 mov rax,1
 mov [rdx],rax
 mov rax,[rbx]
 cmp rax,0
 jne prepare_generic_expr_ast_cached
 mov rdx,expr_ast_generic_cached+IMAGE_VA
 xor rax,rax
 mov [rdx],rax
 mov rdx,expr_ast_enabled+IMAGE_VA
 mov rax,1
 mov [rdx],rax
 mov rdx,expr_ast_depth+IMAGE_VA
 xor rax,rax
 mov [rdx],rax
 ret
prepare_generic_expr_ast_cached:
 mov rdx,expr_ast_generic_cached+IMAGE_VA
 mov rax,1
 mov [rdx],rax
 mov rdx,expr_ast_enabled+IMAGE_VA
 xor rax,rax
 mov [rdx],rax
 ret

; RSI=token_buffer on entry; RAX=value on return. The first encounter parses
; and builds the AST; later passes skip parsing and evaluate the cached tree.
; Symbol values are always read from the current symbol table.
parse_expr_generic:
 mov rbx,expr_ast_generic_cached+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je parse_expr_generic_cached
 mov rsi,token_buffer+IMAGE_VA
 call parse_expr
 call eval_expression_ast
 jmp parse_expr_generic_done
parse_expr_generic_cached:
 mov rsi,token_buffer+IMAGE_VA
parse_expr_generic_scan:
 db 0x0f,0xb6,0x06
 cmp rax,0
 je parse_expr_generic_eval
 add rsi,1
 jmp parse_expr_generic_scan
parse_expr_generic_eval:
 call eval_expression_ast
parse_expr_generic_done:
 db 0x50                         ; preserve expression result while clearing mode flags
 mov rbx,expr_ast_generic_mode+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,expr_ast_generic_cached+IMAGE_VA
 mov [rbx],rax
 db 0x58
 ret

expr_ast_prepare:
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 cmp rbx,0
 je expr_ast_prepare_off
 call get_current_expr_meta
 mov rax,expr_ast_target+IMAGE_VA
 mov [rax],rbx
 mov rax,1
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov [rbx],rax
 mov rbx,expr_ast_depth+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 ret
expr_ast_prepare_off:
 mov rbx,expr_ast_enabled+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 ret

expr_ast_enter:
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne expr_ast_enter_done
 mov rbx,expr_ast_depth+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 jne expr_ast_enter_nested
 mov rbx,expr_ast_build_sp+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,expr_ast_count+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov rbx,expr_ast_start_id+IMAGE_VA
 mov [rbx],rax
expr_ast_enter_nested:
 mov rbx,expr_ast_depth+IMAGE_VA
 mov rax,[rbx]
 cmp rax,4096
 je range_error
 add rax,1
 mov [rbx],rax
 ; Every recursive parenthesized expression gets its own operand-stack base.
 mov rdx,rax
 sub rdx,1
 db 0x48,0xc1,0xe2,0x03
 mov rbx,expr_ast_build_base+IMAGE_VA
 add rbx,rdx
 mov rdx,expr_ast_build_sp+IMAGE_VA
 mov rdx,[rdx]
 mov [rbx],rdx
expr_ast_enter_done:
 ret

expr_ast_leave:
 db 0x50
 db 0x56
 db 0x41,0x50
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne expr_ast_leave_done
 ; A nested expression must leave exactly one root above its saved base.
 mov rbx,expr_ast_depth+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 je range_error
 mov rdx,rax
 sub rdx,1
 db 0x48,0xc1,0xe2,0x03
 mov rbx,expr_ast_build_base+IMAGE_VA
 add rbx,rdx
 mov rdx,[rbx]
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rbx]
 sub rcx,rdx
 cmp rcx,1
 jne range_error
 mov rbx,expr_ast_depth+IMAGE_VA
 mov rax,[rbx]
 sub rax,1
 mov [rbx],rax
 cmp rax,0
 jne expr_ast_leave_done
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne range_error
 mov rbx,expr_ast_build_stack+IMAGE_VA
 mov rax,[rbx]
 mov rcx,expr_ast_start_id+IMAGE_VA
 mov rcx,[rcx]
 mov rdx,rax
 db 0x48,0xc1,0xe2,0x20
 db 0x48,0x09,0xd1
 mov rbx,expr_ast_target+IMAGE_VA
 mov rbx,[rbx]
 mov [rbx],rcx
 mov rbx,expr_ast_enabled+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
expr_ast_leave_done:
 db 0x41,0x58
 db 0x5e
 db 0x58
 ret

; RAX=result is preserved; RAX=node ID and RBX=node pointer on return.
expr_ast_alloc_node:
 mov rbx,expr_ast_count+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 cmp rax,196608
 je range_error
 mov [rbx],rax
 mov rcx,rax
 sub rcx,1
 db 0x48,0xc1,0xe1,0x04
 mov rbx,expression_ast_ir+IMAGE_VA
 add rbx,rcx
 ret

expr_ast_push_literal:
 db 0x50
 db 0x56
 db 0x41,0x50
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne expr_ast_push_literal_done
 call expr_ast_alloc_node
 mov rdx,1
 mov [rbx],rdx
 mov rdx,[rsp+16]
 mov [rbx+8],rdx
 mov rdx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rdx]
 cmp rcx,4095
 je range_error
 mov rdi,expr_ast_build_stack+IMAGE_VA
 db 0x48,0xc1,0xe1,0x03
 add rdi,rcx
 mov [rdi],rax
 mov rcx,[rdx]
 add rcx,1
 mov [rdx],rcx
expr_ast_push_literal_done:
 db 0x41,0x58
 db 0x5e
 db 0x58
 ret

expr_ast_push_symbol:
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne expr_ast_push_symbol_done
 db 0x50
 db 0x56
 db 0x41,0x50
 db 0x41,0x51
 ; Copy spelling into immutable pool; later passes may reuse line/token buffers.
 mov rbx,expr_ast_name_used+IMAGE_VA
 mov rcx,[rbx]
 mov rdx,expression_ast_names+IMAGE_VA
 add rdx,rcx
 mov rdi,rdx
 mov rsi,sym_buffer+IMAGE_VA
 mov r10,r9
expr_ast_push_symbol_copy:
 cmp r10,0
 je expr_ast_push_symbol_copy_done
 db 0x0f,0xb6,0x06
 db 0x88,0x07
 add rsi,1
 add rdi,1
 sub r10,1
 jmp expr_ast_push_symbol_copy
expr_ast_push_symbol_copy_done:
 xor rax,rax
 db 0x88,0x07
 mov rax,rcx
 add rax,r9
 add rax,1
 mov rbx,expr_ast_name_used+IMAGE_VA
 mov [rbx],rax
 mov rbx,expr_ast_temp_ptr+IMAGE_VA
 mov [rbx],rdx
 mov rbx,expr_ast_temp_len+IMAGE_VA
 mov [rbx],r9
 call expr_ast_alloc_node
 mov rdx,2
 mov rcx,expr_ast_temp_len+IMAGE_VA
 mov rcx,[rcx]
 db 0x48,0xc1,0xe1,0x10
 db 0x48,0x09,0xca
 mov [rbx],rdx
 mov rdx,expr_ast_temp_ptr+IMAGE_VA
 mov rdx,[rdx]
 mov [rbx+8],rdx
 mov rdx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rdx]
 cmp rcx,4095
 je range_error
 mov rdi,expr_ast_build_stack+IMAGE_VA
 db 0x48,0xc1,0xe1,0x03
 add rdi,rcx
 mov [rdi],rax
 mov rcx,[rdx]
 add rcx,1
 mov [rdx],rcx
 db 0x41,0x59
 db 0x41,0x58
 db 0x5e
 db 0x58
expr_ast_push_symbol_done:
 ret

; RDX=operator code; preserve evaluated result in RAX and parser cursors.
expr_ast_make_binary:
 db 0x50
 db 0x56
 db 0x41,0x50
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne expr_ast_make_binary_done
 mov rbx,expr_ast_temp_op+IMAGE_VA
 mov [rbx],rdx
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rbx]
 mov rdx,expr_ast_depth+IMAGE_VA
 mov rdx,[rdx]
 sub rdx,1
 db 0x48,0xc1,0xe2,0x03
 mov rbx,expr_ast_build_base+IMAGE_VA
 add rbx,rdx
 mov rdx,[rbx]
 sub rcx,rdx
 cmp rcx,2
 jne range_error
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rbx]
 sub rcx,1
 mov rdi,expr_ast_build_stack+IMAGE_VA
 mov rdx,rcx
 db 0x48,0xc1,0xe2,0x03
 add rdi,rdx
 mov rdx,[rdi]
 mov rbx,expr_ast_temp_right+IMAGE_VA
 mov [rbx],rdx
 sub rcx,1
 mov rdi,expr_ast_build_stack+IMAGE_VA
 mov rdx,rcx
 db 0x48,0xc1,0xe2,0x03
 add rdi,rdx
 mov rdx,[rdi]
 mov rbx,expr_ast_temp_left+IMAGE_VA
 mov [rbx],rdx
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov [rbx],rcx
 call expr_ast_alloc_node
 mov rdx,expr_ast_temp_op+IMAGE_VA
 mov rcx,[rdx]
 db 0x48,0xc1,0xe1,0x08
 db 0x48,0x83,0xc9,0x03
 mov rdx,rax
 sub rdx,1
 db 0x48,0xc1,0xe2,0x04
 mov rbx,expression_ast_ir+IMAGE_VA
 add rbx,rdx
 mov [rbx],rcx
 mov rdx,expr_ast_temp_left+IMAGE_VA
 mov rdx,[rdx]
 mov rcx,expr_ast_temp_right+IMAGE_VA
 mov rcx,[rcx]
 db 0x48,0xc1,0xe1,0x20
 db 0x48,0x09,0xd1
 mov [rbx+8],rcx
 mov rdx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rdx]
 mov rbx,expr_ast_build_stack+IMAGE_VA
 mov rdi,rcx
 db 0x48,0xc1,0xe7,0x03
 add rbx,rdi
 mov [rbx],rax
 add rcx,1
 mov [rdx],rcx
expr_ast_make_binary_done:
 db 0x41,0x58
 db 0x5e
 db 0x58
 ret

expr_ast_make_negation:
 db 0x50
 db 0x56
 db 0x41,0x50
 mov rbx,expr_ast_enabled+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne expr_ast_make_negation_done
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rbx]
 mov rdx,expr_ast_depth+IMAGE_VA
 mov rdx,[rdx]
 sub rdx,1
 db 0x48,0xc1,0xe2,0x03
 mov rbx,expr_ast_build_base+IMAGE_VA
 add rbx,rdx
 mov rdx,[rbx]
 sub rcx,rdx
 cmp rcx,1
 jne range_error
 mov rbx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rbx]
 sub rcx,1
 mov rdi,expr_ast_build_stack+IMAGE_VA
 mov rdx,rcx
 db 0x48,0xc1,0xe2,0x03
 add rdi,rdx
 mov rdx,[rdi]
 mov rdi,expr_ast_temp_left+IMAGE_VA
 mov [rdi],rdx
 mov [rbx],rcx
 call expr_ast_alloc_node
 mov rdx,0x104
 mov [rbx],rdx
 mov rdx,expr_ast_temp_left+IMAGE_VA
 mov rdx,[rdx]
 mov [rbx+8],rdx
 mov rdx,expr_ast_build_sp+IMAGE_VA
 mov rcx,[rdx]
 mov rbx,expr_ast_build_stack+IMAGE_VA
 mov rdi,rcx
 db 0x48,0xc1,0xe7,0x03
 add rbx,rdi
 mov [rbx],rax
 add rcx,1
 mov [rdx],rcx
expr_ast_make_negation_done:
 db 0x41,0x58
 db 0x5e
 db 0x58
 ret

; Evaluate the cached postorder expression nodes against the current symbol table.
; Symbols are re-evaluated on each layout pass.
eval_expression_ast:
 db 0x56
 db 0x41,0x50
 call get_current_expr_meta
 mov rax,[rbx]
 mov rdx,rax
 db 0x89,0xc0                  ; zero-extend low 32-bit start node ID
 mov rbx,expr_ast_eval_start+IMAGE_VA
 mov [rbx],rax
 db 0x48,0xc1,0xea,0x20
 add rdx,1
 mov rbx,expr_ast_eval_end+IMAGE_VA
 mov [rbx],rdx
 mov rbx,expr_ast_eval_sp+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,expr_ast_eval_start+IMAGE_VA
 mov rax,[rbx]
 mov rbx,expr_ast_eval_index+IMAGE_VA
 mov [rbx],rax
eval_expression_ast_loop:
 mov rbx,expr_ast_eval_index+IMAGE_VA
 mov rax,[rbx]
 sub rax,1
 db 0x48,0xc1,0xe0,0x04
 mov rbx,expression_ast_ir+IMAGE_VA
 add rbx,rax
 mov rdx,[rbx]
 mov rax,rdx
 db 0x48,0x25,0xff,0,0,0
 cmp rax,1
 je eval_expression_ast_literal
 cmp rax,2
 je eval_expression_ast_symbol
 cmp rax,3
 je eval_expression_ast_binary
 cmp rax,4
 je eval_expression_ast_unary
 jmp range_error
eval_expression_ast_literal:
 mov rax,[rbx+8]
 call eval_expression_ast_push
 jmp eval_expression_ast_next
eval_expression_ast_symbol:
 mov rax,[rbx+8]
 mov rbx,expr_ast_eval_source+IMAGE_VA
 mov [rbx],rax
 mov rbx,expr_ast_eval_symbol_len+IMAGE_VA
 mov rcx,rdx
 db 0x48,0xc1,0xe9,0x10
 db 0x48,0x81,0xe1,0xff,0,0,0
 mov [rbx],rcx
 mov rsi,rax
 mov rdi,sym_buffer+IMAGE_VA
 xor r10,r10
eval_expression_ast_copy_symbol:
 mov rbx,expr_ast_eval_symbol_len+IMAGE_VA
 mov rcx,[rbx]
 cmp r10,rcx
 je eval_expression_ast_copy_symbol_done
 db 0x0f,0xb6,0x16
 db 0x88,0x17
 add rsi,1
 add rdi,1
 add r10,1
 jmp eval_expression_ast_copy_symbol
eval_expression_ast_copy_symbol_done:
 xor rax,rax
 db 0x88,0x07
 mov rsi,sym_buffer+IMAGE_VA
 call find_symbol
 cmp rax,0
 je eval_expression_ast_unknown
 mov rbx,expr_ast_eval_symbol_entry+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_graph_capture+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne eval_expression_ast_symbol_saved
 mov rbx,expr_ast_eval_symbol_entry+IMAGE_VA
 mov rax,[rbx]
 call record_equ_dependency
eval_expression_ast_symbol_saved:
 mov rbx,expr_ast_eval_symbol_entry+IMAGE_VA
 mov rbx,[rbx]
 mov rdx,[rbx+72]
 cmp rdx,2
 jne eval_expression_ast_symbol_value
 mov rbx,expr_unresolved+IMAGE_VA
 mov rdx,1
 mov [rbx],rdx
eval_expression_ast_symbol_value:
 mov rbx,expr_ast_eval_symbol_entry+IMAGE_VA
 mov rbx,[rbx]
 mov rax,[rbx+64]
 call eval_expression_ast_push
 jmp eval_expression_ast_next
eval_expression_ast_unknown:
 mov rbx,rbp
 mov rcx,[rbx]
 cmp rcx,0
 jne undefined_symbol_error
 mov rbx,expr_unresolved+IMAGE_VA
 mov rdx,1
 mov [rbx],rdx
 xor rax,rax
 call eval_expression_ast_push
 jmp eval_expression_ast_next
eval_expression_ast_binary:
 call eval_expression_ast_pop
 mov rbx,expr_ast_eval_value+IMAGE_VA
 mov [rbx],rax
 call eval_expression_ast_pop
 mov rcx,expr_ast_eval_value+IMAGE_VA
 mov rcx,[rcx]
 mov rbx,expr_ast_eval_index+IMAGE_VA
 mov rbx,[rbx]
 sub rbx,1
 db 0x48,0xc1,0xe3,0x04
 mov rdx,expression_ast_ir+IMAGE_VA
 add rdx,rbx
 mov rdx,[rdx]
 db 0x48,0xc1,0xea,0x08
 db 0x48,0x81,0xe2,0xff,0,0,0
 cmp rdx,1
 je eval_expression_ast_add
 cmp rdx,2
 je eval_expression_ast_sub
 cmp rdx,3
 je eval_expression_ast_shl
 cmp rdx,4
 je eval_expression_ast_shr
 cmp rdx,5
 je eval_expression_ast_and
 cmp rdx,6
 je eval_expression_ast_or
 jmp range_error
eval_expression_ast_add:
 add rax,rcx
 jmp eval_expression_ast_binary_done
eval_expression_ast_sub:
 sub rax,rcx
 jmp eval_expression_ast_binary_done
eval_expression_ast_shl:
 mov rdx,rcx
 db 0x48,0xc1,0xea,0x06
 cmp rdx,0
 jne range_error
 mov rdx,rax
 db 0x48,0xd3,0xe0
 db 0x50
 db 0x48,0xd3,0xe8
 cmp rax,rdx
 db 0x58
 jne range_error
 jmp eval_expression_ast_binary_done
eval_expression_ast_shr:
 mov rdx,rcx
 db 0x48,0xc1,0xea,0x06
 cmp rdx,0
 jne range_error
 db 0x48,0xd3,0xe8
 jmp eval_expression_ast_binary_done
eval_expression_ast_and:
 db 0x48,0x21,0xc8
 jmp eval_expression_ast_binary_done
eval_expression_ast_or:
 db 0x48,0x09,0xc8
eval_expression_ast_binary_done:
 call eval_expression_ast_push
 jmp eval_expression_ast_next
eval_expression_ast_unary:
 call eval_expression_ast_pop
 db 0x48,0xf7,0xd8
 call eval_expression_ast_push
eval_expression_ast_next:
 mov rbx,expr_ast_eval_index+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 mov rbx,expr_ast_eval_end+IMAGE_VA
 mov rcx,[rbx]
 cmp rax,rcx
 jne eval_expression_ast_loop
 mov rbx,expr_ast_eval_sp+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne range_error
 call eval_expression_ast_pop
 db 0x41,0x58
 db 0x5e
 ret

eval_expression_ast_push:
 mov rbx,expr_ast_eval_sp+IMAGE_VA
 mov rcx,[rbx]
 cmp rcx,4095
 je range_error
 mov rdx,expr_ast_eval_stack+IMAGE_VA
 mov rsi,rcx
 db 0x48,0xc1,0xe6,0x03
 add rdx,rsi
 mov [rdx],rax
 add rcx,1
 mov [rbx],rcx
 ret

eval_expression_ast_pop:
 mov rbx,expr_ast_eval_sp+IMAGE_VA
 mov rcx,[rbx]
 cmp rcx,0
 je range_error
 sub rcx,1
 mov [rbx],rcx
 mov rdx,expr_ast_eval_stack+IMAGE_VA
 mov rsi,rcx
 db 0x48,0xc1,0xe6,0x03
 add rdx,rsi
 mov rax,[rdx]
 ret

; --- expressions: | & (<< >>) (+ -) unary(- paren number symbol) ---
; RSI=cursor -> RAX=value, RSI advanced. Unknown symbols are 0 in pass 0 only.
parse_expr:
 call expr_ast_enter
 call expr_and
expr_or_loop:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,124
 jne expr_or_done
 add rsi,1
 db 0x50                         ; db 0x50
 call expr_and
 db 0x59                         ; pop rcx
 db 0x48                         ; or rax,rcx
 db 0x09, 0xc8
 mov rdx,6
 call expr_ast_make_binary
 jmp expr_or_loop
expr_or_done:
 call expr_ast_leave
 ret

expr_and:
 call expr_shift
expr_and_loop:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,38
 jne expr_and_done
 add rsi,1
 db 0x50                         ; db 0x50
 call expr_shift
 db 0x59                         ; pop rcx
 db 0x48                         ; and rax,rcx
 db 0x21, 0xc8
 mov rdx,5
 call expr_ast_make_binary
 jmp expr_and_loop
expr_and_done:
 ret

expr_shift:
 call expr_add
expr_shift_loop:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,62
 je expr_shift_right
 cmp rdx,60
 je expr_shift_left
 ret
expr_shift_right:
 db 0x0f                         ; movzx edx,byte [rsi+1]
 db 0xb6, 0x56, 0x01
 cmp rdx,62
 jne syntax_error
 add rsi,2
 db 0x50                         ; db 0x50
 call expr_add
 mov rcx,rax
 db 0x58                         ; db 0x58
 cmp rcx,64
 db 0x0f, 0x93, 0xc2            ; setae dl
 db 0x0f, 0xb6, 0xd2            ; movzx edx,dl
 cmp rdx,1
 je range_error
 db 0x48                         ; shr rax,cl
 db 0xd3, 0xe8
 mov rdx,4
 call expr_ast_make_binary
 jmp expr_shift_loop
expr_shift_left:
 db 0x0f                         ; movzx edx,byte [rsi+1]
 db 0xb6, 0x56, 0x01
 cmp rdx,60
 jne syntax_error
 add rsi,2
 db 0x50                         ; db 0x50
 call expr_add
 mov rcx,rax
 db 0x58                         ; db 0x58
 cmp rcx,64
 db 0x0f, 0x93, 0xc2            ; setae dl
 db 0x0f, 0xb6, 0xd2            ; movzx edx,dl
 cmp rdx,1
 je range_error
 mov rdx,rax
 db 0x48                         ; shl rax,cl
 db 0xd3, 0xe0
 db 0x50                         ; push shifted value
 db 0x48                         ; shr rax,cl
 db 0xd3, 0xe8
 cmp rax,rdx
 db 0x58                         ; pop shifted value
 jne range_error
 mov rdx,3
 call expr_ast_make_binary
 jmp expr_shift_loop

expr_add:
 call expr_unary
expr_add_loop:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,43
 je expr_add_plus
 cmp rdx,45
 je expr_add_minus
 ret
expr_add_plus:
 add rsi,1
 db 0x50                         ; db 0x50
 call expr_unary
 db 0x59                         ; pop rcx
 add rax,rcx
 mov rdx,1
 call expr_ast_make_binary
 jmp expr_add_loop
expr_add_minus:
 add rsi,1
 db 0x50                         ; db 0x50
 call expr_unary
 mov rcx,rax
 db 0x58                         ; db 0x58
 sub rax,rcx
 mov rdx,2
 call expr_ast_make_binary
 jmp expr_add_loop

expr_unary:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,43
 je expr_plus
 cmp rdx,45
 je expr_neg
 cmp rdx,40
 je expr_paren
 mov rax,rdx
 sub rax,48
 cmp rax,10
 ; jb expr_number (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je expr_number
 call is_ident
 cmp rax,1
 je expr_symbol
 jmp syntax_error
expr_plus:
 add rsi,1
 call expr_unary
 ret
expr_neg:
 add rsi,1
 call expr_unary
 db 0x48                         ; neg rax
 db 0xf7, 0xd8
 call expr_ast_make_negation
 ret
expr_paren:
 add rsi,1
 call parse_expr
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,41
 jne syntax_error
 add rsi,1
 ret

expr_number:
 xor rax,rax
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,48
 jne expr_decimal
 db 0x0f                         ; movzx edx,byte [rsi+1]
 db 0xb6, 0x56, 0x01
 cmp rdx,120
 je expr_hex_start
 cmp rdx,88
 je expr_hex_start
expr_decimal:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 sub rdx,48
 cmp rdx,10
 ; jae expr_number_done (expanded)
 db 0x0f                         ; db 0x0f,0x93,0xc1
 db 0x93, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je expr_number_done
 mov r9,rdx                      ; preserve decimal digit
 mov rcx,0x1999999999999999     ; UINT64_MAX / 10
 cmp rax,rcx
 db 0x0f, 0x97, 0xc1            ; seta cl: value > UINT64_MAX / 10
 db 0x0f, 0x94, 0xc2            ; sete dl: value == UINT64_MAX / 10
 db 0x0f, 0xb6, 0xc9            ; movzx ecx,cl
 db 0x0f, 0xb6, 0xd2            ; movzx edx,dl
 cmp rcx,1
 je range_error
 cmp rdx,1
 jne expr_decimal_accumulate
 cmp r9,5
 db 0x0f, 0x97, 0xc1            ; seta cl: final digit > 5
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je range_error
expr_decimal_accumulate:
 db 0x48, 0x6b, 0xc0, 0x0a      ; imul rax,rax,10
 add rax,r9
 add rsi,1
 jmp expr_decimal
expr_hex_start:
 add rsi,2
 xor r9,r9
expr_hex:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 sub rdx,48
 cmp rdx,10
 ; jb expr_hex_digit (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je expr_hex_digit
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 sub rdx,97
 cmp rdx,6
 ; jb expr_hex_alpha (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je expr_hex_alpha
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 sub rdx,65
 cmp rdx,6
 ; jb expr_hex_alpha (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je expr_hex_alpha
 cmp r9,0
 je syntax_error
 jmp expr_number_done
expr_hex_alpha:
 add rdx,10
expr_hex_digit:
 mov rcx,rax
 db 0x48, 0xc1, 0xe9, 0x3c      ; shr rcx,60
 cmp rcx,0
 jne range_error
 db 0x48                         ; shl rax,4
 db 0xc1, 0xe0, 0x04
 add rax,rdx
 add rsi,1
 add r9,1
 jmp expr_hex
expr_number_done:
 call expr_ast_push_literal
 ret

expr_symbol:
 mov rdi,sym_buffer+IMAGE_VA
 xor r9,r9
expr_symbol_copy:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 call is_ident
 cmp rax,1
 jne expr_symbol_end
 cmp r9,63
 je syntax_error
 mov [rdi],dl
 add rdi,1
 add rsi,1
 add r9,1
 jmp expr_symbol_copy
expr_symbol_end:
 xor rax,rax
 mov [rdi],al
 call expr_ast_push_symbol
 db 0x56                         ; db 0x56
 mov rsi,sym_buffer+IMAGE_VA
 call find_symbol
 db 0x5e                         ; db 0x5e
 cmp rax,0
 je expr_symbol_unknown
 mov rbx,equ_graph_capture+IMAGE_VA
 mov rdx,[rbx]
 cmp rdx,1
 jne expr_symbol_graph_done
 call record_equ_dependency
expr_symbol_graph_done:
 mov rbx,rax
 mov rdx,[rbx+72]
 cmp rdx,2
 jne expr_symbol_value
 mov rdx,expr_unresolved+IMAGE_VA
 mov rcx,1
 mov [rdx],rcx
expr_symbol_value:
 mov rax,[rbx+64]
 ret
; RAX is the referenced symbol entry. Record only EQU-to-EQU edges.
record_equ_dependency:
 mov rbx,equ_graph_saved_entry+IMAGE_VA
 mov [rbx],rax
 mov rdx,[rax+72]
 cmp rdx,0
 je record_equ_dependency_done
 mov rbx,equ_graph_owner+IMAGE_VA
 mov rcx,[rbx]
 db 0x48,0xc1,0xe1,0x04       ; owner * 16 qwords
 mov rbx,symbol_found_index+IMAGE_VA
 mov rdx,[rbx]
 mov r10,rdx
 db 0x49,0xc1,0xea,0x06       ; target / 64
 add rcx,r10
 db 0x48,0xc1,0xe1,0x03
 mov rbx,equ_graph_bits+IMAGE_VA
 add rbx,rcx
 mov rcx,rdx
 db 0x48,0x83,0xe1,0x3f
 db 0x41,0xba,1,0,0,0
 db 0x49,0xd3,0xe2            ; shl r10,cl
 mov rdx,[rbx]
 db 0x4c,0x85,0xd2
 jne record_equ_dependency_done
 db 0x4c,0x09,0xd2
 mov [rbx],rdx
 mov rbx,equ_graph_owner+IMAGE_VA
 mov rcx,[rbx]
 db 0x48,0xc1,0xe1,0x03
 mov rbx,equ_graph_counts+IMAGE_VA
 add rbx,rcx
 mov rdx,[rbx]
 add rdx,1
 mov [rbx],rdx
record_equ_dependency_done:
 mov rbx,equ_graph_saved_entry+IMAGE_VA
 mov rax,[rbx]
 ret

expr_symbol_unknown:
 mov rax,[rbp+0]
 cmp rax,0
 je expr_symbol_forward_unknown
 jmp undefined_symbol_error
expr_symbol_forward_unknown:
 mov rdx,expr_unresolved+IMAGE_VA
 mov rcx,1
 mov [rdx],rcx
 xor rax,rax
 ret

; --- register names: RSI=text -> GPR code 0..15 (r64), 16..19 (r8), 20..35 (r32), 36..51 (r16) / -1 ---
read_reg:
 mov r11,rsi
 xor rax,rax
 mov rdi,regbuf+IMAGE_VA
 mov [rdi],rax
 xor r9,r9
read_reg_copy:
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 call is_ident
 cmp rax,1
 jne read_reg_copied
 cmp r9,7
 je read_reg_none
 mov [rdi],dl
 add rdi,1
 add rsi,1
 add r9,1
 jmp read_reg_copy
read_reg_copied:
 mov rdi,regbuf+IMAGE_VA
 mov rdx,[rdi]
 xor r10,r10
 mov r9,reg_table+IMAGE_VA
read_reg_search:
 mov rax,[r9]
 cmp rax,rdx
 je read_reg_found
 add r9,8
 add r10,1
 cmp r10,64
 jne read_reg_search
read_reg_none:
 mov rsi,r11
 mov rax,0-1
 ret
read_reg_found:
 mov rax,r10
 ret

; --- operands. kind: 1=r64, 2=r8, 3=mem, 4=imm, 5=r32, 6=r16 ---
; Typed operand IR v1: one packed 8-byte node per operand. Register nodes cache
; their register class/index. Immediate and memory nodes retain exact source spans.
parse_operand:
 mov r15,rdi
 call prepare_operand_ir_slot
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 cmp rbx,0
 je parse_operand_uncached
 mov rax,[rbx]
 mov rdx,rax
 db 0x48,0x81,0xe2,0xff,0,0,0
 cmp rdx,1
 je parse_operand_cached_register
 cmp rdx,2
 je parse_operand_cached_register
 cmp rdx,5
 je parse_operand_cached_register
 cmp rdx,6
 je parse_operand_cached_register
 cmp rdx,3
 je parse_operand_cached_span
 cmp rdx,4
 je parse_operand_cached_span
parse_operand_uncached:
 mov rsi,r8
 call skip_separators
 mov rbx,operand_source_offset+IMAGE_VA
 mov rax,rsi
 sub rax,line_buffer+IMAGE_VA
 mov [rbx],rax
 call parse_token
 mov rbx,operand_token_length+IMAGE_VA
 mov [rbx],rax
 mov r8,rsi
 cmp rax,0
 je syntax_error
 mov rsi,token_buffer+IMAGE_VA
 db 0x0f,0xb6,0x16
 cmp rdx,91
 je parse_operand_mem
 call read_reg
 cmp rax,0-1
 je parse_operand_imm
 db 0x0f,0xb6,0x16
 cmp rdx,0
 jne parse_operand_imm
 cmp rax,16
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je parse_operand_reg64
 cmp rax,32
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je parse_operand_reg8
 cmp rax,48
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je parse_operand_reg32
 sub rax,48
 mov rdx,6
 jmp parse_operand_regstore
parse_operand_reg32:
 sub rax,32
 mov rdx,5
 jmp parse_operand_regstore
parse_operand_reg8:
 sub rax,16
 mov rdx,2
 jmp parse_operand_regstore
parse_operand_reg64:
 mov rdx,1
parse_operand_regstore:
 mov [r15],rdx
 mov [r15+8],rax
 xor rax,rax
 mov [r15+16],rax
 mov [r15+24],rax
 mov [r15+32],rax
 mov [r15+40],rax
 mov [r15+48],rax
 mov rax,[r15+8]
 call store_operand_ir_node
 ret
parse_operand_cached_register:
 mov rsi,r8
 call skip_separators
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 mov rax,[rbx]
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x10
 db 0x48,0x81,0xe1,0xff,0,0,0
 add rsi,rcx
 mov r8,rsi
 mov rax,[rbx]
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x08
 db 0x48,0x81,0xe1,0xff,0,0,0
 mov [r15+8],rcx
 db 0x48,0x25,0xff,0,0,0
 mov [r15],rax
 xor rax,rax
 mov [r15+16],rax
 mov [r15+24],rax
 mov [r15+32],rax
 mov [r15+40],rax
 mov [r15+48],rax
 ret
parse_operand_cached_span:
 mov rsi,r8
 call skip_separators
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 mov rax,[rbx]
 mov rdx,rax
 db 0x48,0xc1,0xea,0x18
 db 0x89,0xd2
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x10
 db 0x48,0x81,0xe1,0xff,0,0,0
 mov rsi,line_buffer+IMAGE_VA
 add rsi,rdx
 mov rbx,diag_column+IMAGE_VA
 mov rax,rdx
 add rax,1
 mov [rbx],rax
 mov rdi,token_buffer+IMAGE_VA
 mov r10,rcx
parse_operand_cached_copy:
 cmp r10,0
 je parse_operand_cached_copy_done
 db 0x0f,0xb6,0x06
 db 0x88,0x07
 add rsi,1
 add rdi,1
 sub r10,1
 jmp parse_operand_cached_copy
parse_operand_cached_copy_done:
 xor rax,rax
 db 0x88,0x07
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 mov rax,[rbx]
 mov rdx,rax
 db 0x48,0xc1,0xea,0x18
 db 0x89,0xd2
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x10
 db 0x48,0x81,0xe1,0xff,0,0,0
 add rdx,rcx
 mov r8,line_buffer+IMAGE_VA
 add r8,rdx
 mov rax,[rbx]
 db 0x48,0x25,0xff,0,0,0
 cmp rax,3
 je parse_operand_cached_memory
 call get_current_expr_meta
 mov rax,[rbx]
 cmp rax,0
 je parse_operand_cached_immediate_fallback
 call eval_expression_ast
 mov [r15+16],rax
 mov rdx,4
 mov [r15],rdx
 xor rax,rax
 mov [r15+8],rax
 mov [r15+24],rax
 mov [r15+32],rax
 mov [r15+40],rax
 mov [r15+48],rax
 ret
parse_operand_cached_immediate_fallback:
 mov rsi,token_buffer+IMAGE_VA
 call expr_ast_prepare
 call parse_expr
 db 0x0f,0xb6,0x16
 cmp rdx,0
 jne syntax_error
 mov [r15+16],rax
 mov rdx,4
 mov [r15],rdx
 xor rax,rax
 mov [r15+8],rax
 mov [r15+24],rax
 mov [r15+32],rax
 mov [r15+40],rax
 mov [r15+48],rax
 ret
parse_operand_cached_memory:
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 mov rax,[rbx]
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x08
 db 0x48,0x81,0xe1,0xff,0,0,0
 mov [r15+8],rcx
 mov rcx,rax
 db 0x48,0xc1,0xe9,0x38
 db 0x48,0x81,0xe1,0xff,0,0,0
 mov rdx,rcx
 db 0x48,0x81,0xe2,0x0f,0,0,0
 mov [r15+32],rdx
 mov rdx,rcx
 db 0x48,0xc1,0xea,0x04
 db 0x48,0x83,0xe2,0x03
 mov [r15+40],rdx
 mov rdx,rcx
 db 0x48,0xc1,0xea,0x06
 db 0x48,0x83,0xe2,0x01
 mov [r15+48],rdx
 mov rdx,3
 mov [r15],rdx
 xor rax,rax
 mov [r15+16],rax
 xor rax,rax
 mov [r15+24],rax
 call get_current_expr_meta
 mov rax,[rbx]
 cmp rax,0
 je parse_operand_cached_memory_done
 call eval_expression_ast
 mov [r15+16],rax
 mov rdx,1
 mov [r15+24],rdx
parse_operand_cached_memory_done:
 ret
parse_operand_imm:
 mov rsi,token_buffer+IMAGE_VA
 call expr_ast_prepare
 call parse_expr
 db 0x0f,0xb6,0x16
 cmp rdx,0
 jne syntax_error
 mov [r15+16],rax
 mov rdx,4
 mov [r15],rdx
 xor rax,rax
 mov [r15+8],rax
 mov [r15+24],rax
 mov [r15+32],rax
 mov [r15+40],rax
 mov [r15+48],rax
 xor rax,rax
 call store_operand_ir_node
 ret
; Memory operand: [base], [base+disp], [base+index],
; [base+index*scale], [base+index*scale+disp].
; Operand slots +32=index, +40=scale encoding (0..3), +48=index-present.
parse_operand_mem:
 add rsi,1
 call read_reg
 cmp rax,16
 db 0x0f,0x93,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je syntax_error
 mov [r15+8],rax
 xor rax,rax
 mov [r15+16],rax
 mov [r15+24],rax
 mov [r15+32],rax
 mov [r15+40],rax
 mov [r15+48],rax
 db 0x0f,0xb6,0x16
 cmp rdx,93
 je parse_operand_mem_close
 cmp rdx,43
 je parse_operand_mem_plus
 cmp rdx,45
 je parse_operand_mem_disp
 jmp syntax_error
parse_operand_mem_plus:
 add rsi,1
 mov rbx,op_misc+IMAGE_VA
 mov [rbx+16],rsi
 call read_reg
 cmp rax,0-1
 je parse_operand_mem_disp_after_plus
 cmp rax,16
 db 0x0f,0x93,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je syntax_error
 cmp rax,4
 je syntax_error
 mov [r15+32],rax
 mov rax,1
 mov [r15+48],rax
 db 0x0f,0xb6,0x16
 cmp rdx,42
 jne parse_operand_mem_after_index
 add rsi,1
 db 0x0f,0xb6,0x16
 cmp rdx,49
 je parse_operand_mem_scale1
 cmp rdx,50
 je parse_operand_mem_scale2
 cmp rdx,52
 je parse_operand_mem_scale4
 cmp rdx,56
 je parse_operand_mem_scale8
 jmp syntax_error
parse_operand_mem_scale1:
 xor rax,rax
 jmp parse_operand_mem_scale_store
parse_operand_mem_scale2:
 mov rax,1
 jmp parse_operand_mem_scale_store
parse_operand_mem_scale4:
 mov rax,2
 jmp parse_operand_mem_scale_store
parse_operand_mem_scale8:
 mov rax,3
parse_operand_mem_scale_store:
 mov [r15+40],rax
 add rsi,1
parse_operand_mem_after_index:
 db 0x0f,0xb6,0x16
 cmp rdx,93
 je parse_operand_mem_close
 cmp rdx,43
 je parse_operand_mem_disp
 cmp rdx,45
 je parse_operand_mem_disp
 jmp syntax_error
parse_operand_mem_disp_after_plus:
 mov rbx,op_misc+IMAGE_VA
 mov rsi,[rbx+16]
 jmp parse_operand_mem_disp
parse_operand_mem_disp:
 call expr_ast_prepare
 call parse_expr
 mov [r15+16],rax
 mov rax,1
 mov [r15+24],rax
parse_operand_mem_close:
 db 0x0f,0xb6,0x16
 cmp rdx,93
 jne syntax_error
 add rsi,1
 db 0x0f,0xb6,0x16
 cmp rdx,0
 jne syntax_error
 mov rdx,3
 mov [r15],rdx
 xor rax,rax
 call store_operand_ir_node
 ret

; Derive the two 8-byte operand slots from the current statement IR index.
; Only main source-pass parsing sets ir_active; EQU replay remains uncached.
prepare_operand_ir_slot:
 mov rbx,operand_ir_slot+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,ir_active+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne prepare_operand_ir_done
 mov rbx,ir_cursor+IMAGE_VA
 mov rcx,[rbx]
 db 0x48,0xc1,0xe1,0x04
 mov rbx,typed_operand_ir+IMAGE_VA
 add rbx,rcx
 mov rax,r15
 cmp rax,op1+IMAGE_VA
 je prepare_operand_ir_store
 cmp rax,op2+IMAGE_VA
 jne prepare_operand_ir_done
 add rbx,8
prepare_operand_ir_store:
 mov rdi,operand_ir_slot+IMAGE_VA
 mov [rdi],rbx
prepare_operand_ir_done:
 ret

; RDX=kind, RAX=register index (zero for spans). Pack kind/reg/length/source
; column into one qword: 8/8/8/32 bits.
store_operand_ir_node:
 mov r10,rax
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rcx,[rbx]
 cmp rcx,0
 je store_operand_ir_done
 mov rax,[rcx]
 cmp rax,0
 jne store_operand_ir_done
 mov rbx,operand_token_length+IMAGE_VA
 mov rbx,[rbx]
 db 0x48,0xc1,0xe3,0x10
 db 0x48,0x09,0xda
 mov rbx,operand_source_offset+IMAGE_VA
 mov rbx,[rbx]
 db 0x48,0xc1,0xe3,0x18
 db 0x48,0x09,0xda
 mov rax,r10
 db 0x48,0xc1,0xe0,0x08
 db 0x48,0x09,0xc2
 mov rcx,rdx
 db 0x48,0x81,0xe1,0xff,0,0,0
 cmp rcx,3
 jne store_operand_ir_write
 mov rax,[r15+8]
 db 0x48,0xc1,0xe0,0x08
 db 0x48,0x09,0xc2
 mov rax,[r15+32]
 mov rcx,[r15+40]
 db 0x48,0xc1,0xe1,0x04
 db 0x48,0x09,0xc8
 mov rcx,[r15+48]
 db 0x48,0xc1,0xe1,0x06
 db 0x48,0x09,0xc8
 db 0x48,0xc1,0xe0,0x38
 db 0x48,0x09,0xc2
store_operand_ir_write:
 mov rbx,operand_ir_slot+IMAGE_VA
 mov rbx,[rbx]
 mov [rbx],rdx
store_operand_ir_done:
 ret

parse_two:
 mov rdi,op1+IMAGE_VA
 call parse_operand
 mov rdi,op2+IMAGE_VA
 call parse_operand
 mov rsi,r8
 call skip_spaces
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,0
 je parse_two_ok
 cmp rdx,59
 jne syntax_error
parse_two_ok:
 ret

; --- emitters ---
; emit_le: RBX=value, R11=byte count. Clobbers RAX,RSI,RDI,RBX,R11.
emit_le:
 mov rax,rbx
 call emit_byte
 db 0x48                         ; shr rbx,8
 db 0xc1, 0xeb, 0x08
 sub r11,1
 cmp r11,0
 jne emit_le
 ret

; emit_rr: legacy 64-bit register/register wrapper.
emit_rr:
 mov rbx,op_misc+IMAGE_VA
 mov rax,8
 mov [rbx+80],rax
 jmp emit_rr_width

; emit_rr8: legacy low-byte wrapper.
emit_rr8:
 mov rbx,op_misc+IMAGE_VA
 mov rax,1
 mov [rbx+80],rax
 jmp emit_rr_width

; emit_rr_width: R15=opcode, op_misc+80=width in bytes (1/2/4/8).
; ModR/M destination is op1 and source is op2. 66 precedes any REX prefix.
emit_rr_width:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r10,[rbx+8]
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+80]
 cmp rax,2
 jne emit_rr_width_rex
 mov rax,0x66
 call emit_byte
emit_rr_width_rex:
 mov r11,0x40
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+80]
 cmp rax,8
 jne emit_rr_width_reg_bits
 add r11,8
emit_rr_width_reg_bits:
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je emit_rr_width_src
 add r11,1
emit_rr_width_src:
 cmp r10,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je emit_rr_width_prefix_done
 add r11,4
emit_rr_width_prefix_done:
 cmp r11,0x40
 jne emit_rr_width_emit_rex
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+80]
 cmp rax,1
 jne emit_rr_width_opcode
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 jne emit_rr_width_force_rex
 cmp r10,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je emit_rr_width_opcode
emit_rr_width_force_rex:
 mov rax,0x40
 call emit_byte
 jmp emit_rr_width_opcode
emit_rr_width_emit_rex:
 mov rax,r11
 call emit_byte
emit_rr_width_opcode:
 mov rax,r15
 db 0x48,0x25,0x00,0x01,0x00,0x00
 cmp rax,0
 je emit_rr_width_opcode_byte
 mov rax,0x0f
 call emit_byte
 sub r15,0x100
emit_rr_width_opcode_byte:
 mov rax,r15
 call emit_byte
 db 0x49,0x83,0xe2,0x07
 db 0x49,0xc1,0xe2,0x03
 db 0x49,0x83,0xe1,0x07
 mov rax,r10
 add rax,r9
 add rax,0xc0
 call emit_byte
 ret

; emit_mem: RBX=memory operand, R9=register field, R15=opcode,
; R10=operand width in bytes (1/2/4/8). 64-bit addresses remain mandatory.
emit_mem:
 mov r11,[rbx+8]
 mov rdx,0x40
 cmp r10,8
 jne emit_mem_width_prefix
 mov rdx,0x48
emit_mem_width_prefix:
 cmp r10,2
 jne emit_mem_rex_bits
 mov rax,0x66
 call emit_byte
emit_mem_rex_bits:
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je emit_mem_reg_low
 add rdx,4
emit_mem_reg_low:
 cmp r11,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je emit_mem_base_low
 add rdx,1
emit_mem_base_low:
 mov rcx,[rbx+48]
 cmp rcx,1
 jne emit_mem_rex_no_index
 mov rcx,[rbx+32]
 cmp rcx,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je emit_mem_rex_no_index
 add rdx,2
emit_mem_rex_no_index:
 cmp rdx,0x40
 jne emit_mem_rex_emit
 cmp r10,1
 jne emit_mem_rex_skip
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je emit_mem_rex_skip
 mov rax,0x40
 call emit_byte
 jmp emit_mem_rex_skip
emit_mem_rex_emit:
 mov rax,rdx
 call emit_byte
emit_mem_rex_skip:
 mov rax,r15
 db 0x48,0x25,0x00,0x01,0x00,0x00
 cmp rax,0
 je emit_mem_one_byte_opcode
 mov rax,0x0f
 call emit_byte
 sub r15,0x100
emit_mem_one_byte_opcode:
 mov rax,r15
 call emit_byte
 db 0x49,0x83,0xe1,0x07
 db 0x49,0x83,0xe3,0x07
 db 0x49,0xc1,0xe1,0x03
 mov rdx,[rbx+24]
 db 0x48,0xf7,0xda             ; neg rdx
 mov rcx,[rbx+16]
 db 0x48,0x21,0xca             ; and rdx,rcx
 cmp rdx,0
 jne emit_mem_with_disp
 cmp r11,5
 je emit_mem_disp8_zero
 mov rax,[rbx+48]
 cmp rax,1
 je emit_mem_no_disp_sib
 cmp r11,4
 je emit_mem_no_disp_sib
 mov rax,r9
 add rax,r11
 call emit_byte
 ret
emit_mem_no_disp_sib:
 mov rax,r9
 add rax,4
 call emit_byte
 call emit_mem_sib
 ret
emit_mem_disp8_zero:
 mov rax,r9
 add rax,0x40
 mov rcx,[rbx+48]
 cmp rcx,1
 je emit_mem_disp8_sib
 add rax,r11
 call emit_byte
 xor rax,rax
 call emit_byte
 ret
emit_mem_disp8_sib:
 add rax,4
 call emit_byte
 call emit_mem_sib
 xor rax,rax
 call emit_byte
 ret
emit_mem_with_disp:
 mov rdx,[rbx+16]
 mov rax,rdx
 add rax,128
 db 0x48,0xc1,0xe8,0x08
 cmp rax,0
 jne emit_mem_disp32
 mov rax,r9
 add rax,0x40
 mov rcx,[rbx+48]
 cmp rcx,1
 je emit_mem_short_sib
 cmp r11,4
 je emit_mem_short_sib
 add rax,r11
 call emit_byte
 mov rax,rdx
 call emit_byte
 ret
emit_mem_short_sib:
 add rax,4
 call emit_byte
 call emit_mem_sib
 mov rax,rdx
 call emit_byte
 ret
emit_mem_disp32:
 mov rax,r9
 add rax,0x80
 mov rcx,[rbx+48]
 cmp rcx,1
 je emit_mem_disp_sib
 cmp r11,4
 jne emit_mem_disp_plain
emit_mem_disp_sib:
 add rax,4
 call emit_byte
 call emit_mem_sib
 jmp emit_mem_disp_bytes
emit_mem_disp_plain:
 add rax,r11
 call emit_byte
 jmp emit_mem_disp_bytes
; SIB = scale[1:0], index[2:0], base[2:0].
emit_mem_sib:
 mov rax,[rbx+40]
 db 0x48,0xc1,0xe0,0x06
 mov rcx,[rbx+48]
 cmp rcx,1
 jne emit_mem_sib_no_index
 mov rcx,[rbx+32]
 db 0x48,0x83,0xe1,0x07
 db 0x48,0xc1,0xe1,0x03
 add rax,rcx
 jmp emit_mem_sib_base
emit_mem_sib_no_index:
 add rax,0x20
emit_mem_sib_base:
 add rax,r11
 call emit_byte
 ret
emit_mem_disp_bytes:
 mov rdx,[rbx+16]
 mov rcx,0x80000000
 mov rax,rdx
 add rax,rcx
 db 0x48,0xc1,0xe8,0x20
 cmp rax,0
 jne range_error
 mov rbx,rdx
 mov r11,4
 call emit_le
 ret

; --- TEST: register/register and register/immediate forms ---
handle_test:
 ; Form 4 descriptor: opcode_rr at byte 4, opcode_imm at byte 5.
 db 0x0f,0xb6,0x43,4
 mov rdx,op_misc+IMAGE_VA
 mov [rdx],rax
 db 0x0f,0xb6,0x43,5
 mov [rdx+8],rax
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 mov rbx,op2+IMAGE_VA
 mov rdx,[rbx]
 cmp rax,3
 je test_dst_mem
 cmp rax,1
 je test_dst_r64
 cmp rax,2
 je test_dst_r8
 cmp rax,5
 je test_dst_r32
 cmp rax,6
 je test_dst_r16
 jmp syntax_error
test_dst_r64:
 cmp rdx,1
 je test_r64_r64
 cmp rdx,3
 je test_r64_mem
 cmp rdx,4
 je test_r64_imm
 jmp syntax_error
test_dst_r8:
 cmp rdx,2
 je test_r8_r8
 cmp rdx,3
 je test_r8_mem
 cmp rdx,4
 je test_r8_imm
 jmp syntax_error
test_dst_r32:
 cmp rdx,5
 je test_r32_r32
 cmp rdx,3
 je test_r32_mem
 cmp rdx,4
 je test_r32_imm
 jmp syntax_error
test_dst_r16:
 cmp rdx,6
 je test_r16_r16
 cmp rdx,3
 je test_r16_mem
 cmp rdx,4
 je test_r16_imm
 jmp syntax_error
test_r64_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,8
 mov r15,0x85
 jmp test_mem_emit
test_r8_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,1
 mov r15,0x84
 jmp test_mem_emit
test_r32_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,4
 mov r15,0x85
 jmp test_mem_emit
test_r16_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,2
 mov r15,0x85
 jmp test_mem_emit
test_dst_mem:
 cmp rdx,1
 je test_mem_dst_r64
 cmp rdx,2
 je test_mem_dst_r8
 cmp rdx,5
 je test_mem_dst_r32
 cmp rdx,6
 je test_mem_dst_r16
 jmp syntax_error
test_mem_dst_r64:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,8
 mov r15,0x85
 jmp test_mem_emit
test_mem_dst_r8:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,1
 mov r15,0x84
 jmp test_mem_emit
test_mem_dst_r32:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,4
 mov r15,0x85
 jmp test_mem_emit
test_mem_dst_r16:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,2
 mov r15,0x85
test_mem_emit:
 jmp emit_mem

test_r64_r64:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 jmp emit_rr
test_r32_r32:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 mov rbx,op_misc+IMAGE_VA
 mov rax,4
 mov [rbx+80],rax
 jmp emit_rr_width
test_r16_r16:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 mov rbx,op_misc+IMAGE_VA
 mov rax,2
 mov [rbx+80],rax
 jmp emit_rr_width
test_r8_r8:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 sub r15,1
 jmp emit_rr8
test_r8_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48, 0xc1, 0xe8, 0x08
 cmp rax,0
 je test_r8_imm_ok
 mov rax,r15
 add rax,128
 db 0x48, 0xc1, 0xe8, 0x08
 cmp rax,0
 jne syntax_error
test_r8_imm_ok:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x40
 cmp r9,8
 db 0x0f,0x92,0xc1
 cmp cl,1
 je test_r8_imm_force_check
 add rax,1
test_r8_imm_force_check:
 cmp rax,0x40
 jne test_r8_imm_emit_rex
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je test_r8_imm_opcode
test_r8_imm_emit_rex:
 call emit_byte
test_r8_imm_opcode:
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+8]
 sub rax,1
 call emit_byte
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 add rax,0xc0
 call emit_byte
 mov rax,r15
 call emit_byte
 ret
test_r64_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 mov rcx,0x80000000
 add rax,rcx
 db 0x48, 0xc1, 0xe8, 0x20
 cmp rax,0
 jne syntax_error
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x48
 cmp r9,8
 db 0x0f, 0x92, 0xc1
 db 0x0f, 0xb6, 0xc9
 cmp rcx,1
 je test_r64_rex_ready
 add rax,1
test_r64_rex_ready:
 call emit_byte
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+8]
 call emit_byte
 mov rax,r9
 db 0x48, 0x83, 0xe0, 0x07
 add rax,0xc0
 call emit_byte
 mov rbx,r15
 mov r11,4
 call emit_le
 ret
test_r32_imm:
 mov r10,4
 jmp test_gpr_imm
test_r16_imm:
 mov r10,2
test_gpr_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 call validate_gpr_immediate_width
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 cmp r10,2
 jne test_gpr_imm_rex
 mov rax,0x66
 call emit_byte
test_gpr_imm_rex:
 mov rax,r9
 db 0x48,0x83,0xe0,0x08
 cmp rax,0
 je test_gpr_imm_opcode
 mov rax,0x41
 call emit_byte
test_gpr_imm_opcode:
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+8]
 call emit_byte
 mov rax,r9
 db 0x48, 0x83, 0xe0, 0x07
 add rax,0xc0
 call emit_byte
 mov rbx,r15
 mov r11,r10
 call emit_le
 ret

; --- DB byte-list ---
handle_db:
 ; The table's opcode-length byte stores the data element width (1/2/4/8).
 mov rsi,rbx
 add rsi,3
 db 0x0f, 0xb6, 0x06
 mov rdx,op_misc+IMAGE_VA
 mov [rdx+72],rax
 mov rsi,r8
 call skip_spaces
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 je syntax_error
 cmp rdx,44
 je syntax_error
 cmp rdx,59
 je syntax_error
 mov r8,rsi
handle_db_next:
 mov rsi,r8
 call prepare_generic_expr_ast
 mov rsi,r8
 call parse_token
 cmp rax,0
 je syntax_error
 mov r8,rsi
 mov rsi,token_buffer+IMAGE_VA
 call parse_expr_generic
 mov r15,rax
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 jne syntax_error
 call handle_data_emit
 mov rsi,r8
 call skip_spaces
 db 0x0f, 0xb6, 0x16
 cmp rdx,44
 je handle_db_more
 cmp rdx,0
 je process_done
 cmp rdx,59
 jne syntax_error
 ret
handle_db_more:
 add rsi,1
 call skip_spaces
 db 0x0f, 0xb6, 0x16
 cmp rdx,0
 je syntax_error
 cmp rdx,44
 je syntax_error
 cmp rdx,59
 je syntax_error
 mov r8,rsi
 jmp handle_db_next

; Validate an unsigned scalar for its declared width, then emit little-endian.
; Values are never silently truncated to fit DW/DD; DQ accepts every u64 bit pattern.
handle_data_emit:
 mov rdx,op_misc+IMAGE_VA
 mov rcx,[rdx+72]
 mov rax,r15
 cmp rcx,1
 je handle_data_check8
 cmp rcx,2
 je handle_data_check16
 cmp rcx,4
 je handle_data_check32
 jmp handle_data_write
handle_data_check8:
 db 0x48, 0xc1, 0xe8, 0x08
 cmp rax,0
 jne range_error
 jmp handle_data_write
handle_data_check16:
 db 0x48, 0xc1, 0xe8, 0x10
 cmp rax,0
 jne range_error
 jmp handle_data_write
handle_data_check32:
 db 0x48, 0xc1, 0xe8, 0x20
 cmp rax,0
 jne range_error
handle_data_write:
 mov rbx,r15
 mov rdx,op_misc+IMAGE_VA
 mov r11,[rdx+72]
 call emit_le
 ret

; --- name EQU expr ---
handle_equ:
 call validate_symbol_name
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,name_buffer+IMAGE_VA
handle_equ_copy:
 db 0x0f                         ; movzx eax,byte [rsi]
 db 0xb6, 0x06
 mov [rdi],al
 cmp rax,0
 je handle_equ_copied
 add rsi,1
 add rdi,1
 jmp handle_equ_copy
handle_equ_copied:
 mov rsi,r8
 call skip_separators
 call parse_token
 cmp rax,0
 je syntax_error
 mov r8,rsi
 mov rsi,token_buffer+IMAGE_VA
 mov rdi,lit_equ+IMAGE_VA
 call string_equal
 cmp rax,1
 jne syntax_error
 mov rsi,r8
 call skip_separators
 call prepare_generic_expr_ast
 call parse_token
 cmp rax,0
 je syntax_error
 mov r8,rsi
 mov rbx,equ_graph_capture+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 jne handle_equ_owner_ready
 mov rsi,name_buffer+IMAGE_VA
 call find_symbol
 mov rbx,equ_graph_owner+IMAGE_VA
 mov rdx,symbol_found_index+IMAGE_VA
 mov rdx,[rdx]
 mov [rbx],rdx
handle_equ_owner_ready:
 mov rdx,expr_unresolved+IMAGE_VA
 xor rax,rax
 mov [rdx],rax
 mov rsi,token_buffer+IMAGE_VA
 call parse_expr_generic
 mov r15,rax
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,0
 jne syntax_error
 mov rsi,r8
 call skip_spaces
 db 0x0f                         ; movzx edx,byte [rsi]
 db 0xb6, 0x16
 cmp rdx,0
 je handle_equ_trail_ok
 cmp rdx,59
 jne syntax_error
handle_equ_trail_ok:
 mov rsi,name_buffer+IMAGE_VA
 call find_symbol
 cmp rax,0
 je handle_equ_new
 mov rbx,rax
 mov rdx,[rbp+0]
 cmp rdx,0
 jne handle_equ_existing
 mov rbx,diag_symbol_column+IMAGE_VA
 mov rax,[rbx]
 mov rbx,diag_column+IMAGE_VA
 mov [rbx],rax
 jmp duplicate_symbol_error
handle_equ_existing:
 mov rdx,[rbx+64]
 cmp rdx,r15
 je handle_equ_status
 mov [rbx+64],r15
 mov rdx,[rbp+0]
 cmp rdx,2
 jne handle_equ_status
 mov rdx,1
 mov rsi,equ_changed+IMAGE_VA
 mov [rsi],rdx
handle_equ_status:
 mov rsi,expr_unresolved+IMAGE_VA
 mov rdx,[rsi]
 cmp rdx,0
 je handle_equ_resolved
 mov rdx,2
 jmp handle_equ_set_status
handle_equ_resolved:
 mov rdx,3
handle_equ_set_status:
 mov rcx,[rbx+72]
 cmp rcx,rdx
 je handle_equ_done
 mov [rbx+72],rdx
 mov rdx,[rbp+0]
 cmp rdx,2
 jne handle_equ_done
 mov rdx,1
 mov rsi,equ_changed+IMAGE_VA
 mov [rsi],rdx
handle_equ_done:
 ret
handle_equ_new:
 mov rdx,[rbp+0]
 cmp rdx,0
 jne syntax_error
 mov rsi,name_buffer+IMAGE_VA
 mov rdx,r15
 call add_symbol
 mov rsi,name_buffer+IMAGE_VA
 call find_symbol
 mov rsi,expr_unresolved+IMAGE_VA
 mov rdx,[rsi]
 cmp rdx,0
 je handle_equ_new_resolved
 mov rdx,2
 jmp handle_equ_new_status
handle_equ_new_resolved:
 mov rdx,3
handle_equ_new_status:
 mov [rax+72],rdx
 ; Store the source line so the resolver can revisit EQU declarations
 ; in reverse order without copying expressions or reparsing unrelated lines.
 mov rcx,[rbp+16]
 sub rcx,1
 db 0x48,0xc1,0xe1,0x03
 mov rbx,equ_line_ptrs+IMAGE_VA
 add rbx,rcx
 mov rdx,line_source_pointer+IMAGE_VA
 mov rdx,[rdx]
 mov [rbx],rdx
 mov rbx,equ_line_numbers+IMAGE_VA
 add rbx,rcx
 mov rdx,line_source_number+IMAGE_VA
 mov rdx,[rdx]
 mov [rbx],rdx
 ret

; --- MOV: r8/r16/r32/r64 register, immediate and memory forms ---
handle_mov:
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 mov rbx,op2+IMAGE_VA
 mov rdx,[rbx]
 cmp rax,1
 je mov_dst_r64
 cmp rax,2
 je mov_dst_r8
 cmp rax,5
 je mov_dst_r32
 cmp rax,6
 je mov_dst_r16
 cmp rax,3
 je mov_dst_mem
 jmp syntax_error
mov_dst_r64:
 cmp rdx,4
 je mov_r64_imm
 cmp rdx,1
 je mov_r64_r64
 cmp rdx,3
 je mov_r64_mem
 jmp syntax_error
mov_dst_r8:
 cmp rdx,4
 je mov_r8_imm
 cmp rdx,2
 je mov_r8_r8
 cmp rdx,3
 je mov_r8_mem
 jmp syntax_error
mov_dst_r32:
 cmp rdx,4
 je mov_r32_imm
 cmp rdx,5
 je mov_r32_r32
 cmp rdx,3
 je mov_r32_mem
 jmp syntax_error
mov_dst_r16:
 cmp rdx,4
 je mov_r16_imm
 cmp rdx,6
 je mov_r16_r16
 cmp rdx,3
 je mov_r16_mem
 jmp syntax_error
mov_dst_mem:
 cmp rdx,1
 je mov_mem_r64
 cmp rdx,2
 je mov_mem_r8
 cmp rdx,5
 je mov_mem_r32
 cmp rdx,6
 je mov_mem_r16
 jmp syntax_error

mov_r64_r64:
 mov r15,0x89
 jmp emit_rr
mov_r32_r32:
 mov r15,0x89
 mov rbx,op_misc+IMAGE_VA
 mov rax,4
 mov [rbx+80],rax
 jmp emit_rr_width
mov_r16_r16:
 mov r15,0x89
 mov rbx,op_misc+IMAGE_VA
 mov rax,2
 mov [rbx+80],rax
 jmp emit_rr_width
mov_r64_mem:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,0x8b
 mov r10,8
 jmp emit_mem
mov_mem_r64:
 mov rbx,op2+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op1+IMAGE_VA
 mov r15,0x89
 mov r10,8
 jmp emit_mem
mov_r8_r8:
 mov r15,0x88
 jmp emit_rr8
mov_r8_mem:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,0x8a
 mov r10,1
 jmp emit_mem
mov_mem_r8:
 mov rbx,op2+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op1+IMAGE_VA
 mov r15,0x88
 mov r10,1
 jmp emit_mem
mov_r32_mem:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,0x8b
 mov r10,4
 jmp emit_mem
mov_mem_r32:
 mov rbx,op2+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op1+IMAGE_VA
 mov r15,0x89
 mov r10,4
 jmp emit_mem
mov_r16_mem:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,0x8b
 mov r10,2
 jmp emit_mem
mov_mem_r16:
 mov rbx,op2+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op1+IMAGE_VA
 mov r15,0x89
 mov r10,2
 jmp emit_mem
mov_r8_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 ; Accept unsigned byte values 0..255 and signed byte values -128..-1.
 ; Adding 128 maps exactly this union into the unsigned interval 0..383.
 mov rax,r15
 add rax,128
 cmp rax,384
 db 0x48,0x19,0xc9             ; sbb rcx,rcx: -1 when below 384, else 0
 cmp rcx,0
 je range_error
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x40
 cmp r9,8
 db 0x0f,0x92,0xc1
 cmp cl,1
 je mov_r8_imm_force_check
 add rax,1
mov_r8_imm_force_check:
 cmp rax,0x40
 jne mov_r8_imm_emit_rex
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je mov_r8_imm_opcode
mov_r8_imm_emit_rex:
 call emit_byte
mov_r8_imm_opcode:
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 add rax,0xb0
 call emit_byte
 mov rax,r15
 call emit_byte
 ret
mov_r32_imm:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48,0xc1,0xe8,0x20
 cmp rax,0
 je mov_r32_imm_range_ok
 mov rcx,0xffffffff
 cmp rax,rcx
 jne range_error
 mov rax,r15
 db 0x48,0xc1,0xe8,0x1f
 db 0x48,0x83,0xe0,0x01
 cmp rax,1
 jne range_error
mov_r32_imm_range_ok:
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je mov_r32_imm_opcode
 mov rax,0x41
 call emit_byte
mov_r32_imm_opcode:
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 add rax,0xb8
 call emit_byte
 mov rbx,r15
 mov r11,4
 call emit_le
 ret
mov_r16_imm:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48,0xc1,0xe8,0x10
 cmp rax,0
 je mov_r16_imm_range_ok
 mov rcx,0xffffffffffff
 cmp rax,rcx
 jne range_error
 mov rax,r15
 db 0x48,0xc1,0xe8,0x0f
 db 0x48,0x83,0xe0,0x01
 cmp rax,1
 jne range_error
mov_r16_imm_range_ok:
 mov rax,0x66
 call emit_byte
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je mov_r16_imm_opcode
 mov rax,0x41
 call emit_byte
mov_r16_imm_opcode:
 mov rax,r9
 db 0x48,0x83,0xe0,0x07
 add rax,0xb8
 call emit_byte
 mov rbx,r15
 mov r11,2
 call emit_le
 ret
mov_r64_imm:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov r10,0x48
 cmp r9,8
 db 0x0f,0x92,0xc1
 db 0x0f,0xb6,0xc9
 cmp rcx,1
 je mov_imm_low
 add r10,1
mov_imm_low:
 mov r11,r9
 db 0x49,0x83,0xe3,0x07
 mov rax,r15
 db 0x48,0xc1,0xe8,0x1f
 cmp rax,0
 je mov_imm32
 mov rcx,0x1ffffffff
 cmp rax,rcx
 je mov_imm32
 jmp mov_imm64
mov_imm32:
 mov rax,r10
 call emit_byte
 mov rax,0xc7
 call emit_byte
 mov rax,r11
 add rax,0xc0
 call emit_byte
 mov rbx,r15
 mov r11,4
 call emit_le
 ret
mov_imm64:
 mov rax,r10
 call emit_byte
 mov rax,r11
 add rax,0xb8
 call emit_byte
 mov rbx,r15
 mov r11,8
 call emit_le
 ret

; --- Declarative ALU GPR encoding descriptor (ISA form 3) ---
; Current ISA record: byte 4 = register/register opcode, byte 5 = ModR/M /digit.
; The shared handler owns operand validation and width-specific encoding only.
handle_alu:
 db 0x0f,0xb6,0x43,4
 mov rdx,op_misc+IMAGE_VA
 mov [rdx],rax
 db 0x0f,0xb6,0x43,5
 mov [rdx+8],rax
 call parse_two
 mov rbx,op1+IMAGE_VA
 mov rax,[rbx]
 mov rbx,op2+IMAGE_VA
 mov rdx,[rbx]
 cmp rax,3
 je alu_dst_mem
 cmp rax,1
 jne alu_dst_not_r64
 cmp rdx,1
 je alu_rr
 cmp rdx,3
 je alu_r64_mem
 cmp rdx,4
 je alu_r64_imm
 jmp syntax_error
alu_dst_not_r64:
 cmp rax,2
 jne alu_dst_not_r8
 cmp rdx,2
 je alu_rr8
 cmp rdx,3
 je alu_r8_mem
 cmp rdx,4
 je alu_r8_imm
 jmp syntax_error
alu_dst_not_r8:
 cmp rax,5
 je alu_dst_r32
 cmp rax,6
 je alu_dst_r16
 jmp syntax_error
alu_dst_r32:
 cmp rdx,5
 je alu_rr32
 cmp rdx,3
 je alu_r32_mem
 cmp rdx,4
 je alu_r32_imm
 jmp syntax_error
alu_dst_r16:
 cmp rdx,6
 je alu_rr16
 cmp rdx,3
 je alu_r16_mem
 cmp rdx,4
 je alu_r16_imm
 jmp syntax_error
; Register destination / memory source: opcode base + 2 (or +1 for r8).
alu_r64_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,8
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 add r15,2
 jmp alu_mem_emit
alu_r8_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,1
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 add r15,1
 jmp alu_mem_emit
alu_r32_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,4
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 add r15,2
 jmp alu_mem_emit
alu_r16_mem:
 mov rbx,op2+IMAGE_VA
 mov r11,op1+IMAGE_VA
 mov r9,[r11+8]
 mov r10,2
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 add r15,2
 jmp alu_mem_emit
; Memory destination / register source: opcode base (or base - 1 for r8).
alu_dst_mem:
 cmp rdx,1
 je alu_mem_dst_r64
 cmp rdx,2
 je alu_mem_dst_r8
 cmp rdx,5
 je alu_mem_dst_r32
 cmp rdx,6
 je alu_mem_dst_r16
 jmp syntax_error
alu_mem_dst_r64:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,8
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 jmp alu_mem_emit
alu_mem_dst_r8:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,1
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 sub r15,1
 jmp alu_mem_emit
alu_mem_dst_r32:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,4
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
 jmp alu_mem_emit
alu_mem_dst_r16:
 mov rbx,op1+IMAGE_VA
 mov r11,op2+IMAGE_VA
 mov r9,[r11+8]
 mov r10,2
 mov r11,op_misc+IMAGE_VA
 mov r15,[r11]
alu_mem_emit:
 jmp emit_mem

alu_rr:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 jmp emit_rr
alu_rr8:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 sub r15,1
 jmp emit_rr8
alu_rr32:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 mov rax,4
 mov [rbx+80],rax
 jmp emit_rr_width
alu_rr16:
 mov rbx,op_misc+IMAGE_VA
 mov r15,[rbx]
 mov rax,2
 mov [rbx+80],rax
 jmp emit_rr_width
alu_r8_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rax,r15
 db 0x48                         ; shr rax,8
 db 0xc1, 0xe8, 0x08
 cmp rax,0
 je alu_r8_imm_ok
 mov rax,r15
 add rax,128
 db 0x48                         ; shr rax,8
 db 0xc1, 0xe8, 0x08
 cmp rax,0
 jne syntax_error
alu_r8_imm_ok:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov rax,0x40
 cmp r9,8
 db 0x0f,0x92,0xc1
 cmp cl,1
 je alu_r8_imm_force_check
 add rax,1
alu_r8_imm_force_check:
 cmp rax,0x40
 jne alu_r8_imm_emit_rex
 cmp r9,4
 db 0x0f,0x92,0xc1
 cmp cl,1
 je alu_r8_imm_opcode
alu_r8_imm_emit_rex:
 call emit_byte
alu_r8_imm_opcode:
 mov rax,0x80
 call emit_byte
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+8]
 db 0x48                         ; shl rax,3
 db 0xc1, 0xe0, 0x03
 mov rdx,r9
 db 0x48,0x83,0xe2,0x07
 add rax,rdx
 add rax,0xc0
 call emit_byte
 mov rax,r15
 call emit_byte
 ret
alu_r64_imm:
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 mov r10,0x48
 cmp r9,8
 ; jb alu_imm_low (expanded)
 db 0x0f                         ; setb cl
 db 0x92, 0xc1
 db 0x0f                         ; movzx ecx,cl
 db 0xb6, 0xc9
 cmp rcx,1
 je alu_imm_low
 add r10,1
alu_imm_low:
 mov r11,r9
 db 0x49                         ; and r11,7
 db 0x83, 0xe3, 0x07
 mov rbx,op_misc+IMAGE_VA
 mov rdx,[rbx+8]
 db 0x48                         ; shl rdx,3
 db 0xc1, 0xe2, 0x03
 add rdx,r11
 add rdx,0xc0
 mov rax,r15
 add rax,128
 db 0x48                         ; shr rax,8
 db 0xc1, 0xe8, 0x08
 cmp rax,0
 jne alu_imm32
 mov rax,r10
 call emit_byte
 mov rax,0x83
 call emit_byte
 mov rax,rdx
 call emit_byte
 mov rax,r15
 call emit_byte
 ret
alu_imm32:
 mov rcx,0x80000000
 mov rax,r15
 add rax,rcx
 db 0x48                         ; shr rax,32
 db 0xc1, 0xe8, 0x20
 cmp rax,0
 jne syntax_error
 mov rax,r10
 call emit_byte
 mov rax,0x81
 call emit_byte
 mov rax,rdx
 call emit_byte
 mov rbx,r15
 mov r11,4
 call emit_le
 ret
alu_r32_imm:
 mov rbx,op_misc+IMAGE_VA
 mov rax,4
 mov [rbx+80],rax
 jmp alu_gpr_imm
alu_r16_imm:
 mov rbx,op_misc+IMAGE_VA
 mov rax,2
 mov [rbx+80],rax
alu_gpr_imm:
 mov rbx,op_misc+IMAGE_VA
 mov r10,[rbx+80]
 mov rbx,op2+IMAGE_VA
 mov r15,[rbx+16]
 call validate_gpr_immediate_width
 mov rax,r15
 add rax,128
 db 0x48,0xc1,0xe8,0x08
 cmp rax,0
 je alu_gpr_imm_short
 ; The alternate width-pattern shortcut is valid only for a negative byte.
 ; Without bit 7 set, 0xFF00..0xFF7F / 0xFFFFFF00..0xFFFFFF7F
 ; would be truncated to a different positive imm8 value.
 mov rax,r15
 db 0x48,0xc1,0xe8,0x07
 db 0x48,0x83,0xe0,0x01
 cmp rax,1
 jne alu_gpr_imm_full
 cmp r10,2
 jne alu_gpr_imm_short32_check
 mov rax,r15
 db 0x48,0xc1,0xe8,0x08
 cmp rax,0xff
 je alu_gpr_imm_short
 jmp alu_gpr_imm_full
alu_gpr_imm_short32_check:
 mov rax,r15
 db 0x48,0xc1,0xe8,0x08
 mov rcx,-1
 db 0x48,0xc1,0xe9,0x28
 cmp rax,rcx
 je alu_gpr_imm_short
alu_gpr_imm_full:
 mov r11,r10
 jmp emit_alu_gpr_imm
alu_gpr_imm_short:
 mov r11,1
emit_alu_gpr_imm:
 mov rbx,op1+IMAGE_VA
 mov r9,[rbx+8]
 cmp r10,2
 jne emit_alu_gpr_imm_rex
 mov rax,0x66
 call emit_byte
emit_alu_gpr_imm_rex:
 mov rax,r9
 db 0x48,0x83,0xe0,0x08
 cmp rax,0
 je emit_alu_gpr_imm_opcode
 mov rax,0x41
 call emit_byte
emit_alu_gpr_imm_opcode:
 mov rax,0x81
 cmp r11,1
 jne emit_alu_gpr_imm_opcode_ready
 mov rax,0x83
emit_alu_gpr_imm_opcode_ready:
 call emit_byte
 mov rbx,op_misc+IMAGE_VA
 mov rax,[rbx+8]
 db 0x48,0xc1,0xe0,0x03
 mov rcx,r9
 db 0x48,0x83,0xe1,0x07
 add rax,rcx
 add rax,0xc0
 call emit_byte
 mov rbx,r15
 call emit_le
 ret

; Accept either a zero-extended unsigned immediate or a sign-extended negative
; value for the selected 16/32-bit operand width. R10=2/4, R15=value.
validate_gpr_immediate_width:
 cmp r10,2
 jne validate_gpr_immediate_32
 mov rax,r15
 db 0x48,0xc1,0xe8,0x10
 cmp rax,0
 je validate_gpr_immediate_ok
 mov rcx,-1
 db 0x48,0xc1,0xe9,0x10
 cmp rax,rcx
 jne range_error
 mov rax,r15
 db 0x48,0xc1,0xe8,0x0f
 db 0x48,0x83,0xe0,0x01
 cmp rax,1
 jne range_error
 ret
validate_gpr_immediate_32:
 mov rax,r15
 db 0x48,0xc1,0xe8,0x20
 cmp rax,0
 je validate_gpr_immediate_ok
 mov rcx,-1
 db 0x48,0xc1,0xe9,0x20
 cmp rax,rcx
 jne range_error
 mov rax,r15
 db 0x48,0xc1,0xe8,0x1f
 db 0x48,0x83,0xe0,0x01
 cmp rax,1
 jne range_error
validate_gpr_immediate_ok:
 ret

lit_db:
db 100,98,0
lit_dw:
db 100,119,0
lit_dd:
db 100,100,0
lit_dq:
db 100,113,0
lit_nop:
db 110,111,112,0
lit_ret:
db 114,101,116,0
lit_syscall:
db 115,121,115,99,97,108,108,0
lit_mov:
db 109,111,118,0
lit_add:
db 97,100,100,0
lit_sub:
db 115,117,98,0
lit_xor:
db 120,111,114,0
lit_cmp:
db 99,109,112,0
lit_jmp:
db 106,109,112,0
lit_call:
db 99,97,108,108,0
lit_je:
db 106,101,0
lit_jne:
db 106,110,101,0
lit_jz:
db 106,122,0
lit_jnz:
db 106,110,122,0
lit_or:
db 111,114,0
lit_and:
db 97,110,100,0
lit_adc:
db 97,100,99,0
lit_sbb:
db 115,98,98,0
lit_test:
db 116,101,115,116,0
lit_lea:
db 108,101,97,0
lit_xchg:
db 120,99,104,103,0
lit_push:
db 112,117,115,104,0
lit_pop:
db 112,111,112,0
lit_inc:
db 105,110,99,0
lit_dec:
db 100,101,99,0
lit_not:
db 110,111,116,0
lit_neg:
db 110,101,103,0
lit_shl:
db 115,104,108,0
lit_shr:
db 115,104,114,0
lit_sar:
db 115,97,114,0
lit_rol:
db 114,111,108,0
lit_ror:
db 114,111,114,0
lit_rcl:
db 114,99,108,0
lit_rcr:
db 114,99,114,0
lit_bswap:
db 98,115,119,97,112,0
lit_bt:
db 98,116,0
lit_bts:
db 98,116,115,0
lit_btr:
db 98,116,114,0
lit_btc:
db 98,116,99,0
lit_movzx:
db 109,111,118,122,120,0
lit_movsx:
db 109,111,118,115,120,0
lit_mul:
db 109,117,108,0
lit_imul:
db 105,109,117,108,0
lit_div:
db 100,105,118,0
lit_idiv:
db 105,100,105,118,0
lit_jo:
db 106,111,0
lit_jno:
db 106,110,111,0
lit_jb:
db 106,98,0
lit_jae:
db 106,97,101,0
lit_jbe:
db 106,98,101,0
lit_ja:
db 106,97,0
lit_js:
db 106,115,0
lit_jns:
db 106,110,115,0
lit_jp:
db 106,112,0
lit_jnp:
db 106,110,112,0
lit_jl:
db 106,108,0
lit_jge:
db 106,103,101,0
lit_jle:
db 106,108,101,0
lit_jg:
db 106,103,0

; ISA records: mnemonic, handler, form, metadata and descriptor.
; Data form 0 uses metadata as DB/DW/DD/DQ element width; instruction form 1 is fixed opcode bytes.
; Form 2 is one r64 register encoded as opcode+rd; form 3 is ALU (rr opcode, ModR/M /digit);
; form 4 is TEST (rr opcode, immediate opcode); form 5 is a label branch (near/short pair).
isa_table:
db (lit_db-lit_db+1)&255,1,0,1,0,0,2,8
db (lit_dw-lit_db+1)&255,1,0,2,0,0,2,8
db (lit_dd-lit_db+1)&255,1,0,4,0,0,2,8
db (lit_dq-lit_db+1)&255,1,0,8,0,0,2,8
; nop / ret / syscall share one generic validator and metadata-driven encoder.
db (lit_nop-lit_db+1)&255,27,1,1,0x90,0,1,1
db (lit_ret-lit_db+1)&255,27,1,1,0xc3,0,1,1
db (lit_syscall-lit_db+1)&255,27,1,2,0x0f,0x05,1,1
; Remaining instruction forms are transitional handler-backed records.
db (lit_mov-lit_db+1)&255,5,0,0,0,0,0,0
db (lit_add-lit_db+1)&255,39,3,2,0x01,0,3,3
db (lit_sub-lit_db+1)&255,39,3,2,0x29,5,3,3
db (lit_xor-lit_db+1)&255,39,3,2,0x31,6,3,3
db (lit_cmp-lit_db+1)&255,39,3,2,0x39,7,3,3
db (lit_jmp-lit_db+1)&255,10,5,2,0xe9,0xeb,4,5
db (lit_call-lit_db+1)&255,11,7,1,0xe8,0,4,7
; Form 5 is a label branch; form 6 is a one-register Group-3 opcode/extension descriptor.
db (lit_jo-lit_db+1)&255,40,5,2,0x80,0x70,4,5
db (lit_jno-lit_db+1)&255,40,5,2,0x81,0x71,4,5
db (lit_jb-lit_db+1)&255,40,5,2,0x82,0x72,4,5
db (lit_jae-lit_db+1)&255,40,5,2,0x83,0x73,4,5
db (lit_je-lit_db+1)&255,40,5,2,0x84,0x74,4,5
db (lit_jne-lit_db+1)&255,40,5,2,0x85,0x75,4,5
db (lit_jbe-lit_db+1)&255,40,5,2,0x86,0x76,4,5
db (lit_ja-lit_db+1)&255,40,5,2,0x87,0x77,4,5
db (lit_js-lit_db+1)&255,40,5,2,0x88,0x78,4,5
db (lit_jns-lit_db+1)&255,40,5,2,0x89,0x79,4,5
db (lit_jp-lit_db+1)&255,40,5,2,0x8a,0x7a,4,5
db (lit_jnp-lit_db+1)&255,40,5,2,0x8b,0x7b,4,5
db (lit_jl-lit_db+1)&255,40,5,2,0x8c,0x7c,4,5
db (lit_jge-lit_db+1)&255,40,5,2,0x8d,0x7d,4,5
db (lit_jle-lit_db+1)&255,40,5,2,0x8e,0x7e,4,5
db (lit_jg-lit_db+1)&255,40,5,2,0x8f,0x7f,4,5
db (lit_jz-lit_db+1)&255,40,5,2,0x84,0x74,4,5
db (lit_jnz-lit_db+1)&255,40,5,2,0x85,0x75,4,5
db (lit_or-lit_db+1)&255,39,3,2,0x09,1,3,3
db (lit_and-lit_db+1)&255,39,3,2,0x21,4,3,3
db (lit_adc-lit_db+1)&255,39,3,2,0x11,2,3,3
db (lit_sbb-lit_db+1)&255,39,3,2,0x19,3,3,3
db (lit_test-lit_db+1)&255,18,4,2,0x85,0xf7,3,4
db (lit_lea-lit_db+1)&255,19,0,0,0,0,0,0
db (lit_xchg-lit_db+1)&255,20,0,0,0,0,0,0
db (lit_push-lit_db+1)&255,21,2,1,0x50,0,6,2
db (lit_pop-lit_db+1)&255,22,2,1,0x58,0,6,2
db (lit_inc-lit_db+1)&255,23,0,0,0,0,0,0
db (lit_dec-lit_db+1)&255,24,0,0,0,0,0,0
db (lit_not-lit_db+1)&255,25,0,0,0,0,0,0
db (lit_neg-lit_db+1)&255,26,0,0,0,0,0,0
db (lit_shl-lit_db+1)&255,28,0,0,0,0,0,0
db (lit_shr-lit_db+1)&255,29,0,0,0,0,0,0
db (lit_sar-lit_db+1)&255,30,0,0,0,0,0,0
db (lit_rol-lit_db+1)&255,31,0,0,0,0,0,0
db (lit_ror-lit_db+1)&255,32,0,0,0,0,0,0
db (lit_rcl-lit_db+1)&255,33,0,0,0,0,0,0
db (lit_rcr-lit_db+1)&255,34,0,0,0,0,0,0
db (lit_bswap-lit_db+1)&255,35,0,0,0,0,0,0
db (lit_movzx-lit_db+1)&255,36,0,0,0,0,0,0
db (lit_movsx-lit_db+1)&255,37,0,0,0,0,0,0
; Group-3 multiply/divide operation extensions: MUL /4, IMUL /5, DIV /6, IDIV /7.
db (lit_mul-lit_db+1)&255,38,6,2,0xf6,4,5,6
db (lit_imul-lit_db+1)&255,38,6,2,0xf6,5,5,6
db (lit_div-lit_db+1)&255,38,6,2,0xf6,6,5,6
db (lit_idiv-lit_db+1)&255,38,6,2,0xf6,7,5,6
; Bit operations: register-index uses 0F A3/AB/B3/BB; immediate register form uses 0F BA /4..7 ib.
db (lit_bt-lit_db+1)&255,41,0,0,0xa3,4,0,0
db (lit_bts-lit_db+1)&255,41,0,0,0xab,5,0,0
db (lit_btr-lit_db+1)&255,41,0,0,0xb3,6,0,0
db (lit_btc-lit_db+1)&255,41,0,0,0xbb,7,0,0
; Zero first field terminates the registry.
db 0,0,0,0,0,0,0,0

; First-byte candidate index generated from the ordered ISA records.
db 89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89
db 89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89
db 89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89
db 89,89,89,89,89,89,89,89,89,89,89,89,89,0,4,10,13,20,21,22,23,24,28,48,49,51,56,60
db 62,65,66,72,79,81,82,83,84,87,88,89,89,89,89,89,8,33,34,255,52,59,60,61,62,255,11,13
db 255,0,1,2,3,42,57,255,255,255,255,255,41,56,58,255,12,14,15,16,17,18,19,20,21,22,23,24
db 25,26,27,28,29,30,31,255,255,37,255,7,53,54,55,255,4,43,44,255,32,255,39,40,255,255,5,48
db 49,50,51,255,6,9,35,45,46,47,255,36,255,255,255,255,10,38,255,255,255,255
condition_suffix_table:
db 111,0,0,110,111,1,98,0,2,97,101,3,101,0,4,110,101,5,98,101,6,97,0,7,115,0,8,110
db 115,9,112,0,10,110,112,11,108,0,12,103,101,13,108,101,14,103,0,15,122,0,4,110,122,5
condition_suffix_table_end:
lit_hex_digits:
db 48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102,0
lit_equ:
db 101,113,117,0
reg_table:
; r64 indices 0..15
; r8 indices 16..31: AL/CL/DL/BL, SPL/BPL/SIL/DIL, R8B..R15B
; r32 indices 32..47
; r16 indices 48..63
db 114,97,120,0,0,0,0,0,114,99,120,0,0,0,0,0,114,100,120,0,0,0,0,0,114,98,120,0
db 0,0,0,0,114,115,112,0,0,0,0,0,114,98,112,0,0,0,0,0,114,115,105,0,0,0,0,0
db 114,100,105,0,0,0,0,0,114,56,0,0,0,0,0,0,114,57,0,0,0,0,0,0,114,49,48,0
db 0,0,0,0,114,49,49,0,0,0,0,0,114,49,50,0,0,0,0,0,114,49,51,0,0,0,0,0
db 114,49,52,0,0,0,0,0,114,49,53,0,0,0,0,0,97,108,0,0,0,0,0,0,99,108,0,0
db 0,0,0,0,100,108,0,0,0,0,0,0,98,108,0,0,0,0,0,0,115,112,108,0,0,0,0,0
db 98,112,108,0,0,0,0,0,115,105,108,0,0,0,0,0,100,105,108,0,0,0,0,0,114,56,98,0
db 0,0,0,0,114,57,98,0,0,0,0,0,114,49,48,98,0,0,0,0,114,49,49,98,0,0,0,0
db 114,49,50,98,0,0,0,0,114,49,51,98,0,0,0,0,114,49,52,98,0,0,0,0,114,49,53,98
db 0,0,0,0,101,97,120,0,0,0,0,0,101,99,120,0,0,0,0,0,101,100,120,0,0,0,0,0
db 101,98,120,0,0,0,0,0,101,115,112,0,0,0,0,0,101,98,112,0,0,0,0,0,101,115,105,0
db 0,0,0,0,101,100,105,0,0,0,0,0,114,56,100,0,0,0,0,0,114,57,100,0,0,0,0,0
db 114,49,48,100,0,0,0,0,114,49,49,100,0,0,0,0,114,49,50,100,0,0,0,0,114,49,51,100
db 0,0,0,0,114,49,52,100,0,0,0,0,114,49,53,100,0,0,0,0,97,120,0,0,0,0,0,0
db 99,120,0,0,0,0,0,0,100,120,0,0,0,0,0,0,98,120,0,0,0,0,0,0,115,112,0,0
db 0,0,0,0,98,112,0,0,0,0,0,0,115,105,0,0,0,0,0,0,100,105,0,0,0,0,0,0
db 114,56,119,0,0,0,0,0,114,57,119,0,0,0,0,0,114,49,48,119,0,0,0,0,114,49,49,119
db 0,0,0,0,114,49,50,119,0,0,0,0,114,49,51,119,0,0,0,0,114,49,52,119,0,0,0,0
db 114,49,53,119,0,0,0,0
msg_input:
db 82,85,65,83,77,58,32,69,95,73,78,80,85,84,58,32,102,97,105,108,101,100,32,116,111,32,114,101
db 97,100,32,115,111,117,114,99,101,32,105,110,112,117,116,10
msg_input_end:
msg_syntax:
db 82,85,65,83,77,58,32,69,95,83,89,78,84,65,88,32,97,116,32,108,105,110,101,32
msg_syntax_end:
; Runtime state and label table for iterative symbol/layout fixups.
state_base:
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

db 0,0,0,0,0,0,0,0
input_buffer:
