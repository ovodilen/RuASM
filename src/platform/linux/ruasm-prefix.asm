IMAGE_VA equ 0x400000
; 196608 bits cover every line in the 196607-byte source limit.
BRANCH_MAP_QWORDS equ 3072
file_start:
db 127,69,76,70,2,1,1,0,0,0,0,0,0,0,0,0,2,0,62,0,1,0,0,0
db ((cli_start-file_start+IMAGE_VA)>>0)&255,((cli_start-file_start+IMAGE_VA)>>8)&255,((cli_start-file_start+IMAGE_VA)>>16)&255,((cli_start-file_start+IMAGE_VA)>>24)&255,((cli_start-file_start+IMAGE_VA)>>32)&255,((cli_start-file_start+IMAGE_VA)>>40)&255,((cli_start-file_start+IMAGE_VA)>>48)&255,((cli_start-file_start+IMAGE_VA)>>56)&255,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,64,0,56,0,1,0,64,0,0,0,0,0,1,0,0,0,7,0,0,0
db 0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,64,0,0,0,0,0
db ((file_end-file_start)>>0)&255,((file_end-file_start)>>8)&255,((file_end-file_start)>>16)&255,((file_end-file_start)>>24)&255,((file_end-file_start)>>32)&255,((file_end-file_start)>>40)&255,((file_end-file_start)>>48)&255,((file_end-file_start)>>56)&255,((file_end-file_start+0xe00000)>>0)&255,((file_end-file_start+0xe00000)>>8)&255,((file_end-file_start+0xe00000)>>16)&255,((file_end-file_start+0xe00000)>>24)&255,((file_end-file_start+0xe00000)>>32)&255,((file_end-file_start+0xe00000)>>40)&255,((file_end-file_start+0xe00000)>>48)&255,((file_end-file_start+0xe00000)>>56)&255,0,16,0,0,0,0,0,0

; RUASM 1.4.0-alpha1 self-hosting core. Source via the native CLI below (stdin path is legacy).
; Multi-scan layout: symbol/EQU convergence, monotonic short-branch relaxation, final emission.
; Symbol table (1024 entries), integer expressions (+ - << >> & | parentheses),
; DB, integer ISA subset, JMP/JE/JNE short/near relaxation and CALL rel32.
; The compiler is built through predecessor, transition and fixed-point stages.

line_buffer equ input_buffer+0x10000
token_buffer equ input_buffer+0x11000
output_buffer equ input_buffer+0x12000
label_table equ input_buffer+0x22000
temp_path equ input_buffer+0x80000
number_buffer equ input_buffer+0x81000
time_start equ input_buffer+0x82000
time_end equ input_buffer+0x82010
cli_state equ input_buffer+0x83000
default_output_path equ input_buffer+0x84000
op1 equ input_buffer+0x85000
op2 equ input_buffer+0x85040
op_misc equ input_buffer+0x85080
sym_buffer equ input_buffer+0x86000
name_buffer equ input_buffer+0x86100
regbuf equ input_buffer+0x86200
equ_source equ input_buffer+0x95000
equ_changed equ input_buffer+0x95008
equ_iterations equ input_buffer+0x95010
diag_line equ input_buffer+0x95018
diag_column equ input_buffer+0x95020
branch_short_count equ input_buffer+0x95028
expr_unresolved equ input_buffer+0x95030
branch_layout_shrink equ input_buffer+0x95048
branch_cycle_history equ input_buffer+0x95050
branch_cycle_size_a equ input_buffer+0x95058
branch_cycle_size_b equ input_buffer+0x95060
branch_cycle_short_a equ input_buffer+0x95068
branch_cycle_short_b equ input_buffer+0x95070
branch_cycle_count_a equ input_buffer+0x95078
branch_cycle_count_b equ input_buffer+0x95080
branch_cycle_snapshot_a equ input_buffer+0x36000
branch_cycle_snapshot_b equ input_buffer+0x3a000
diag_code equ input_buffer+0x95038
diag_symbol_column equ input_buffer+0x95040
branch_short_map equ input_buffer+0x88000
branch_forced_map equ input_buffer+0x8e000
line_source_pointer equ input_buffer+0x95088
line_source_number equ input_buffer+0x95090
equ_reverse_index equ input_buffer+0x95098
equ_saved_r12 equ input_buffer+0x950a0
equ_saved_r14 equ input_buffer+0x950a8
equ_line_ptrs equ input_buffer+0x7c000
equ_line_numbers equ input_buffer+0x7e000
equ_graph_capture equ input_buffer+0x950b0
equ_graph_owner equ input_buffer+0x950b8
equ_graph_built equ input_buffer+0x950c0
equ_graph_index equ input_buffer+0x950c8
equ_graph_i equ input_buffer+0x950d0
equ_graph_j equ input_buffer+0x950d8
equ_graph_target equ input_buffer+0x950e0
equ_graph_found equ input_buffer+0x950e8
equ_graph_equ_count equ input_buffer+0x950f0
equ_graph_order_count equ input_buffer+0x950f8
equ_graph_order_index equ input_buffer+0x95100
symbol_found_index equ input_buffer+0x95108
symbol_found_saved_rbx equ input_buffer+0x95110
equ_graph_saved_entry equ input_buffer+0x95118
equ_graph_bits equ input_buffer+0xb0000
equ_graph_counts equ input_buffer+0xd0000
equ_graph_remaining equ input_buffer+0xd2000
equ_graph_order equ input_buffer+0xd4000
equ_graph_done equ input_buffer+0xd6000
ir_count equ input_buffer+0x95120
ir_cursor equ input_buffer+0x95128
ir_current_meta equ input_buffer+0x95130
ir_active equ input_buffer+0x95138
ir_source_base equ input_buffer+0x95140
ir_offset equ input_buffer+0x95148
operand_ir_slot equ input_buffer+0x95150
operand_source_offset equ input_buffer+0x95158
operand_token_length equ input_buffer+0x95160
expr_ast_enabled equ input_buffer+0x95168
expr_ast_depth equ input_buffer+0x95170
expr_ast_count equ input_buffer+0x95178
expr_ast_build_sp equ input_buffer+0x95180
expr_ast_start_id equ input_buffer+0x95188
expr_ast_target equ input_buffer+0x95190
expr_ast_temp_ptr equ input_buffer+0x95198
expr_ast_temp_len equ input_buffer+0x951a0
expr_ast_temp_op equ input_buffer+0x951a8
expr_ast_eval_start equ input_buffer+0x951b0
expr_ast_eval_end equ input_buffer+0x951b8
expr_ast_eval_index equ input_buffer+0x951c0
expr_ast_eval_sp equ input_buffer+0x951c8
expr_ast_eval_source equ input_buffer+0x951d0
expr_ast_eval_symbol_len equ input_buffer+0x951d8
expr_ast_eval_value equ input_buffer+0x951e0
expr_ast_temp_left equ input_buffer+0x951e8
expr_ast_temp_right equ input_buffer+0x951f0
expr_ast_eval_symbol_entry equ input_buffer+0x951f8
expr_ast_name_used equ input_buffer+0x95200
expr_ast_generic_mode equ input_buffer+0x95208
expr_ast_generic_cached equ input_buffer+0x95210
ir_needs_layout equ input_buffer+0x95218
generic_expr_meta equ input_buffer+0xc80000
expr_ast_build_stack equ input_buffer+0x96000
expr_ast_eval_stack equ input_buffer+0x9e000
expr_ast_build_base equ input_buffer+0xa6000
statement_ir equ input_buffer+0x100000
typed_operand_ir equ input_buffer+0x280000
typed_expr_meta_ir equ input_buffer+0x580000
expression_ast_ir equ input_buffer+0x880000
expression_ast_names equ input_buffer+0xb80000

_start:
 db 0xfc                         ; cld
 mov rax,0
 mov rdi,0
 mov rsi,input_buffer+IMAGE_VA
 mov rdx,0x10000
 syscall
 cmp rax,0
 je finish_output
 cmp rax,0x10000
 je input_error
 mov r12,input_buffer+IMAGE_VA
 mov rbx,equ_source+IMAGE_VA
 mov [rbx],r12
 mov r13,r12
 add r13,rax                    ; input end
 mov r14,output_buffer+IMAGE_VA ; output cursor
 mov rbx,diag_line+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbp,state_base+IMAGE_VA
 xor rax,rax
 mov [rbp+0],rax
 mov [rbp+8],rax
 mov [rbp+16],rax
 call build_statement_ir

main_loop:
 mov rbx,ir_cursor+IMAGE_VA
 mov rax,[rbx]
 mov rdx,ir_count+IMAGE_VA
 mov rcx,[rdx]
 cmp rax,rcx
 je pass_done
 call get_ir_line
 mov rbx,ir_current_meta+IMAGE_VA
 mov rax,[rbx]
 db 0x48,0x25,0xff,0x00,0x00,0x00
 cmp rax,0
 je main_loop_advance
 mov rsi,line_buffer+IMAGE_VA
 call process_line
main_loop_advance:
 mov rbx,ir_cursor+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov [rbx],rax
 jmp main_loop

pass_done:
 mov rbx,ir_needs_layout+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 je finish_file
 mov rax,[rbp+0]
 cmp rax,0
 je pass_zero_done
 cmp rax,2
 je pass_resolve_done
 jmp second_pass_done

; Pass 0 creates the initial symbol table. Pass 2 repeatedly recalculates
; labels and EQU values until both addresses and values reach a fixed point.
pass_zero_done:
 mov rax,2
 mov [rbp+0],rax
 xor rax,rax
 mov rbx,equ_changed+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_iterations+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_graph_built+IMAGE_VA
 mov [rbx],rax
 jmp pass_resolve_restart

pass_resolve_done:
 mov rbx,equ_changed+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 je pass_resolve_stable
 mov rbx,ir_offset+IMAGE_VA
 mov rax,[rbx]
 mov rbx,equ_graph_equ_count+IMAGE_VA
 mov rdx,[rbx]
 add rax,rdx
 cmp rax,0
 je pass_resolve_stable
 xor rax,rax
 mov rbx,equ_changed+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_iterations+IMAGE_VA
 mov rax,[rbx]
 add rax,1
 mov rbx,equ_iterations+IMAGE_VA
 mov [rbx],rax
 cmp rax,2048
 je syntax_error
 ; Freeze only when the exact two-cycle detector confirms a repeated layout.
 call branch_cycle_check
 cmp rax,1
 jne pass_resolve_restart
pass_freeze_short:
 mov rsi,branch_short_map+IMAGE_VA
 mov rdi,branch_forced_map+IMAGE_VA
 mov rcx,BRANCH_MAP_QWORDS
branch_freeze_short_loop:
 mov rax,[rsi]
 mov rdx,[rdi]
 db 0x48, 0x09, 0xc2            ; or rdx,rax
 mov [rdi],rdx
 xor rax,rax
 mov [rsi],rax
 add rsi,8
 add rdi,8
 sub rcx,1
 cmp rcx,0
 jne branch_freeze_short_loop
 mov rbx,branch_short_count+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,branch_cycle_history+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_changed+IMAGE_VA
 mov rax,1
 mov [rbx],rax
pass_resolve_restart:
 mov rbx,branch_layout_shrink+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,ir_offset+IMAGE_VA
 mov [rbx],rax
 mov rbx,diag_line+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rbx,equ_source+IMAGE_VA
 mov r12,[rbx]
 mov rbx,ir_cursor+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov r14,output_buffer+IMAGE_VA
 xor rax,rax
 mov [rbp+8],rax
 call resolve_equ_graph
 ; EQU replay updates the diagnostic line. Restore physical source-line
 ; numbering before branch relaxation and final emission.
 mov rbx,diag_line+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 ; The dependency-first EQU pass supplies current values. The forward source
 ; scan remains authoritative for labels, layout and branch relaxation.
 mov rbx,equ_changed+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 jmp main_loop

pass_resolve_stable:
 mov rbx,label_table+IMAGE_VA
 xor rcx,rcx
 mov rdx,[rbp+16]
pass_equ_status_scan:
 cmp rcx,rdx
 je pass_equ_status_ready
 mov rax,[rbx+72]
 cmp rax,2
 je syntax_error
 add rbx,80
 add rcx,1
 jmp pass_equ_status_scan
pass_equ_status_ready:
 mov rbx,diag_line+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov rax,[rbp+8]
 mov [rbp+80],rax
 mov rax,1
 mov [rbp+0],rax
 xor rax,rax
 mov [rbp+8],rax
 mov rbx,equ_source+IMAGE_VA
 mov r12,[rbx]
 mov rbx,ir_cursor+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov r14,output_buffer+IMAGE_VA
 jmp main_loop
second_pass_done:
 mov rax,[rbp+8]
 mov rdx,[rbp+80]
 cmp rax,rdx
 jne second_pass_layout_retry
 jmp finish_file
second_pass_layout_retry:
 ; Final encoding can reveal a size-dependent expression whose value changed
 ; when labels settled. Re-enter layout instead of reporting a false syntax error.
 mov rbx,equ_changed+IMAGE_VA
 mov rax,1
 mov [rbx],rax
 mov rax,2
 mov [rbp+0],rax
 xor rax,rax
 mov [rbp+8],rax
 mov rbx,diag_line+IMAGE_VA
 mov [rbx],rax
 mov rbx,equ_source+IMAGE_VA
 mov r12,[rbx]
 mov rbx,ir_cursor+IMAGE_VA
 xor rax,rax
 mov [rbx],rax
 mov r14,output_buffer+IMAGE_VA
 jmp main_loop

finish_output:
 mov rax,1
 mov rdi,1
 mov rsi,output_buffer+IMAGE_VA
 mov rdx,r14
 sub rdx,rsi
 syscall
 mov rax,60
 mov rdi,0
 syscall

input_error:
 mov rbx,cli_state+IMAGE_VA
 mov rax,[rbx+80]
 cmp rax,1
 je input_error_json
 mov rsi,msg_input+IMAGE_VA
 mov rdx,msg_input_end-msg_input
 jmp fail
input_error_json:
 mov rsi,msg_json_input+IMAGE_VA
 mov rdx,msg_json_input_end-msg_json_input
 call write_stderr
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 call print_u64
 mov rsi,msg_json_col_null+IMAGE_VA
 mov rdx,msg_json_col_null_end-msg_json_col_null
 call write_stderr
 jmp exit_error
syntax_error:
 ; RSI normally points into the current source line. Report byte columns
 ; only when that pointer is inside line_buffer; otherwise use JSON null.
 mov rax,rsi
 sub rax,line_buffer+IMAGE_VA
 cmp rax,4095
 db 0x0f, 0x97
 db 0xc1                         ; seta cl: outside current source line
 db 0x0f, 0xb6
 db 0xc9                         ; movzx ecx,cl
 cmp rcx,1
 je syntax_column_unknown
 add rax,1
 mov rbx,diag_column+IMAGE_VA
 mov [rbx],rax
 jmp syntax_column_ready
syntax_column_unknown:
 jmp syntax_column_ready
syntax_column_ready:
 mov rbx,cli_state+IMAGE_VA
 mov rax,[rbx+80]
 cmp rax,1
 je syntax_error_json
 mov rbx,diag_code+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je syntax_text_range
 cmp rax,2
 je syntax_text_identifier
 cmp rax,3
 je syntax_text_duplicate
 cmp rax,4
 je syntax_text_undefined
 cmp rax,5
 je syntax_text_symbol_limit
 cmp rax,6
 je syntax_text_output_limit
 cmp rax,7
 je syntax_text_equ_cycle
 mov rsi,msg_syntax+IMAGE_VA
 mov rdx,msg_syntax_end-msg_syntax
 jmp syntax_text_prefix_ready
syntax_text_range:
 mov rsi,msg_text_range+IMAGE_VA
 mov rdx,msg_text_range_end-msg_text_range
 jmp syntax_text_prefix_ready
syntax_text_identifier:
 mov rsi,msg_text_identifier+IMAGE_VA
 mov rdx,msg_text_identifier_end-msg_text_identifier
 jmp syntax_text_prefix_ready
syntax_text_duplicate:
 mov rsi,msg_text_duplicate+IMAGE_VA
 mov rdx,msg_text_duplicate_end-msg_text_duplicate
 jmp syntax_text_prefix_ready
syntax_text_undefined:
 mov rsi,msg_text_undefined+IMAGE_VA
 mov rdx,msg_text_undefined_end-msg_text_undefined
 jmp syntax_text_prefix_ready
syntax_text_symbol_limit:
 mov rsi,msg_text_symbol_limit+IMAGE_VA
 mov rdx,msg_text_symbol_limit_end-msg_text_symbol_limit
 jmp syntax_text_prefix_ready
syntax_text_output_limit:
 mov rsi,msg_text_output_limit+IMAGE_VA
 mov rdx,msg_text_output_limit_end-msg_text_output_limit
 jmp syntax_text_prefix_ready
syntax_text_equ_cycle:
 mov rsi,msg_text_equ_cycle+IMAGE_VA
 mov rdx,msg_text_equ_cycle_end-msg_text_equ_cycle
syntax_text_prefix_ready:
 call write_stderr
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 call print_u64
 mov rbx,diag_column+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 je syntax_error_text_unknown
 mov rsi,msg_text_column+IMAGE_VA
 mov rdx,msg_text_column_end-msg_text_column
 call write_stderr
 mov rbx,diag_column+IMAGE_VA
 mov rax,[rbx]
 call print_u64
 mov rsi,msg_newline+IMAGE_VA
 mov rdx,msg_newline_end-msg_newline
 call write_stderr
 jmp exit_error
syntax_error_text_unknown:
 mov rsi,msg_text_column_unknown+IMAGE_VA
 mov rdx,msg_text_column_unknown_end-msg_text_column_unknown
 call write_stderr
 mov rsi,msg_newline+IMAGE_VA
 mov rdx,msg_newline_end-msg_newline
 call write_stderr
 jmp exit_error
syntax_error_json:
 mov rbx,diag_code+IMAGE_VA
 mov rax,[rbx]
 cmp rax,1
 je syntax_json_range
 cmp rax,2
 je syntax_json_identifier
 cmp rax,3
 je syntax_json_duplicate
 cmp rax,4
 je syntax_json_undefined
 cmp rax,5
 je syntax_json_symbol_limit
 cmp rax,6
 je syntax_json_output_limit
 cmp rax,7
 je syntax_json_equ_cycle
 mov rsi,msg_json_syntax+IMAGE_VA
 mov rdx,msg_json_syntax_end-msg_json_syntax
 jmp syntax_json_prefix_ready
syntax_json_range:
 mov rsi,msg_json_range+IMAGE_VA
 mov rdx,msg_json_range_end-msg_json_range
 jmp syntax_json_prefix_ready
syntax_json_identifier:
 mov rsi,msg_json_identifier+IMAGE_VA
 mov rdx,msg_json_identifier_end-msg_json_identifier
 jmp syntax_json_prefix_ready
syntax_json_duplicate:
 mov rsi,msg_json_duplicate+IMAGE_VA
 mov rdx,msg_json_duplicate_end-msg_json_duplicate
 jmp syntax_json_prefix_ready
syntax_json_undefined:
 mov rsi,msg_json_undefined+IMAGE_VA
 mov rdx,msg_json_undefined_end-msg_json_undefined
 jmp syntax_json_prefix_ready
syntax_json_symbol_limit:
 mov rsi,msg_json_symbol_limit+IMAGE_VA
 mov rdx,msg_json_symbol_limit_end-msg_json_symbol_limit
 jmp syntax_json_prefix_ready
syntax_json_output_limit:
 mov rsi,msg_json_output_limit+IMAGE_VA
 mov rdx,msg_json_output_limit_end-msg_json_output_limit
 jmp syntax_json_prefix_ready
syntax_json_equ_cycle:
 mov rsi,msg_json_equ_cycle+IMAGE_VA
 mov rdx,msg_json_equ_cycle_end-msg_json_equ_cycle
syntax_json_prefix_ready:
 call write_stderr
 mov rbx,diag_line+IMAGE_VA
 mov rax,[rbx]
 call print_u64
 mov rbx,diag_column+IMAGE_VA
 mov rax,[rbx]
 cmp rax,0
 je syntax_error_json_null
 mov rsi,msg_json_column+IMAGE_VA
 mov rdx,msg_json_column_end-msg_json_column
 call write_stderr
 mov rbx,diag_column+IMAGE_VA
 mov rax,[rbx]
 call print_u64
 jmp syntax_error_json_end
syntax_error_json_null:
 mov rsi,msg_json_col_null+IMAGE_VA
 mov rdx,msg_json_col_null_end-msg_json_col_null
 call write_stderr
 jmp exit_error
syntax_error_json_end:
 mov rsi,msg_json_end+IMAGE_VA
 mov rdx,msg_json_end_end-msg_json_end
 call write_stderr
 jmp exit_error
fail:
 call write_stderr
exit_error:
 mov rax,60
 mov rdi,1
 syscall
write_stderr:
 mov rax,1
 mov rdi,2
 syscall
 ret

; Read one source line from [R12,R13) into line_buffer.
