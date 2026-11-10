IMAGE_VA equ 0x400000
BRANCH_MAP_QWORDS equ 3072
file_start:
db 127,69,76,70,2,1,1,0,0,0,0,0,0,0,0,0,2,0,62,0,1,0,0,0
db ((cli_start-file_start+IMAGE_VA)>>0)&255,((cli_start-file_start+IMAGE_VA)>>8)&255,((cli_start-file_start+IMAGE_VA)>>16)&255,((cli_start-file_start+IMAGE_VA)>>24)&255,((cli_start-file_start+IMAGE_VA)>>32)&255,((cli_start-file_start+IMAGE_VA)>>40)&255,((cli_start-file_start+IMAGE_VA)>>48)&255,((cli_start-file_start+IMAGE_VA)>>56)&255,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,64,0,56,0,1,0,64,0,0,0,0,0,1,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,64,0,0,0,0,0
db ((file_end-file_start)>>0)&255,((file_end-file_start)>>8)&255,((file_end-file_start)>>16)&255,((file_end-file_start)>>24)&255,((file_end-file_start)>>32)&255,((file_end-file_start)>>40)&255,((file_end-file_start)>>48)&255,((file_end-file_start)>>56)&255,((file_end-file_start+0xe00000)>>0)&255,((file_end-file_start+0xe00000)>>8)&255,((file_end-file_start+0xe00000)>>16)&255,((file_end-file_start+0xe00000)>>24)&255,((file_end-file_start+0xe00000)>>32)&255,((file_end-file_start+0xe00000)>>40)&255,((file_end-file_start+0xe00000)>>48)&255,((file_end-file_start+0xe00000)>>56)&255,0,16,0,0,0,0,0,0
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
db 252
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
add r13,rax
mov r14,output_buffer+IMAGE_VA
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
db 72,37,255,0,0,0
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
db 72,9,194
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
mov rbx,diag_line+IMAGE_VA
xor rax,rax
mov [rbx],rax
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
mov rax,rsi
sub rax,line_buffer+IMAGE_VA
cmp rax,4095
db 15,151,193,15,182,201
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
db 15,182,6
add rsi,1
cmp rax,10
je get_line_done
cmp rax,13
je get_line_loop
cmp rax,0
je syntax_error
cmp rcx,4095
je input_error
db 170
add rcx,1
jmp get_line_loop
get_line_done:
xor rax,rax
db 170
mov r12,rsi
ret
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
db 72,193,225,2
mov r8,statement_ir+IMAGE_VA
add r8,rcx
mov rsi,line_buffer+IMAGE_VA
call classify_statement
mov rdx,rax
db 72,193,234,8,72,131,226,63,72,193,226,26
mov rcx,rax
db 72,131,225,255,72,193,225,18,72,9,202
mov rbx,ir_offset+IMAGE_VA
mov rax,[rbx]
db 72,9,208,65,137,0
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
classify_statement:
call skip_spaces
db 15,182,6
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
db 15,182,6
cmp rax,58
je classify_statement_label
mov rsi,token_buffer+IMAGE_VA
mov rdi,lit_equ+IMAGE_VA
call string_equal
cmp rax,1
je classify_statement_unknown
mov rsi,token_buffer+IMAGE_VA
db 15,182,6,72,131,224,127
mov rdx,isa_table+IMAGE_VA+512
add rdx,rax
db 15,182,2
mov rbx,isa_table+IMAGE_VA+640
add rbx,rax
classify_statement_isa_loop:
db 68,15,182,27
cmp r11,255
je classify_statement_equ_probe
mov rax,r11
db 72,193,224,3
mov rdx,isa_table+IMAGE_VA
add rdx,rax
db 15,182,10
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
db 72,193,224,3
mov rbx,isa_table+IMAGE_VA
add rbx,rax
db 15,182,75,1
mov rax,4
cmp rcx,1
jne classify_statement_isa_kind_ready
mov rax,3
classify_statement_isa_kind_ready:
mov rdx,r11
db 72,193,226,8,72,9,208,15,182,83,2,72,193,226,16,72,9,208,15,182,83,3,72,193,226,24,72,9,208
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
get_ir_line:
mov rbx,ir_cursor+IMAGE_VA
mov rcx,[rbx]
db 72,193,225,2
mov rsi,statement_ir+IMAGE_VA
add rsi,rcx
db 139,6
mov rdx,rax
db 72,193,234,18,72,129,226,255,0,0,0
mov rcx,rax
db 72,193,233,26,72,193,225,8,72,9,202
mov rbx,ir_current_meta+IMAGE_VA
mov [rbx],rdx
db 37,255,255,3,0
mov rbx,ir_source_base+IMAGE_VA
mov r12,[rbx]
add r12,rax
call get_line
mov rbx,ir_active+IMAGE_VA
mov rax,1
mov [rbx],rax
ret
process_line:
mov rbx,diag_column+IMAGE_VA
xor rax,rax
mov [rbx],rax
mov rbx,diag_code+IMAGE_VA
mov [rbx],rax
call skip_spaces
db 15,182,6
cmp rax,59
je process_done
call parse_token
cmp rax,0
je process_done
mov r8,rsi
mov r9,rax
mov rbx,diag_column+IMAGE_VA
mov rax,[rbx]
mov rbx,diag_symbol_column+IMAGE_VA
mov [rbx],rax
mov rbx,r9
cmp rbx,0
je process_done
mov rsi,token_buffer+IMAGE_VA
add rsi,rbx
sub rsi,1
db 15,182,6
cmp rax,58
jne not_label
xor rax,rax
db 136,6
call validate_symbol_name
call define_label
mov rsi,r8
call skip_spaces
db 15,182,22
cmp rdx,0
je process_done
cmp rdx,59
jne syntax_error
ret
not_label:
mov rbx,ir_active+IMAGE_VA
mov rax,[rbx]
cmp rax,1
jne isa_lookup
mov rbx,ir_current_meta+IMAGE_VA
mov rax,[rbx]
mov rdx,rax
db 72,129,226,255,0,0,0
cmp rdx,2
je handle_equ
cmp rdx,3
je isa_ir_dispatch
cmp rdx,4
jne isa_lookup
isa_ir_dispatch:
mov rdx,rax
db 72,193,234,8,72,129,226,255,0,0,0,72,193,226,3
mov rbx,isa_table+IMAGE_VA
add rbx,rdx
jmp isa_dispatch_found
isa_lookup:
mov rsi,token_buffer+IMAGE_VA
db 15,182,6,72,131,224,127
mov rdx,isa_table+IMAGE_VA+512
add rdx,rax
db 15,182,2
mov rbx,isa_table+IMAGE_VA+640
add rbx,rax
isa_dispatch_loop:
db 68,15,182,27
cmp r11,255
je isa_lookup_setcc
add rbx,1
mov rax,r11
db 72,193,224,3
mov rdx,isa_table+IMAGE_VA
add rdx,rax
db 15,182,10
mov rax,lit_db-1+IMAGE_VA
add rax,rcx
mov rsi,token_buffer+IMAGE_VA
mov rdi,rax
call string_equal
cmp rax,1
jne isa_dispatch_loop
mov rbx,rdx
jmp isa_dispatch_found
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
isa_match_condition_mnemonic:
xor rcx,rcx
db 15,182,6
cmp rax,99
je isa_match_cmovcc
cmp rax,115
jne isa_match_condition_none
add rsi,1
db 15,182,6
cmp rax,101
jne isa_match_condition_none
add rsi,1
db 15,182,6
cmp rax,116
jne isa_match_condition_none
add rsi,1
jmp isa_match_condition_suffix
isa_match_cmovcc:
db 15,182,70,1
cmp rax,109
jne isa_match_condition_none
db 15,182,70,2
cmp rax,111
jne isa_match_condition_none
db 15,182,70,3
cmp rax,118
jne isa_match_condition_none
add rsi,4
mov rcx,1
isa_match_condition_suffix:
mov rbx,condition_suffix_table+IMAGE_VA
isa_match_condition_loop:
db 15,182,3,15,182,22
cmp rax,rdx
jne isa_match_condition_next
db 15,182,67,1,15,182,86,1
cmp rax,rdx
jne isa_match_condition_next
cmp rdx,0
je isa_match_condition_found
db 15,182,86,2
cmp rdx,0
jne isa_match_condition_next
isa_match_condition_found:
db 15,182,67,2
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
db 15,182,67,1
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
db 72,131,224,12
cmp rax,0
je handle_setcc_opcode
db 72,193,232,3
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
db 72,131,224,7
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
db 15,146,193,15,182,201
cmp rcx,1
je handle_cmovcc_rex_b
add rax,4
handle_cmovcc_rex_b:
cmp r10,8
db 15,146,193,15,182,201
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
db 72,131,224,7,72,193,224,3
mov rcx,r10
db 72,131,225,7
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
db 15,182,67,4
mov [rbp+40],rax
xor rax,rax
mov [rbp+48],rax
mov [rbp+56],rax
xor rax,rax
db 15,182,67,5
mov [rbp+72],rax
jmp handle_branch
handle_call:
xor rax,rax
db 15,182,67,4
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
handle_jcc:
mov rax,0x0f
mov [rbp+40],rax
mov rax,1
mov [rbp+56],rax
db 15,182,67,4
mov [rbp+48],rax
db 15,182,67,5
mov [rbp+72],rax
jmp handle_branch
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
mov rbx,branch_cycle_history+IMAGE_VA
mov rax,1
mov [rbx],rax
mov rsi,label_table+IMAGE_VA
mov rdi,branch_cycle_snapshot_a+IMAGE_VA
mov rcx,[rbp+16]
jmp branch_cycle_save_a_loop
branch_cycle_second:
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
mov rsi,branch_cycle_snapshot_a+IMAGE_VA
mov rdi,branch_cycle_snapshot_b+IMAGE_VA
mov rcx,[rbp+16]
jmp branch_cycle_shift_loop
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
db 15,147,194
cmp dl,0
jne resolve_equ_graph_eval_done
mov rcx,rax
db 72,193,225,3
mov rsi,equ_graph_order+IMAGE_VA
add rsi,rcx
mov rax,[rsi]
mov rcx,rax
db 72,193,225,3
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
db 15,147,194
cmp dl,0
jne build_equ_graph_empty
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
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
mov rdi,equ_graph_bits+IMAGE_VA
xor rax,rax
mov rcx,17408
db 243,72,171
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
db 15,147,194
cmp dl,0
jne build_equ_graph_done
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
add rdx,rcx
add rdx,label_table+IMAGE_VA
mov rdx,[rdx+72]
cmp rdx,0
je build_equ_graph_next
mov rbx,equ_graph_index+IMAGE_VA
mov rax,[rbx]
db 72,193,224,3
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
sort_equ_graph:
mov rdi,equ_graph_done+IMAGE_VA
xor rax,rax
mov rcx,1024
db 243,170
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
db 15,147,194
cmp dl,0
jne sort_equ_init_done
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
add rdx,rcx
add rdx,label_table+IMAGE_VA
mov rdx,[rdx+72]
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
db 72,193,224,3
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
db 15,147,194
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
db 15,147,194
cmp dl,0
jne sort_equ_check_found
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
add rdx,rcx
add rdx,label_table+IMAGE_VA
mov rdx,[rdx+72]
cmp rdx,0
je sort_equ_find_next
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
db 15,182,18
cmp rdx,0
jne sort_equ_find_next
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
db 72,193,224,3
mov rbx,equ_graph_remaining+IMAGE_VA
add rbx,rax
mov rcx,[rbx]
cmp rcx,0
jne sort_equ_find_next
mov rbx,equ_graph_found+IMAGE_VA
mov rax,1
mov [rbx],rax
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
mov rcx,1
db 136,10
mov rdx,rax
db 72,193,226,3
mov rbx,equ_graph_order_count+IMAGE_VA
mov rcx,[rbx]
db 72,193,225,3
mov rbx,equ_graph_order+IMAGE_VA
add rbx,rcx
mov [rbx],rax
mov rbx,equ_graph_target+IMAGE_VA
mov [rbx],rax
mov rbx,equ_graph_j+IMAGE_VA
xor rax,rax
mov [rbx],rax
sort_equ_release_loop:
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
mov rcx,[rbp+16]
cmp rax,rcx
db 15,147,194
cmp dl,0
jne sort_equ_release_done
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
add rdx,rcx
add rdx,label_table+IMAGE_VA
mov rdx,[rdx+72]
cmp rdx,0
je sort_equ_release_next
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
db 15,182,18
cmp rdx,1
je sort_equ_release_next
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
db 72,193,224,7
mov rdx,equ_graph_target+IMAGE_VA
mov rdx,[rdx]
mov rcx,rdx
db 72,193,233,6,72,193,225,3
add rax,rcx
mov rbx,equ_graph_bits+IMAGE_VA
add rbx,rax
mov rcx,rdx
db 72,131,225,63
mov rdx,1
db 72,211,226
mov rax,[rbx]
db 72,133,208
je sort_equ_release_next
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
db 72,193,224,3
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
find_actual_equ_cycle:
mov rbx,equ_graph_i+IMAGE_VA
xor rax,rax
mov [rbx],rax
find_cycle_start:
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
mov rcx,[rbp+16]
cmp rax,rcx
db 15,147,194
cmp dl,0
jne equ_cycle_error
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
add rdx,rcx
add rdx,label_table+IMAGE_VA
mov rdx,[rdx+72]
cmp rdx,0
je find_cycle_start_next
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
db 15,182,18
cmp rdx,2
je find_cycle_report
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
mov rcx,2
db 136,10
mov rbx,equ_graph_j+IMAGE_VA
xor rax,rax
mov [rbx],rax
find_cycle_edge_scan:
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
mov rcx,[rbp+16]
cmp rax,rcx
db 15,147,194
cmp dl,0
jne equ_cycle_error
mov rdx,rax
db 72,193,226,6
mov rcx,rax
db 72,193,225,4
add rdx,rcx
add rdx,label_table+IMAGE_VA
mov rdx,[rdx+72]
cmp rdx,0
je find_cycle_edge_next
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
db 15,182,18
cmp rdx,1
je find_cycle_edge_next
mov rbx,equ_graph_i+IMAGE_VA
mov rax,[rbx]
db 72,193,224,7
mov rdx,equ_graph_j+IMAGE_VA
mov rdx,[rdx]
mov rcx,rdx
db 72,193,233,6,72,193,225,3
add rax,rcx
mov rbx,equ_graph_bits+IMAGE_VA
add rbx,rax
mov rcx,rdx
db 72,131,225,63
mov rdx,1
db 72,211,226
mov rax,[rbx]
db 72,133,208
je find_cycle_edge_next
mov rbx,equ_graph_j+IMAGE_VA
mov rax,[rbx]
mov rdx,equ_graph_done+IMAGE_VA
add rdx,rax
db 15,182,18
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
db 72,193,224,3
mov rdx,equ_line_numbers+IMAGE_VA
add rdx,rax
mov rax,[rdx]
mov rbx,diag_line+IMAGE_VA
mov [rbx],rax
mov rbx,diag_column+IMAGE_VA
xor rax,rax
mov [rbx],rax
jmp equ_cycle_error
handle_branch:
mov rsi,r8
call skip_separators
call parse_token
mov rbx,diag_column+IMAGE_VA
mov rax,[rbx]
mov rbx,diag_symbol_column+IMAGE_VA
mov [rbx],rax
call skip_spaces
db 15,182,6
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
mov rbx,diag_line+IMAGE_VA
mov rax,[rbx]
mov rcx,rax
db 72,193,232,6,72,193,224,3
mov rbx,branch_short_map+IMAGE_VA
add rbx,rax
db 72,131,225,63
mov rdx,1
db 72,211,226
mov rax,[rbx]
db 72,33,208
cmp rax,0
jne branch_use_short
mov rbx,diag_line+IMAGE_VA
mov rax,[rbx]
mov rcx,rax
db 72,193,232,6,72,193,224,3
mov rbx,branch_forced_map+IMAGE_VA
add rbx,rax
db 72,131,225,63
mov rdx,1
db 72,211,226
mov rax,[rbx]
db 72,33,208
cmp rax,0
jne branch_emit_near
mov rax,[rbp+0]
cmp rax,2
jne branch_emit_near
mov rax,[rbp+24]
mov rbx,[rbp+8]
cmp rax,rbx
db 15,151,193,15,182,201
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
db 72,15,190,201
cmp rax,rcx
jne branch_emit_near
mov rbx,ir_offset+IMAGE_VA
mov rdx,[rbx]
sub rdx,1
mov [rbx],rdx
mov rbx,diag_line+IMAGE_VA
mov rax,[rbx]
mov rcx,rax
db 72,193,232,6,72,193,224,3
mov rbx,branch_short_map+IMAGE_VA
add rbx,rax
db 72,131,225,63
mov rdx,1
db 72,211,226
mov rax,[rbx]
db 72,9,208
mov [rbx],rax
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
mov rax,[rbp+0]
cmp rax,1
jne branch_short_measure
mov rax,[rbp+24]
mov rbx,[rbp+8]
add rbx,2
sub rax,rbx
mov [rbp+64],rax
mov rcx,rax
db 72,15,190,201
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
mov rbx,diag_line+IMAGE_VA
mov rax,[rbx]
mov rcx,rax
db 72,193,232,6,72,193,224,3
mov rbx,branch_forced_map+IMAGE_VA
add rbx,rax
db 72,131,225,63
mov rdx,1
db 72,211,226
mov rax,[rbx]
db 72,9,208
mov [rbx],rax
mov rbx,diag_line+IMAGE_VA
mov rax,[rbx]
mov rcx,rax
db 72,193,232,6,72,193,224,3
mov rbx,branch_short_map+IMAGE_VA
add rbx,rax
db 72,131,225,63
mov rdx,1
db 72,211,226,72,247,210
mov rax,[rbx]
db 72,33,208
mov [rbx],rax
mov rbx,branch_short_count+IMAGE_VA
mov rax,[rbx]
sub rax,1
mov [rbx],rax
mov rbx,equ_changed+IMAGE_VA
mov rax,1
mov [rbx],rax
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
db 72,193,232,8
mov [rbp+64],rax
sub r11,1
cmp r11,0
jne branch_disp_loop
ret
handle_isa_fixed:
mov rsi,r8
call skip_spaces
db 15,182,22
cmp rdx,0
je handle_isa_fixed_arity_ok
cmp rdx,59
jne syntax_error
handle_isa_fixed_arity_ok:
db 15,182,67,3
cmp rax,1
je handle_isa_fixed_one_byte
cmp rax,2
jne syntax_error
db 15,182,67,4
call emit_byte
db 15,182,67,5
call emit_byte
ret
handle_isa_fixed_one_byte:
db 15,182,67,4
call emit_byte
ret
parse_one:
mov rdi,op1+IMAGE_VA
call parse_operand
mov rsi,r8
call skip_spaces
db 15,182,22
cmp rdx,0
je parse_one_ok
cmp rdx,59
jne syntax_error
parse_one_ok:
ret
handle_push:
db 15,182,67,4
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
db 72,193,232,8
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
db 72,193,232,32
cmp rax,0
jne syntax_error
mov rax,0x68
call emit_byte
mov rbx,r15
mov r11,4
call emit_le
ret
handle_pop:
db 15,182,67,4
mov rdx,op_misc+IMAGE_VA
mov [rdx+56],rax
call parse_one
mov rbx,op1+IMAGE_VA
mov rax,[rbx]
cmp rax,1
jne syntax_error
mov r9,[rbx+8]
jmp emit_isa_opcode_plus_register
emit_isa_opcode_plus_register:
mov rax,r9
cmp rax,8
db 15,146,193,15,182,201
cmp rcx,1
je emit_isa_opcode_reg_low
mov rax,0x41
call emit_byte
emit_isa_opcode_reg_low:
mov rdx,op_misc+IMAGE_VA
mov rax,[rdx+56]
mov rcx,r9
db 72,131,225,7
add rax,rcx
call emit_byte
ret
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
db 72,15,68,193
xor rcx,rcx
cmp r9,8
db 15,147,193
add rax,rcx
cmp rax,0x40
je bswap_opcode
call emit_byte
bswap_opcode:
mov rax,0x0f
call emit_byte
mov rax,r9
db 72,131,224,7
add rax,0xc8
call emit_byte
ret
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
db 15,148,193
cmp rdx,5
db 15,148,192,8,193
cmp rdx,6
db 15,148,192,8,193
cmp cl,1
jne syntax_error
mov r10,2
mov rcx,4
cmp rdx,5
db 76,15,68,209
mov rcx,8
cmp rdx,1
db 76,15,68,209
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
db 72,15,68,193
xor rcx,rcx
cmp r9,8
db 15,147,193,72,193,225,2
add rax,rcx
xor rcx,rcx
cmp r10,8
db 15,147,193
add rax,rcx
xor r11,r11
cmp r10,4
db 65,15,147,195
xor rdx,rdx
cmp r10,8
db 15,146,194,65,32,211
mov rdx,rax
xor rcx,rcx
cmp rax,0x40
db 15,149,193,68,8,217
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
db 72,131,224,7,72,193,224,3
mov rcx,r10
db 72,131,225,7
add rax,rcx
add rax,0xc0
call emit_byte
ret
handle_bitops:
db 15,182,67,4
mov rdx,op_misc+IMAGE_VA
mov [rdx+88],rax
db 15,182,67,5
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
db 72,193,232,8
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
db 15,146,193,15,182,201
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
db 72,193,224,3
mov rcx,r9
db 72,131,225,7
add rax,rcx
add rax,0xc0
call emit_byte
mov rbx,op_misc+IMAGE_VA
mov rax,[rbx+112]
call emit_byte
ret
handle_muldiv:
db 15,182,67,4
mov rdx,op_misc+IMAGE_VA
mov [rdx+56],rax
db 15,182,67,5
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
db 15,146,193,15,182,201
cmp rcx,1
je muldiv_rex_ready
add rax,1
muldiv_rex_ready:
call emit_byte
mov rdx,op_misc+IMAGE_VA
mov rax,[rdx+56]
add rax,1
call emit_byte
jmp muldiv_modrm
muldiv_r8:
mov r9,[rbx+8]
mov rax,0x40
cmp r9,8
db 15,146,193
cmp cl,1
je muldiv_r8_force_check
add rax,1
muldiv_r8_force_check:
cmp rax,0x40
jne muldiv_r8_emit_rex
cmp r9,4
db 15,146,193
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
db 72,193,224,3
mov rcx,r9
db 72,131,225,7
add rax,rcx
add rax,0xc0
call emit_byte
ret
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
db 72,193,232,8
cmp rax,0
jne syntax_error
mov rbx,op1+IMAGE_VA
mov r9,[rbx+8]
mov rax,0x48
cmp r9,8
db 15,146,193,15,182,201
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
db 15,146,193,15,182,201
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
db 72,193,226,3
mov rax,r9
db 72,131,224,7
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
ret
shift_r8_imm:
mov rbx,op2+IMAGE_VA
mov r15,[rbx+16]
mov rax,r15
db 72,193,232,8
cmp rax,0
jne syntax_error
mov rbx,op1+IMAGE_VA
mov r9,[rbx+8]
mov rax,0x40
cmp r9,8
db 15,146,193
cmp cl,1
je shift_r8_imm_force_check
add rax,1
shift_r8_imm_force_check:
cmp rax,0x40
jne shift_r8_imm_emit_rex
cmp r9,4
db 15,146,193
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
db 15,146,193
cmp cl,1
je shift_r8_cl_force_check
add rax,1
shift_r8_cl_force_check:
cmp rax,0x40
jne shift_r8_cl_emit_rex
cmp r9,4
db 15,146,193
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
db 72,193,226,3
mov rax,r9
db 72,131,224,7
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
db 72,131,226,8
cmp rdx,0
je unary_gpr_rex_no_b
add rax,1
unary_gpr_rex_no_b:
cmp rax,0x40
jne unary_gpr_emit_rex
cmp r10,1
jne unary_gpr_opcode
cmp r9,4
db 15,146,193
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
db 72,193,224,3
add rax,0xc0
mov rdx,r9
db 72,131,226,7
add rax,rdx
call emit_byte
ret
cli_emit_isa_model:
mov rbx,isa_table+IMAGE_VA
xor r12,r12
cli_isa_model_loop:
db 15,182,3
cmp rax,0
je cli_isa_model_done
db 15,182,67,2
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
db 15,182,11
add rax,rcx
mov r13,rax
mov rsi,r13
xor rdx,rdx
cli_isa_model_name_length:
db 15,182,6
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
db 15,182,67,1
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
db 15,182,115,3
mov r14,rsi
xor r15,r15
cli_isa_model_hex_loop:
cmp r15,r14
je cli_isa_model_record_done
mov rsi,rbx
add rsi,4
add rsi,r15
db 15,182,6
mov rcx,rax
db 72,193,233,4,72,131,225,15
mov rsi,lit_hex_digits+IMAGE_VA
add rsi,rcx
mov rdx,1
call cli_write_stdout
mov rsi,rbx
add rsi,4
add rsi,r15
db 15,182,6
mov rcx,rax
db 72,131,225,15
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
db 15,182,67,6
add rax,48
mov rdx,op_misc+IMAGE_VA
db 136,66,88
mov rsi,rdx
add rsi,88
mov rdx,1
call cli_write_stdout
mov rsi,msg_isa_record_close_middle+IMAGE_VA
mov rdx,msg_isa_record_close_middle_end-msg_isa_record_close_middle
call cli_write_stdout
db 15,182,67,7
add rax,48
mov rdx,op_misc+IMAGE_VA
db 136,66,89
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
skip_spaces:
db 15,182,6
cmp rax,32
je skip_space_one
cmp rax,9
je skip_space_one
ret
skip_space_one:
add rsi,1
jmp skip_spaces
skip_separators:
db 15,182,6
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
parse_token:
mov rdi,rsi
mov r11,line_buffer+IMAGE_VA
sub rdi,r11
cmp rdi,4095
db 15,151,193,15,182,201
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
db 15,182,6
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
db 170
add rsi,1
add rcx,1
jmp parse_token_loop
parse_token_done:
xor rax,rax
db 170
mov rax,rcx
ret
string_equal:
string_equal_loop:
db 15,182,6,58,7
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
db 136,7
add r14,1
mov rax,[rbp+8]
add rax,1
mov [rbp+8],rax
mov rax,rsi
ret
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
validate_symbol_name:
mov r10,1
mov rsi,token_buffer+IMAGE_VA
db 15,182,22
cmp rdx,0
je identifier_error
mov rax,rdx
sub rax,48
cmp rax,10
db 15,146,193,15,182,201
cmp rcx,1
je identifier_error
call is_ident
cmp rax,1
jne identifier_error
add rsi,1
validate_symbol_tail:
db 15,182,22
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
db 15,182,19
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
find_symbol:
mov rdi,symbol_found_saved_rbx+IMAGE_VA
mov [rdi],rbx
mov r9,rsi
mov rdi,rsi
db 49,192
mov rcx,64
db 242,174,15,182,6,193,192,5,15,182,86,1,49,208,193,192,5,15,182,87,254,49,208
mov rdx,63
sub rdx,rcx
xor rax,rdx
db 37,255,0,0,0,193,224,3
mov rbx,input_buffer+0xe0000+IMAGE_VA
add rbx,rax
mov r10,[rbx]
xor r11,r11
find_symbol_loop:
cmp r10,0
je find_symbol_missing
sub r10,1
mov r11,r10
db 73,193,227,6
mov rdx,r10
db 72,193,226,4
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
db 72,193,226,3
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
db 72,193,225,6
mov rbx,rax
db 72,193,227,4
add rcx,rbx
mov rdi,label_table+IMAGE_VA
add rdi,rcx
mov r11,rdi
add_symbol_copy:
db 15,182,6
mov [rdi],al
cmp rax,0
je add_symbol_done
add rsi,1
add rdi,1
jmp add_symbol_copy
add_symbol_done:
mov [r11+64],rdx
db 65,15,182,3,193,192,5,65,15,182,83,1,49,208,193,192,5,15,182,87,255,49,208
mov rdx,rdi
sub rdx,r11
xor rax,rdx
db 37,255,0,0,0,193,224,3
mov rbx,input_buffer+0xe0000+IMAGE_VA
add rbx,rax
mov rax,[rbx]
mov rdi,input_buffer+0xe1000+IMAGE_VA
mov rdx,r10
db 72,193,226,3
add rdi,rdx
mov [rdi],rax
mov rdx,r10
add rdx,1
mov [rbx],rdx
mov rax,[rbp+16]
add rax,1
mov [rbp+16],rax
ret
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
lookup_label:
mov rsi,token_buffer+IMAGE_VA
call find_symbol
cmp rax,0
je lookup_label_missing
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
is_ident:
mov rax,rdx
sub rax,48
cmp rax,10
db 15,146,193,15,182,201
cmp rcx,1
je is_ident_yes
mov rax,rdx
sub rax,65
cmp rax,26
db 15,146,193,15,182,201
cmp rcx,1
je is_ident_yes
mov rax,rdx
sub rax,97
cmp rax,26
db 15,146,193,15,182,201
cmp rcx,1
je is_ident_yes
cmp rdx,95
je is_ident_yes
xor rax,rax
ret
is_ident_yes:
mov rax,1
ret
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
db 72,193,224,2
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
db 15,182,6
cmp rax,0
je parse_expr_generic_eval
add rsi,1
jmp parse_expr_generic_scan
parse_expr_generic_eval:
call eval_expression_ast
parse_expr_generic_done:
db 80
mov rbx,expr_ast_generic_mode+IMAGE_VA
xor rax,rax
mov [rbx],rax
mov rbx,expr_ast_generic_cached+IMAGE_VA
mov [rbx],rax
db 88
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
mov rdx,rax
sub rdx,1
db 72,193,226,3
mov rbx,expr_ast_build_base+IMAGE_VA
add rbx,rdx
mov rdx,expr_ast_build_sp+IMAGE_VA
mov rdx,[rdx]
mov [rbx],rdx
expr_ast_enter_done:
ret
expr_ast_leave:
db 80,86,65,80
mov rbx,expr_ast_enabled+IMAGE_VA
mov rax,[rbx]
cmp rax,1
jne expr_ast_leave_done
mov rbx,expr_ast_depth+IMAGE_VA
mov rax,[rbx]
cmp rax,0
je range_error
mov rdx,rax
sub rdx,1
db 72,193,226,3
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
db 72,193,226,32,72,9,209
mov rbx,expr_ast_target+IMAGE_VA
mov rbx,[rbx]
mov [rbx],rcx
mov rbx,expr_ast_enabled+IMAGE_VA
xor rax,rax
mov [rbx],rax
expr_ast_leave_done:
db 65,88,94,88
ret
expr_ast_alloc_node:
mov rbx,expr_ast_count+IMAGE_VA
mov rax,[rbx]
add rax,1
cmp rax,196608
je range_error
mov [rbx],rax
mov rcx,rax
sub rcx,1
db 72,193,225,4
mov rbx,expression_ast_ir+IMAGE_VA
add rbx,rcx
ret
expr_ast_push_literal:
db 80,86,65,80
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
db 72,193,225,3
add rdi,rcx
mov [rdi],rax
mov rcx,[rdx]
add rcx,1
mov [rdx],rcx
expr_ast_push_literal_done:
db 65,88,94,88
ret
expr_ast_push_symbol:
mov rbx,expr_ast_enabled+IMAGE_VA
mov rax,[rbx]
cmp rax,1
jne expr_ast_push_symbol_done
db 80,86,65,80,65,81
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
db 15,182,6,136,7
add rsi,1
add rdi,1
sub r10,1
jmp expr_ast_push_symbol_copy
expr_ast_push_symbol_copy_done:
xor rax,rax
db 136,7
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
db 72,193,225,16,72,9,202
mov [rbx],rdx
mov rdx,expr_ast_temp_ptr+IMAGE_VA
mov rdx,[rdx]
mov [rbx+8],rdx
mov rdx,expr_ast_build_sp+IMAGE_VA
mov rcx,[rdx]
cmp rcx,4095
je range_error
mov rdi,expr_ast_build_stack+IMAGE_VA
db 72,193,225,3
add rdi,rcx
mov [rdi],rax
mov rcx,[rdx]
add rcx,1
mov [rdx],rcx
db 65,89,65,88,94,88
expr_ast_push_symbol_done:
ret
expr_ast_make_binary:
db 80,86,65,80
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
db 72,193,226,3
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
db 72,193,226,3
add rdi,rdx
mov rdx,[rdi]
mov rbx,expr_ast_temp_right+IMAGE_VA
mov [rbx],rdx
sub rcx,1
mov rdi,expr_ast_build_stack+IMAGE_VA
mov rdx,rcx
db 72,193,226,3
add rdi,rdx
mov rdx,[rdi]
mov rbx,expr_ast_temp_left+IMAGE_VA
mov [rbx],rdx
mov rbx,expr_ast_build_sp+IMAGE_VA
mov [rbx],rcx
call expr_ast_alloc_node
mov rdx,expr_ast_temp_op+IMAGE_VA
mov rcx,[rdx]
db 72,193,225,8,72,131,201,3
mov rdx,rax
sub rdx,1
db 72,193,226,4
mov rbx,expression_ast_ir+IMAGE_VA
add rbx,rdx
mov [rbx],rcx
mov rdx,expr_ast_temp_left+IMAGE_VA
mov rdx,[rdx]
mov rcx,expr_ast_temp_right+IMAGE_VA
mov rcx,[rcx]
db 72,193,225,32,72,9,209
mov [rbx+8],rcx
mov rdx,expr_ast_build_sp+IMAGE_VA
mov rcx,[rdx]
mov rbx,expr_ast_build_stack+IMAGE_VA
mov rdi,rcx
db 72,193,231,3
add rbx,rdi
mov [rbx],rax
add rcx,1
mov [rdx],rcx
expr_ast_make_binary_done:
db 65,88,94,88
ret
expr_ast_make_negation:
db 80,86,65,80
mov rbx,expr_ast_enabled+IMAGE_VA
mov rax,[rbx]
cmp rax,1
jne expr_ast_make_negation_done
mov rbx,expr_ast_build_sp+IMAGE_VA
mov rcx,[rbx]
mov rdx,expr_ast_depth+IMAGE_VA
mov rdx,[rdx]
sub rdx,1
db 72,193,226,3
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
db 72,193,226,3
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
db 72,193,231,3
add rbx,rdi
mov [rbx],rax
add rcx,1
mov [rdx],rcx
expr_ast_make_negation_done:
db 65,88,94,88
ret
eval_expression_ast:
db 86,65,80
call get_current_expr_meta
mov rax,[rbx]
mov rdx,rax
db 137,192
mov rbx,expr_ast_eval_start+IMAGE_VA
mov [rbx],rax
db 72,193,234,32
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
db 72,193,224,4
mov rbx,expression_ast_ir+IMAGE_VA
add rbx,rax
mov rdx,[rbx]
mov rax,rdx
db 72,37,255,0,0,0
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
db 72,193,233,16,72,129,225,255,0,0,0
mov [rbx],rcx
mov rsi,rax
mov rdi,sym_buffer+IMAGE_VA
xor r10,r10
eval_expression_ast_copy_symbol:
mov rbx,expr_ast_eval_symbol_len+IMAGE_VA
mov rcx,[rbx]
cmp r10,rcx
je eval_expression_ast_copy_symbol_done
db 15,182,22,136,23
add rsi,1
add rdi,1
add r10,1
jmp eval_expression_ast_copy_symbol
eval_expression_ast_copy_symbol_done:
xor rax,rax
db 136,7
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
db 72,193,227,4
mov rdx,expression_ast_ir+IMAGE_VA
add rdx,rbx
mov rdx,[rdx]
db 72,193,234,8,72,129,226,255,0,0,0
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
db 72,193,234,6
cmp rdx,0
jne range_error
mov rdx,rax
db 72,211,224,80,72,211,232
cmp rax,rdx
db 88
jne range_error
jmp eval_expression_ast_binary_done
eval_expression_ast_shr:
mov rdx,rcx
db 72,193,234,6
cmp rdx,0
jne range_error
db 72,211,232
jmp eval_expression_ast_binary_done
eval_expression_ast_and:
db 72,33,200
jmp eval_expression_ast_binary_done
eval_expression_ast_or:
db 72,9,200
eval_expression_ast_binary_done:
call eval_expression_ast_push
jmp eval_expression_ast_next
eval_expression_ast_unary:
call eval_expression_ast_pop
db 72,247,216
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
db 65,88,94
ret
eval_expression_ast_push:
mov rbx,expr_ast_eval_sp+IMAGE_VA
mov rcx,[rbx]
cmp rcx,4095
je range_error
mov rdx,expr_ast_eval_stack+IMAGE_VA
mov rsi,rcx
db 72,193,230,3
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
db 72,193,230,3
add rdx,rsi
mov rax,[rdx]
ret
parse_expr:
call expr_ast_enter
call expr_and
expr_or_loop:
db 15,182,22
cmp rdx,124
jne expr_or_done
add rsi,1
db 80
call expr_and
db 89,72,9,200
mov rdx,6
call expr_ast_make_binary
jmp expr_or_loop
expr_or_done:
call expr_ast_leave
ret
expr_and:
call expr_shift
expr_and_loop:
db 15,182,22
cmp rdx,38
jne expr_and_done
add rsi,1
db 80
call expr_shift
db 89,72,33,200
mov rdx,5
call expr_ast_make_binary
jmp expr_and_loop
expr_and_done:
ret
expr_shift:
call expr_add
expr_shift_loop:
db 15,182,22
cmp rdx,62
je expr_shift_right
cmp rdx,60
je expr_shift_left
ret
expr_shift_right:
db 15,182,86,1
cmp rdx,62
jne syntax_error
add rsi,2
db 80
call expr_add
mov rcx,rax
db 88
cmp rcx,64
db 15,147,194,15,182,210
cmp rdx,1
je range_error
db 72,211,232
mov rdx,4
call expr_ast_make_binary
jmp expr_shift_loop
expr_shift_left:
db 15,182,86,1
cmp rdx,60
jne syntax_error
add rsi,2
db 80
call expr_add
mov rcx,rax
db 88
cmp rcx,64
db 15,147,194,15,182,210
cmp rdx,1
je range_error
mov rdx,rax
db 72,211,224,80,72,211,232
cmp rax,rdx
db 88
jne range_error
mov rdx,3
call expr_ast_make_binary
jmp expr_shift_loop
expr_add:
call expr_unary
expr_add_loop:
db 15,182,22
cmp rdx,43
je expr_add_plus
cmp rdx,45
je expr_add_minus
ret
expr_add_plus:
add rsi,1
db 80
call expr_unary
db 89
add rax,rcx
mov rdx,1
call expr_ast_make_binary
jmp expr_add_loop
expr_add_minus:
add rsi,1
db 80
call expr_unary
mov rcx,rax
db 88
sub rax,rcx
mov rdx,2
call expr_ast_make_binary
jmp expr_add_loop
expr_unary:
db 15,182,22
cmp rdx,43
je expr_plus
cmp rdx,45
je expr_neg
cmp rdx,40
je expr_paren
mov rax,rdx
sub rax,48
cmp rax,10
db 15,146,193,15,182,201
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
db 72,247,216
call expr_ast_make_negation
ret
expr_paren:
add rsi,1
call parse_expr
db 15,182,22
cmp rdx,41
jne syntax_error
add rsi,1
ret
expr_number:
xor rax,rax
db 15,182,22
cmp rdx,48
jne expr_decimal
db 15,182,86,1
cmp rdx,120
je expr_hex_start
cmp rdx,88
je expr_hex_start
expr_decimal:
db 15,182,22
sub rdx,48
cmp rdx,10
db 15,147,193,15,182,201
cmp rcx,1
je expr_number_done
mov r9,rdx
mov rcx,0x1999999999999999
cmp rax,rcx
db 15,151,193,15,148,194,15,182,201,15,182,210
cmp rcx,1
je range_error
cmp rdx,1
jne expr_decimal_accumulate
cmp r9,5
db 15,151,193,15,182,201
cmp rcx,1
je range_error
expr_decimal_accumulate:
db 72,107,192,10
add rax,r9
add rsi,1
jmp expr_decimal
expr_hex_start:
add rsi,2
xor r9,r9
expr_hex:
db 15,182,22
sub rdx,48
cmp rdx,10
db 15,146,193,15,182,201
cmp rcx,1
je expr_hex_digit
db 15,182,22
sub rdx,97
cmp rdx,6
db 15,146,193,15,182,201
cmp rcx,1
je expr_hex_alpha
db 15,182,22
sub rdx,65
cmp rdx,6
db 15,146,193,15,182,201
cmp rcx,1
je expr_hex_alpha
cmp r9,0
je syntax_error
jmp expr_number_done
expr_hex_alpha:
add rdx,10
expr_hex_digit:
mov rcx,rax
db 72,193,233,60
cmp rcx,0
jne range_error
db 72,193,224,4
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
db 15,182,22
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
db 86
mov rsi,sym_buffer+IMAGE_VA
call find_symbol
db 94
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
record_equ_dependency:
mov rbx,equ_graph_saved_entry+IMAGE_VA
mov [rbx],rax
mov rdx,[rax+72]
cmp rdx,0
je record_equ_dependency_done
mov rbx,equ_graph_owner+IMAGE_VA
mov rcx,[rbx]
db 72,193,225,4
mov rbx,symbol_found_index+IMAGE_VA
mov rdx,[rbx]
mov r10,rdx
db 73,193,234,6
add rcx,r10
db 72,193,225,3
mov rbx,equ_graph_bits+IMAGE_VA
add rbx,rcx
mov rcx,rdx
db 72,131,225,63,65,186,1,0,0,0,73,211,226
mov rdx,[rbx]
db 76,133,210
jne record_equ_dependency_done
db 76,9,210
mov [rbx],rdx
mov rbx,equ_graph_owner+IMAGE_VA
mov rcx,[rbx]
db 72,193,225,3
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
read_reg:
mov r11,rsi
xor rax,rax
mov rdi,regbuf+IMAGE_VA
mov [rdi],rax
xor r9,r9
read_reg_copy:
db 15,182,22
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
parse_operand:
mov r15,rdi
call prepare_operand_ir_slot
mov rbx,operand_ir_slot+IMAGE_VA
mov rbx,[rbx]
cmp rbx,0
je parse_operand_uncached
mov rax,[rbx]
mov rdx,rax
db 72,129,226,255,0,0,0
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
db 15,182,22
cmp rdx,91
je parse_operand_mem
call read_reg
cmp rax,0-1
je parse_operand_imm
db 15,182,22
cmp rdx,0
jne parse_operand_imm
cmp rax,16
db 15,146,193,15,182,201
cmp rcx,1
je parse_operand_reg64
cmp rax,32
db 15,146,193,15,182,201
cmp rcx,1
je parse_operand_reg8
cmp rax,48
db 15,146,193,15,182,201
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
db 72,193,233,16,72,129,225,255,0,0,0
add rsi,rcx
mov r8,rsi
mov rax,[rbx]
mov rcx,rax
db 72,193,233,8,72,129,225,255,0,0,0
mov [r15+8],rcx
db 72,37,255,0,0,0
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
db 72,193,234,24,137,210
mov rcx,rax
db 72,193,233,16,72,129,225,255,0,0,0
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
db 15,182,6,136,7
add rsi,1
add rdi,1
sub r10,1
jmp parse_operand_cached_copy
parse_operand_cached_copy_done:
xor rax,rax
db 136,7
mov rbx,operand_ir_slot+IMAGE_VA
mov rbx,[rbx]
mov rax,[rbx]
mov rdx,rax
db 72,193,234,24,137,210
mov rcx,rax
db 72,193,233,16,72,129,225,255,0,0,0
add rdx,rcx
mov r8,line_buffer+IMAGE_VA
add r8,rdx
mov rax,[rbx]
db 72,37,255,0,0,0
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
db 15,182,22
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
db 72,193,233,8,72,129,225,255,0,0,0
mov [r15+8],rcx
mov rcx,rax
db 72,193,233,56,72,129,225,255,0,0,0
mov rdx,rcx
db 72,129,226,15,0,0,0
mov [r15+32],rdx
mov rdx,rcx
db 72,193,234,4,72,131,226,3
mov [r15+40],rdx
mov rdx,rcx
db 72,193,234,6,72,131,226,1
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
db 15,182,22
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
parse_operand_mem:
add rsi,1
call read_reg
cmp rax,16
db 15,147,193,15,182,201
cmp rcx,1
je syntax_error
mov [r15+8],rax
xor rax,rax
mov [r15+16],rax
mov [r15+24],rax
mov [r15+32],rax
mov [r15+40],rax
mov [r15+48],rax
db 15,182,22
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
db 15,147,193,15,182,201
cmp rcx,1
je syntax_error
cmp rax,4
je syntax_error
mov [r15+32],rax
mov rax,1
mov [r15+48],rax
db 15,182,22
cmp rdx,42
jne parse_operand_mem_after_index
add rsi,1
db 15,182,22
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
db 15,182,22
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
db 15,182,22
cmp rdx,93
jne syntax_error
add rsi,1
db 15,182,22
cmp rdx,0
jne syntax_error
mov rdx,3
mov [r15],rdx
xor rax,rax
call store_operand_ir_node
ret
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
db 72,193,225,4
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
db 72,193,227,16,72,9,218
mov rbx,operand_source_offset+IMAGE_VA
mov rbx,[rbx]
db 72,193,227,24,72,9,218
mov rax,r10
db 72,193,224,8,72,9,194
mov rcx,rdx
db 72,129,225,255,0,0,0
cmp rcx,3
jne store_operand_ir_write
mov rax,[r15+8]
db 72,193,224,8,72,9,194
mov rax,[r15+32]
mov rcx,[r15+40]
db 72,193,225,4,72,9,200
mov rcx,[r15+48]
db 72,193,225,6,72,9,200,72,193,224,56,72,9,194
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
db 15,182,22
cmp rdx,0
je parse_two_ok
cmp rdx,59
jne syntax_error
parse_two_ok:
ret
emit_le:
mov rax,rbx
call emit_byte
db 72,193,235,8
sub r11,1
cmp r11,0
jne emit_le
ret
emit_rr:
mov rbx,op_misc+IMAGE_VA
mov rax,8
mov [rbx+80],rax
jmp emit_rr_width
emit_rr8:
mov rbx,op_misc+IMAGE_VA
mov rax,1
mov [rbx+80],rax
jmp emit_rr_width
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
db 15,146,193,15,182,201
cmp rcx,1
je emit_rr_width_src
add r11,1
emit_rr_width_src:
cmp r10,8
db 15,146,193,15,182,201
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
db 15,146,193
cmp cl,1
jne emit_rr_width_force_rex
cmp r10,4
db 15,146,193
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
db 72,37,0,1,0,0
cmp rax,0
je emit_rr_width_opcode_byte
mov rax,0x0f
call emit_byte
sub r15,0x100
emit_rr_width_opcode_byte:
mov rax,r15
call emit_byte
db 73,131,226,7,73,193,226,3,73,131,225,7
mov rax,r10
add rax,r9
add rax,0xc0
call emit_byte
ret
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
db 15,146,193,15,182,201
cmp rcx,1
je emit_mem_reg_low
add rdx,4
emit_mem_reg_low:
cmp r11,8
db 15,146,193,15,182,201
cmp rcx,1
je emit_mem_base_low
add rdx,1
emit_mem_base_low:
mov rcx,[rbx+48]
cmp rcx,1
jne emit_mem_rex_no_index
mov rcx,[rbx+32]
cmp rcx,8
db 15,146,193,15,182,201
cmp rcx,1
je emit_mem_rex_no_index
add rdx,2
emit_mem_rex_no_index:
cmp rdx,0x40
jne emit_mem_rex_emit
cmp r10,1
jne emit_mem_rex_skip
cmp r9,4
db 15,146,193
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
db 72,37,0,1,0,0
cmp rax,0
je emit_mem_one_byte_opcode
mov rax,0x0f
call emit_byte
sub r15,0x100
emit_mem_one_byte_opcode:
mov rax,r15
call emit_byte
db 73,131,225,7,73,131,227,7,73,193,225,3
mov rdx,[rbx+24]
db 72,247,218
mov rcx,[rbx+16]
db 72,33,202
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
db 72,193,232,8
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
emit_mem_sib:
mov rax,[rbx+40]
db 72,193,224,6
mov rcx,[rbx+48]
cmp rcx,1
jne emit_mem_sib_no_index
mov rcx,[rbx+32]
db 72,131,225,7,72,193,225,3
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
db 72,193,232,32
cmp rax,0
jne range_error
mov rbx,rdx
mov r11,4
call emit_le
ret
handle_test:
db 15,182,67,4
mov rdx,op_misc+IMAGE_VA
mov [rdx],rax
db 15,182,67,5
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
db 72,193,232,8
cmp rax,0
je test_r8_imm_ok
mov rax,r15
add rax,128
db 72,193,232,8
cmp rax,0
jne syntax_error
test_r8_imm_ok:
mov rbx,op1+IMAGE_VA
mov r9,[rbx+8]
mov rax,0x40
cmp r9,8
db 15,146,193
cmp cl,1
je test_r8_imm_force_check
add rax,1
test_r8_imm_force_check:
cmp rax,0x40
jne test_r8_imm_emit_rex
cmp r9,4
db 15,146,193
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
db 72,131,224,7
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
db 72,193,232,32
cmp rax,0
jne syntax_error
mov rbx,op1+IMAGE_VA
mov r9,[rbx+8]
mov rax,0x48
cmp r9,8
db 15,146,193,15,182,201
cmp rcx,1
je test_r64_rex_ready
add rax,1
test_r64_rex_ready:
call emit_byte
mov rbx,op_misc+IMAGE_VA
mov rax,[rbx+8]
call emit_byte
mov rax,r9
db 72,131,224,7
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
db 72,131,224,8
cmp rax,0
je test_gpr_imm_opcode
mov rax,0x41
call emit_byte
test_gpr_imm_opcode:
mov rbx,op_misc+IMAGE_VA
mov rax,[rbx+8]
call emit_byte
mov rax,r9
db 72,131,224,7
add rax,0xc0
call emit_byte
mov rbx,r15
mov r11,r10
call emit_le
ret
handle_db:
mov rsi,rbx
add rsi,3
db 15,182,6
mov rdx,op_misc+IMAGE_VA
mov [rdx+72],rax
mov rsi,r8
call skip_spaces
db 15,182,22
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
db 15,182,22
cmp rdx,0
jne syntax_error
call handle_data_emit
mov rsi,r8
call skip_spaces
db 15,182,22
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
db 15,182,22
cmp rdx,0
je syntax_error
cmp rdx,44
je syntax_error
cmp rdx,59
je syntax_error
mov r8,rsi
jmp handle_db_next
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
db 72,193,232,8
cmp rax,0
jne range_error
jmp handle_data_write
handle_data_check16:
db 72,193,232,16
cmp rax,0
jne range_error
jmp handle_data_write
handle_data_check32:
db 72,193,232,32
cmp rax,0
jne range_error
handle_data_write:
mov rbx,r15
mov rdx,op_misc+IMAGE_VA
mov r11,[rdx+72]
call emit_le
ret
handle_equ:
call validate_symbol_name
mov rsi,token_buffer+IMAGE_VA
mov rdi,name_buffer+IMAGE_VA
handle_equ_copy:
db 15,182,6
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
db 15,182,22
cmp rdx,0
jne syntax_error
mov rsi,r8
call skip_spaces
db 15,182,22
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
mov rcx,[rbp+16]
sub rcx,1
db 72,193,225,3
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
mov rax,r15
add rax,128
cmp rax,384
db 72,25,201
cmp rcx,0
je range_error
mov rbx,op1+IMAGE_VA
mov r9,[rbx+8]
mov rax,0x40
cmp r9,8
db 15,146,193
cmp cl,1
je mov_r8_imm_force_check
add rax,1
mov_r8_imm_force_check:
cmp rax,0x40
jne mov_r8_imm_emit_rex
cmp r9,4
db 15,146,193
cmp cl,1
je mov_r8_imm_opcode
mov_r8_imm_emit_rex:
call emit_byte
mov_r8_imm_opcode:
mov rax,r9
db 72,131,224,7
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
db 72,193,232,32
cmp rax,0
je mov_r32_imm_range_ok
mov rcx,0xffffffff
cmp rax,rcx
jne range_error
mov rax,r15
db 72,193,232,31,72,131,224,1
cmp rax,1
jne range_error
mov_r32_imm_range_ok:
cmp r9,8
db 15,146,193,15,182,201
cmp rcx,1
je mov_r32_imm_opcode
mov rax,0x41
call emit_byte
mov_r32_imm_opcode:
mov rax,r9
db 72,131,224,7
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
db 72,193,232,16
cmp rax,0
je mov_r16_imm_range_ok
mov rcx,0xffffffffffff
cmp rax,rcx
jne range_error
mov rax,r15
db 72,193,232,15,72,131,224,1
cmp rax,1
jne range_error
mov_r16_imm_range_ok:
mov rax,0x66
call emit_byte
cmp r9,8
db 15,146,193,15,182,201
cmp rcx,1
je mov_r16_imm_opcode
mov rax,0x41
call emit_byte
mov_r16_imm_opcode:
mov rax,r9
db 72,131,224,7
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
db 15,146,193,15,182,201
cmp rcx,1
je mov_imm_low
add r10,1
mov_imm_low:
mov r11,r9
db 73,131,227,7
mov rax,r15
db 72,193,232,31
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
handle_alu:
db 15,182,67,4
mov rdx,op_misc+IMAGE_VA
mov [rdx],rax
db 15,182,67,5
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
db 72,193,232,8
cmp rax,0
je alu_r8_imm_ok
mov rax,r15
add rax,128
db 72,193,232,8
cmp rax,0
jne syntax_error
alu_r8_imm_ok:
mov rbx,op1+IMAGE_VA
mov r9,[rbx+8]
mov rax,0x40
cmp r9,8
db 15,146,193
cmp cl,1
je alu_r8_imm_force_check
add rax,1
alu_r8_imm_force_check:
cmp rax,0x40
jne alu_r8_imm_emit_rex
cmp r9,4
db 15,146,193
cmp cl,1
je alu_r8_imm_opcode
alu_r8_imm_emit_rex:
call emit_byte
alu_r8_imm_opcode:
mov rax,0x80
call emit_byte
mov rbx,op_misc+IMAGE_VA
mov rax,[rbx+8]
db 72,193,224,3
mov rdx,r9
db 72,131,226,7
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
db 15,146,193,15,182,201
cmp rcx,1
je alu_imm_low
add r10,1
alu_imm_low:
mov r11,r9
db 73,131,227,7
mov rbx,op_misc+IMAGE_VA
mov rdx,[rbx+8]
db 72,193,226,3
add rdx,r11
add rdx,0xc0
mov rax,r15
add rax,128
db 72,193,232,8
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
db 72,193,232,32
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
db 72,193,232,8
cmp rax,0
je alu_gpr_imm_short
mov rax,r15
db 72,193,232,7,72,131,224,1
cmp rax,1
jne alu_gpr_imm_full
cmp r10,2
jne alu_gpr_imm_short32_check
mov rax,r15
db 72,193,232,8
cmp rax,0xff
je alu_gpr_imm_short
jmp alu_gpr_imm_full
alu_gpr_imm_short32_check:
mov rax,r15
db 72,193,232,8
mov rcx,-1
db 72,193,233,40
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
db 72,131,224,8
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
db 72,193,224,3
mov rcx,r9
db 72,131,225,7
add rax,rcx
add rax,0xc0
call emit_byte
mov rbx,r15
call emit_le
ret
validate_gpr_immediate_width:
cmp r10,2
jne validate_gpr_immediate_32
mov rax,r15
db 72,193,232,16
cmp rax,0
je validate_gpr_immediate_ok
mov rcx,-1
db 72,193,233,16
cmp rax,rcx
jne range_error
mov rax,r15
db 72,193,232,15,72,131,224,1
cmp rax,1
jne range_error
ret
validate_gpr_immediate_32:
mov rax,r15
db 72,193,232,32
cmp rax,0
je validate_gpr_immediate_ok
mov rcx,-1
db 72,193,233,32
cmp rax,rcx
jne range_error
mov rax,r15
db 72,193,232,31,72,131,224,1
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
isa_table:
db (lit_db-lit_db+1)&255,1,0,1,0,0,2,8
db (lit_dw-lit_db+1)&255,1,0,2,0,0,2,8
db (lit_dd-lit_db+1)&255,1,0,4,0,0,2,8
db (lit_dq-lit_db+1)&255,1,0,8,0,0,2,8
db (lit_nop-lit_db+1)&255,27,1,1,0x90,0,1,1
db (lit_ret-lit_db+1)&255,27,1,1,0xc3,0,1,1
db (lit_syscall-lit_db+1)&255,27,1,2,0x0f,0x05,1,1
db (lit_mov-lit_db+1)&255,5,0,0,0,0,0,0
db (lit_add-lit_db+1)&255,39,3,2,0x01,0,3,3
db (lit_sub-lit_db+1)&255,39,3,2,0x29,5,3,3
db (lit_xor-lit_db+1)&255,39,3,2,0x31,6,3,3
db (lit_cmp-lit_db+1)&255,39,3,2,0x39,7,3,3
db (lit_jmp-lit_db+1)&255,10,5,2,0xe9,0xeb,4,5
db (lit_call-lit_db+1)&255,11,7,1,0xe8,0,4,7
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
db (lit_mul-lit_db+1)&255,38,6,2,0xf6,4,5,6
db (lit_imul-lit_db+1)&255,38,6,2,0xf6,5,5,6
db (lit_div-lit_db+1)&255,38,6,2,0xf6,6,5,6
db (lit_idiv-lit_db+1)&255,38,6,2,0xf6,7,5,6
db (lit_bt-lit_db+1)&255,41,0,0,0xa3,4,0,0
db (lit_bts-lit_db+1)&255,41,0,0,0xab,5,0,0
db (lit_btr-lit_db+1)&255,41,0,0,0xb3,6,0,0
db (lit_btc-lit_db+1)&255,41,0,0,0xbb,7,0,0
db 0,0,0,0,0,0,0,0,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,89,0,4,10,13,20,21,22,23,24,28,48,49,51,56,60,62,65,66,72,79,81,82,83,84,87,88,89,89,89,89,89,8,33,34,255,52,59,60,61,62,255,11,13,255,0,1,2,3,42,57,255,255,255,255,255,41,56,58,255,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,255,255,37,255,7,53,54,55,255,4,43,44,255,32,255,39,40,255,255,5,48,49,50,51,255,6,9,35,45,46,47,255,36,255,255,255,255,10,38,255,255,255,255
condition_suffix_table:
db 111,0,0,110,111,1,98,0,2,97,101,3,101,0,4,110,101,5,98,101,6,97,0,7,115,0,8,110,115,9,112,0,10,110,112,11,108,0,12,103,101,13,108,101,14,103,0,15,122,0,4,110,122,5
condition_suffix_table_end:
lit_hex_digits:
db 48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102,0
lit_equ:
db 101,113,117,0
reg_table:
db 114,97,120,0,0,0,0,0,114,99,120,0,0,0,0,0,114,100,120,0,0,0,0,0,114,98,120,0,0,0,0,0,114,115,112,0,0,0,0,0,114,98,112,0,0,0,0,0,114,115,105,0,0,0,0,0,114,100,105,0,0,0,0,0,114,56,0,0,0,0,0,0,114,57,0,0,0,0,0,0,114,49,48,0,0,0,0,0,114,49,49,0,0,0,0,0,114,49,50,0,0,0,0,0,114,49,51,0,0,0,0,0,114,49,52,0,0,0,0,0,114,49,53,0,0,0,0,0,97,108,0,0,0,0,0,0,99,108,0,0,0,0,0,0,100,108,0,0,0,0,0,0,98,108,0,0,0,0,0,0,115,112,108,0,0,0,0,0,98,112,108,0,0,0,0,0,115,105,108,0,0,0,0,0,100,105,108,0,0,0,0,0,114,56,98,0,0,0,0,0,114,57,98,0,0,0,0,0,114,49,48,98,0,0,0,0,114,49,49,98,0,0,0,0,114,49,50,98,0,0,0,0,114,49,51,98,0,0,0,0,114,49,52,98,0,0,0,0,114,49,53,98,0,0,0,0,101,97,120,0,0,0,0,0,101,99,120,0,0,0,0,0,101,100,120,0,0,0,0,0,101,98,120,0,0,0,0,0,101,115,112,0,0,0,0,0,101,98,112,0,0,0,0,0,101,115,105,0,0,0,0,0,101,100,105,0,0,0,0,0,114,56,100,0,0,0,0,0,114,57,100,0,0,0,0,0,114,49,48,100,0,0,0,0,114,49,49,100,0,0,0,0,114,49,50,100,0,0,0,0,114,49,51,100,0,0,0,0,114,49,52,100,0,0,0,0,114,49,53,100,0,0,0,0,97,120,0,0,0,0,0,0,99,120,0,0,0,0,0,0,100,120,0,0,0,0,0,0,98,120,0,0,0,0,0,0,115,112,0,0,0,0,0,0,98,112,0,0,0,0,0,0,115,105,0,0,0,0,0,0,100,105,0,0,0,0,0,0,114,56,119,0,0,0,0,0,114,57,119,0,0,0,0,0,114,49,48,119,0,0,0,0,114,49,49,119,0,0,0,0,114,49,50,119,0,0,0,0,114,49,51,119,0,0,0,0,114,49,52,119,0,0,0,0,114,49,53,119,0,0,0,0
msg_input:
db 82,85,65,83,77,58,32,69,95,73,78,80,85,84,58,32,102,97,105,108,101,100,32,116,111,32,114,101,97,100,32,115,111,117,114,99,101,32,105,110,112,117,116,10
msg_input_end:
msg_syntax:
db 82,85,65,83,77,58,32,69,95,83,89,78,84,65,88,32,97,116,32,108,105,110,101,32
msg_syntax_end:
state_base:
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
input_buffer:
cli_start:
mov rbp,state_base+IMAGE_VA
mov rbx,cli_state+IMAGE_VA
xor rax,rax
mov [rbx+72],rax
mov [rbx+80],rax
mov [rbx+88],rax
mov [rbx+96],rax
mov rax,[rsp]
cmp rax,2
je cli_single_argument
cmp rax,3
je cli_positional_output
cmp rax,4
je cli_option_output_or_check
cmp rax,5
je cli_option_output_with_flag
jmp cli_usage_error
cli_option_output_with_flag:
mov rsi,[rsp+40]
mov rdi,lit_quiet+IMAGE_VA
call string_equal
cmp rax,1
je cli_set_quiet
mov rsi,[rsp+40]
mov rdi,lit_q+IMAGE_VA
call string_equal
cmp rax,1
je cli_set_quiet
mov rsi,[rsp+40]
mov rdi,lit_time+IMAGE_VA
call string_equal
cmp rax,1
je cli_option_output
mov rsi,[rsp+40]
mov rdi,lit_diagnostics_json+IMAGE_VA
call string_equal
cmp rax,1
je cli_set_json_diagnostics
jmp cli_usage_error
cli_set_quiet:
mov rbx,cli_state+IMAGE_VA
mov rax,1
mov [rbx+72],rax
jmp cli_option_output
cli_set_json_diagnostics:
mov rbx,cli_state+IMAGE_VA
mov rax,1
mov [rbx+80],rax
jmp cli_option_output
cli_option_output:
mov rsi,[rsp+24]
mov rdi,lit_output+IMAGE_VA
call string_equal
cmp rax,1
jne cli_usage_error
mov rbx,cli_state+IMAGE_VA
mov rax,[rsp+16]
mov [rbx],rax
mov rax,[rsp+32]
mov [rbx+8],rax
jmp cli_check_paths
cli_positional_output:
mov rsi,[rsp+24]
mov rdi,lit_check+IMAGE_VA
call string_equal
cmp rax,1
je cli_set_check
mov rsi,[rsp+24]
db 15,182,6
cmp rax,45
je cli_usage_error
mov rbx,cli_state+IMAGE_VA
mov rax,[rsp+16]
mov [rbx],rax
mov rax,[rsp+24]
mov [rbx+8],rax
jmp cli_check_paths
cli_option_output_or_check:
mov rsi,[rsp+24]
mov rdi,lit_check+IMAGE_VA
call string_equal
cmp rax,1
jne cli_option_output
mov rsi,[rsp+32]
mov rdi,lit_diagnostics_json+IMAGE_VA
call string_equal
cmp rax,1
jne cli_set_check
mov rbx,cli_state+IMAGE_VA
mov rax,1
mov [rbx+80],rax
jmp cli_set_check
cli_set_check:
mov rbx,cli_state+IMAGE_VA
mov rax,[rsp+16]
mov [rbx],rax
mov rax,1
mov [rbx+88],rax
jmp cli_open_source
cli_single_argument:
mov rsi,[rsp+16]
mov rdi,lit_version_json+IMAGE_VA
call string_equal
cmp rax,1
je cli_show_version_json
mov rsi,[rsp+16]
mov rdi,lit_features_json+IMAGE_VA
call string_equal
cmp rax,1
je cli_show_features_json
mov rsi,[rsp+16]
mov rdi,lit_version+IMAGE_VA
call string_equal
cmp rax,1
je cli_show_version
mov rsi,[rsp+16]
mov rdi,lit_help+IMAGE_VA
call string_equal
cmp rax,1
je cli_show_help
mov rsi,[rsp+16]
mov rdi,lit_features+IMAGE_VA
call string_equal
cmp rax,1
je cli_show_features
mov rsi,[rsp+16]
db 15,182,6
cmp rax,45
je cli_usage_error
mov rbx,cli_state+IMAGE_VA
mov rax,[rsp+16]
mov [rbx],rax
mov rsi,rax
mov rdi,default_output_path+IMAGE_VA
mov rax,default_output_path+IMAGE_VA
mov [rbx+8],rax
xor rcx,rcx
cli_default_copy:
mov al,[rsi]
mov [rdi],al
cmp al,0
je cli_default_suffix
add rsi,1
add rdi,1
add rcx,1
cmp rcx,3980
jne cli_default_copy
jmp cli_usage_error
cli_default_suffix:
mov rax,46
db 136,7
add rdi,1
mov rax,98
db 136,7
add rdi,1
mov rax,105
db 136,7
add rdi,1
mov rax,110
db 136,7
add rdi,1
mov rax,0
db 136,7
jmp cli_check_paths
cli_check_paths:
mov rbx,cli_state+IMAGE_VA
mov rsi,[rbx]
mov rdi,[rbx+8]
call string_equal
cmp rax,1
je cli_usage_error
jmp cli_open_source
cli_show_version:
mov rax,1
mov rdi,1
mov rsi,msg_version+IMAGE_VA
mov rdx,msg_version_end-msg_version
syscall
mov rax,60
xor rdi,rdi
syscall
cli_show_version_json:
mov rax,1
mov rdi,1
mov rsi,msg_version_json+IMAGE_VA
mov rdx,msg_version_json_end-msg_version_json
syscall
mov rax,60
xor rdi,rdi
syscall
cli_show_help:
mov rax,1
mov rdi,1
mov rsi,msg_help+IMAGE_VA
mov rdx,msg_help_end-msg_help
syscall
mov rax,60
xor rdi,rdi
syscall
cli_show_features:
mov rax,1
mov rdi,1
mov rsi,msg_features+IMAGE_VA
mov rdx,msg_features_end-msg_features
syscall
mov rax,60
xor rdi,rdi
syscall
cli_show_features_json:
mov rax,1
mov rdi,1
mov rsi,msg_features_json_prefix+IMAGE_VA
mov rdx,msg_features_json_prefix_end-msg_features_json_prefix
syscall
mov rbx,isa_table+IMAGE_VA
xor r12,r12
cli_features_loop:
db 15,182,11
cmp rcx,0
je cli_features_done
mov rax,lit_db-1+IMAGE_VA
add rax,rcx
mov r13,rax
cmp r12,0
je cli_features_no_comma
mov rax,1
mov rdi,1
mov rsi,msg_json_comma+IMAGE_VA
mov rdx,1
syscall
cli_features_no_comma:
mov rax,1
mov rdi,1
mov rsi,msg_json_quote+IMAGE_VA
mov rdx,1
syscall
mov rsi,r13
xor rdx,rdx
cli_features_name_length:
db 15,182,6
cmp rax,0
je cli_features_name_ready
add rsi,1
add rdx,1
jmp cli_features_name_length
cli_features_name_ready:
mov rax,1
mov rdi,1
mov rsi,r13
syscall
mov rax,1
mov rdi,1
mov rsi,msg_json_quote+IMAGE_VA
mov rdx,1
syscall
add rbx,8
add r12,1
jmp cli_features_loop
cli_features_done:
mov rax,1
mov rdi,1
mov rsi,msg_features_json_suffix+IMAGE_VA
mov rdx,msg_features_json_suffix_end-msg_features_json_suffix
syscall
call cli_emit_isa_model
mov rax,60
xor rdi,rdi
syscall
cli_write_stdout:
mov rax,1
mov rdi,1
syscall
ret
cli_usage_error:
mov rax,1
mov rdi,2
mov rsi,msg_usage+IMAGE_VA
mov rdx,msg_usage_end-msg_usage
syscall
mov rax,60
mov rdi,2
syscall
cli_open_source:
mov rbx,cli_state+IMAGE_VA
mov rax,2
mov rdi,[rbx]
xor rsi,rsi
xor rdx,rdx
syscall
cmp rax,0-2
je input_error
cmp rax,0-13
je input_error
cmp rax,0-20
je input_error
cmp rax,0-21
je input_error
cmp rax,0-22
je input_error
mov rbx,cli_state+IMAGE_VA
mov [rbx+16],rax
mov rax,5
mov rdi,[rbx+16]
mov rsi,cli_state+IMAGE_VA+256
syscall
cmp rax,0
jne input_error
mov rax,262
mov rdi,0-100
mov rsi,[rbx+8]
mov rdx,cli_state+IMAGE_VA+512
xor r10,r10
syscall
cmp rax,0
jne cli_open_source_identity_done
mov rsi,cli_state+IMAGE_VA+256
mov rdi,cli_state+IMAGE_VA+512
mov rax,[rsi]
mov rcx,[rdi]
cmp rax,rcx
jne cli_open_source_identity_done
mov rax,[rsi+8]
mov rcx,[rdi+8]
cmp rax,rcx
je cli_usage_error
cli_open_source_identity_done:
mov r12,input_buffer+0x40000+IMAGE_VA
xor r13,r13
mov r15,0x30000
cli_read_loop:
mov rax,0
mov rbx,cli_state+IMAGE_VA
mov rdi,[rbx+16]
mov rsi,r12
mov rdx,r15
sub rdx,r13
syscall
cmp rax,0
je cli_read_done
cmp rax,0-4
je cli_read_loop
cmp rax,0-5
je input_error
cmp rax,0-9
je input_error
cmp rax,0-22
je input_error
mov rcx,rax
db 72,193,233,31,72,193,233,31,72,131,225,2
cmp rcx,2
je input_error
add r12,rax
add r13,rax
cmp r13,r15
je input_error
jmp cli_read_loop
cli_read_done:
mov rbx,cli_state+IMAGE_VA
mov [rbx+24],r13
mov rax,3
mov rdi,[rbx+16]
syscall
mov r12,input_buffer+0x40000+IMAGE_VA
mov rbx,equ_source+IMAGE_VA
mov [rbx],r12
mov r13,r12
mov rbx,cli_state+IMAGE_VA
mov rax,[rbx+24]
add r13,rax
mov r14,output_buffer+IMAGE_VA
mov rbx,diag_line+IMAGE_VA
xor rax,rax
mov [rbx],rax
mov [rbp+0],rax
mov [rbp+8],rax
mov [rbp+16],rax
mov rbx,branch_cycle_history+IMAGE_VA
mov [rbx],rax
mov rdi,branch_short_map+IMAGE_VA
mov rcx,3072
branch_map_clear_loop:
mov [rdi],rax
add rdi,8
sub rcx,1
cmp rcx,0
jne branch_map_clear_loop
mov rdi,branch_forced_map+IMAGE_VA
mov rcx,3072
branch_forced_map_clear_loop:
mov [rdi],rax
add rdi,8
sub rcx,1
cmp rcx,0
jne branch_forced_map_clear_loop
mov rbx,branch_short_count+IMAGE_VA
mov [rbx],rax
call build_statement_ir
mov rax,228
mov rdi,1
mov rsi,time_start+IMAGE_VA
syscall
jmp main_loop
finish_file:
mov rax,[rbp+8]
mov rbx,cli_state+IMAGE_VA
mov [rbx+32],rax
mov rax,228
mov rdi,1
mov rsi,time_end+IMAGE_VA
syscall
mov rbx,cli_state+IMAGE_VA
mov rax,[rbx+88]
cmp rax,1
je cli_check_success
jmp cli_publish_output
cli_publish_output:
mov rsi,[rbx+8]
mov rdi,temp_path+IMAGE_VA
xor rcx,rcx
jmp cli_copy_output_path
cli_check_success:
mov rax,1
mov rdi,1
mov rsi,msg_check_success+IMAGE_VA
mov rdx,msg_check_success_end-msg_check_success
syscall
mov rax,60
xor rdi,rdi
syscall
cli_copy_output_path:
xor rax,rax
mov al,[rsi]
mov [rdi],al
cmp rax,0
je cli_suffix_start
add rsi,1
add rdi,1
add rcx,1
cmp rcx,4000
jne cli_copy_output_path
jmp cli_output_error
cli_suffix_start:
mov al,46
mov [rdi],al
add rdi,1
mov al,114
mov [rdi],al
add rdi,1
mov al,117
mov [rdi],al
add rdi,1
mov al,97
mov [rdi],al
add rdi,1
mov al,115
mov [rdi],al
add rdi,1
mov al,109
mov [rdi],al
add rdi,1
mov al,46
mov [rdi],al
add rdi,1
mov al,116
mov [rdi],al
add rdi,1
mov al,109
mov [rdi],al
add rdi,1
mov al,112
mov [rdi],al
add rdi,1
mov al,46
mov [rdi],al
add rdi,1
mov rbx,cli_state+IMAGE_VA
mov [rbx+104],rdi
mov rax,39
syscall
mov r8,rax
mov rdi,number_buffer+31+IMAGE_VA
xor rcx,rcx
mov rbx,10
cli_pid_digits:
mov rax,r8
xor rdx,rdx
db 72,247,243
add rdx,48
mov [rdi],dl
sub rdi,1
add rcx,1
mov r8,rax
cmp r8,0
jne cli_pid_digits
add rdi,1
mov rbx,cli_state+IMAGE_VA
mov rsi,rdi
mov rdi,[rbx+104]
cli_pid_copy:
mov al,[rsi]
mov [rdi],al
add rsi,1
add rdi,1
sub rcx,1
cmp rcx,0
jne cli_pid_copy
xor rax,rax
mov [rdi],al
mov rax,2
mov rdi,temp_path+IMAGE_VA
mov rsi,193
mov rdx,420
mov rbx,output_buffer+IMAGE_VA
mov al,[rbx]
cmp al,127
jne cli_open_temp
add rbx,1
mov al,[rbx]
cmp al,69
jne cli_open_temp
add rbx,1
mov al,[rbx]
cmp al,76
jne cli_open_temp
add rbx,1
mov al,[rbx]
cmp al,70
jne cli_open_temp
mov rdx,493
cli_open_temp:
mov rax,2
mov rdi,temp_path+IMAGE_VA
mov rsi,193
syscall
cmp rax,0-2
je cli_output_error
cmp rax,0-13
je cli_output_error
cmp rax,0-17
je cli_output_error
mov rbx,cli_state+IMAGE_VA
mov [rbx+16],rax
mov rax,1
mov [rbx+96],rax
mov r12,output_buffer+IMAGE_VA
mov r13,[rbx+32]
cli_write_loop:
cmp r13,0
je cli_write_done
mov rax,1
mov rbx,cli_state+IMAGE_VA
mov rdi,[rbx+16]
mov rsi,r12
mov rdx,r13
syscall
cmp rax,0
je cli_output_error
cmp rax,0-4
je cli_write_loop
mov rcx,rax
db 72,193,233,31,72,193,233,31,72,131,225,2
cmp rcx,2
je cli_output_error
add r12,rax
sub r13,rax
jmp cli_write_loop
cli_write_done:
mov rbx,cli_state+IMAGE_VA
mov rax,3
mov rdi,[rbx+16]
syscall
mov rax,82
mov rdi,temp_path+IMAGE_VA
mov rbx,cli_state+IMAGE_VA
mov rsi,[rbx+8]
syscall
cmp rax,0
jne cli_output_error
mov rbx,cli_state+IMAGE_VA
xor rax,rax
mov [rbx+96],rax
mov rax,[rbx+72]
cmp rax,1
je cli_exit_success
jmp cli_print_stats
cli_exit_success:
mov rax,60
xor rdi,rdi
syscall
cli_output_error:
mov rbx,cli_state+IMAGE_VA
mov rax,[rbx+96]
cmp rax,1
jne cli_output_error_no_temp
mov rax,87
mov rdi,temp_path+IMAGE_VA
syscall
mov rbx,cli_state+IMAGE_VA
xor rax,rax
mov [rbx+96],rax
cli_output_error_no_temp:
mov rbx,cli_state+IMAGE_VA
mov rax,[rbx+80]
cmp rax,1
je cli_output_error_json
mov rsi,msg_output_error+IMAGE_VA
mov rdx,msg_output_error_end-msg_output_error
call write_stderr
mov rax,60
mov rdi,2
syscall
cli_output_error_json:
mov rsi,msg_json_output+IMAGE_VA
mov rdx,msg_json_output_end-msg_json_output
call write_stderr
mov rax,60
mov rdi,2
syscall
cli_print_stats:
mov rax,1
mov rdi,2
mov rsi,msg_success+IMAGE_VA
mov rdx,msg_success_end-msg_success
syscall
mov rsi,time_end+IMAGE_VA
mov rax,[rsi]
mov rsi,time_start+IMAGE_VA
mov rbx,[rsi]
sub rax,rbx
mov rbx,1000000000
db 72,247,227
mov r8,rax
mov rsi,time_end+IMAGE_VA
mov rax,[rsi+8]
mov rsi,time_start+IMAGE_VA
mov rbx,[rsi+8]
sub rax,rbx
mov rdx,rax
db 72,193,234,63
cmp rdx,1
jne cli_time_no_borrow
sub r8,1000000000
add rax,1000000000
cli_time_no_borrow:
add r8,rax
mov rax,r8
xor rdx,rdx
mov rbx,1000
db 72,247,243
call print_u64
mov rax,1
mov rdi,2
mov rsi,msg_microseconds+IMAGE_VA
mov rdx,msg_microseconds_end-msg_microseconds
syscall
mov rbx,cli_state+IMAGE_VA
mov rax,[rbx+32]
call print_u64
mov rax,1
mov rdi,2
mov rsi,msg_bytes+IMAGE_VA
mov rdx,msg_bytes_end-msg_bytes
syscall
mov rax,1
mov rdi,2
mov rsi,msg_layout_passes+IMAGE_VA
mov rdx,msg_layout_passes_end-msg_layout_passes
syscall
mov rbx,ir_needs_layout+IMAGE_VA
mov rax,[rbx]
cmp rax,0
jne cli_layout_stats_normal
mov rax,1
jmp cli_layout_stats_emit
cli_layout_stats_normal:
mov rbx,equ_iterations+IMAGE_VA
mov rax,[rbx]
add rax,3
cli_layout_stats_emit:
call print_u64
mov rax,1
mov rdi,2
mov rsi,msg_newline+IMAGE_VA
mov rdx,msg_newline_end-msg_newline
syscall
mov rax,1
mov rdi,2
mov rsi,msg_short_branches+IMAGE_VA
mov rdx,msg_short_branches_end-msg_short_branches
syscall
mov rbx,branch_short_count+IMAGE_VA
mov rax,[rbx]
call print_u64
mov rax,1
mov rdi,2
mov rsi,msg_newline+IMAGE_VA
mov rdx,msg_newline_end-msg_newline
syscall
mov rax,60
xor rdi,rdi
syscall
print_u64:
mov r8,rax
mov rdi,number_buffer+31+IMAGE_VA
xor rcx,rcx
mov rbx,10
print_u64_loop:
mov rax,r8
xor rdx,rdx
db 72,247,243
add rdx,48
mov [rdi],dl
sub rdi,1
add rcx,1
mov r8,rax
cmp r8,0
jne print_u64_loop
add rdi,1
mov rsi,rdi
mov rdx,rcx
mov rax,1
mov rdi,2
syscall
ret
lit_output:
db 45,111,0
lit_quiet:
db 45,45,113,117,105,101,116,0
lit_q:
db 45,113,0
lit_time:
db 45,45,116,105,109,101,0
lit_diagnostics_json:
db 45,45,100,105,97,103,110,111,115,116,105,99,115,61,106,115,111,110,0
lit_version:
db 45,45,118,101,114,115,105,111,110,0
lit_help:
db 45,45,104,101,108,112,0
lit_features:
db 45,45,102,101,97,116,117,114,101,115,0
lit_check:
db 45,45,99,104,101,99,107,0
lit_version_json:
db 45,45,118,101,114,115,105,111,110,61,106,115,111,110,0
lit_features_json:
db 45,45,102,101,97,116,117,114,101,115,61,106,115,111,110,0
msg_version_json:
db 123,34,115,99,104,101,109,97,95,118,101,114,115,105,111,110,34,58,49,44,34,110,97,109,101,34,58,34,82,85,65,83,77,34,44,34,118,101,114,115,105,111,110,34,58,34,49,46,49,49,46,53,34,44,34,104,111,115,116,34,58,34,108,105,110,117,120,45,120,56,54,95,54,52,34,44,34,116,97,114,103,101,116,34,58,34,120,56,54,95,54,52,34,44,34,115,101,108,102,95,104,111,115,116,101,100,34,58,116,114,117,101,44,34,111,117,116,112,117,116,95,102,111,114,109,97,116,34,58,34,102,108,97,116,45,98,105,110,97,114,121,34,125,10
msg_version_json_end:
msg_features_json_prefix:
db 123,34,115,99,104,101,109,97,95,118,101,114,115,105,111,110,34,58,50,57,44,34,99,111,109,112,105,108,101,114,34,58,123,34,110,97,109,101,34,58,34,82,85,65,83,77,34,44,34,118,101,114,115,105,111,110,34,58,34,49,46,49,49,46,53,34,44,34,104,111,115,116,34,58,34,108,105,110,117,120,45,120,56,54,95,54,52,34,44,34,116,97,114,103,101,116,34,58,34,120,56,54,95,54,52,34,44,34,115,101,108,102,95,104,111,115,116,101,100,34,58,116,114,117,101,125,44,34,111,117,116,112,117,116,34,58,123,34,102,111,114,109,97,116,34,58,34,102,108,97,116,45,98,105,110,97,114,121,34,44,34,109,97,120,95,98,121,116,101,115,34,58,54,53,53,51,54,125,44,34,115,111,117,114,99,101,34,58,123,34,109,97,120,95,98,121,116,101,115,34,58,49,57,54,54,48,55,44,34,109,97,120,95,108,105,110,101,95,98,121,116,101,115,34,58,52,48,57,53,44,34,109,97,120,95,116,111,107,101,110,95,98,121,116,101,115,34,58,54,53,44,34,99,97,115,101,95,115,101,110,115,105,116,105,118,101,34,58,116,114,117,101,44,34,111,110,101,95,115,116,97,116,101,109,101,110,116,95,112,101,114,95,108,105,110,101,34,58,116,114,117,101,125,44,34,100,105,114,101,99,116,105,118,101,115,34,58,91,34,68,66,34,44,34,68,87,34,44,34,68,68,34,44,34,68,81,34,44,34,69,81,85,34,93,44,34,100,97,116,97,34,58,123,34,68,66,34,58,123,34,115,121,110,116,97,120,34,58,34,100,98,32,101,120,112,114,91,44,101,120,112,114,46,46,46,93,34,44,34,118,97,108,117,101,95,114,97,110,103,101,34,58,34,48,46,46,50,53,53,34,44,34,119,105,100,116,104,95,98,121,116,101,115,34,58,49,44,34,98,121,116,101,95,111,114,100,101,114,34,58,34,108,105,116,116,108,101,45,101,110,100,105,97,110,34,44,34,101,120,112,114,101,115,115,105,111,110,115,34,58,116,114,117,101,125,44,34,68,87,34,58,123,34,115,121,110,116,97,120,34,58,34,100,119,32,101,120,112,114,91,44,101,120,112,114,46,46,46,93,34,44,34,118,97,108,117,101,95,114,97,110,103,101,34,58,34,48,46,46,54,53,53,51,53,34,44,34,119,105,100,116,104,95,98,121,116,101,115,34,58,50,44,34,98,121,116,101,95,111,114,100,101,114,34,58,34,108,105,116,116,108,101,45,101,110,100,105,97,110,34,44,34,101,120,112,114,101,115,115,105,111,110,115,34,58,116,114,117,101,125,44,34,68,68,34,58,123,34,115,121,110,116,97,120,34,58,34,100,100,32,101,120,112,114,91,44,101,120,112,114,46,46,46,93,34,44,34,118,97,108,117,101,95,114,97,110,103,101,34,58,34,48,46,46,52,50,57,52,57,54,55,50,57,53,34,44,34,119,105,100,116,104,95,98,121,116,101,115,34,58,52,44,34,98,121,116,101,95,111,114,100,101,114,34,58,34,108,105,116,116,108,101,45,101,110,100,105,97,110,34,44,34,101,120,112,114,101,115,115,105,111,110,115,34,58,116,114,117,101,125,44,34,68,81,34,58,123,34,115,121,110,116,97,120,34,58,34,100,113,32,101,120,112,114,91,44,101,120,112,114,46,46,46,93,34,44,34,118,97,108,117,101,95,114,97,110,103,101,34,58,34,48,46,46,49,56,52,52,54,55,52,52,48,55,51,55,48,57,53,53,49,54,49,53,34,44,34,119,105,100,116,104,95,98,121,116,101,115,34,58,56,44,34,98,121,116,101,95,111,114,100,101,114,34,58,34,108,105,116,116,108,101,45,101,110,100,105,97,110,34,44,34,101,120,112,114,101,115,115,105,111,110,115,34,58,116,114,117,101,125,125,44,34,101,120,112,114,101,115,115,105,111,110,115,34,58,123,34,108,105,116,101,114,97,108,115,34,58,91,34,100,101,99,105,109,97,108,34,44,34,48,120,45,112,114,101,102,105,120,101,100,45,104,101,120,97,100,101,99,105,109,97,108,34,93,44,34,117,110,97,114,121,34,58,91,34,43,34,44,34,45,34,93,44,34,98,105,110,97,114,121,34,58,91,34,43,34,44,34,45,34,44,34,60,60,34,44,34,62,62,34,44,34,38,34,44,34,124,34,93,44,34,112,97,114,101,110,116,104,101,115,101,115,34,58,116,114,117,101,125,44,34,114,101,103,105,115,116,101,114,115,34,58,123,34,114,54,52,34,58,91,34,114,97,120,34,44,34,114,99,120,34,44,34,114,100,120,34,44,34,114,98,120,34,44,34,114,115,112,34,44,34,114,98
db 112,34,44,34,114,115,105,34,44,34,114,100,105,34,44,34,114,56,34,44,34,114,57,34,44,34,114,49,48,34,44,34,114,49,49,34,44,34,114,49,50,34,44,34,114,49,51,34,44,34,114,49,52,34,44,34,114,49,53,34,93,44,34,114,56,34,58,91,34,97,108,34,44,34,99,108,34,44,34,100,108,34,44,34,98,108,34,44,34,115,112,108,34,44,34,98,112,108,34,44,34,115,105,108,34,44,34,100,105,108,34,44,34,114,56,98,34,44,34,114,57,98,34,44,34,114,49,48,98,34,44,34,114,49,49,98,34,44,34,114,49,50,98,34,44,34,114,49,51,98,34,44,34,114,49,52,98,34,44,34,114,49,53,98,34,93,44,34,114,51,50,34,58,91,34,101,97,120,34,44,34,101,99,120,34,44,34,101,100,120,34,44,34,101,98,120,34,44,34,101,115,112,34,44,34,101,98,112,34,44,34,101,115,105,34,44,34,101,100,105,34,44,34,114,56,100,34,44,34,114,57,100,34,44,34,114,49,48,100,34,44,34,114,49,49,100,34,44,34,114,49,50,100,34,44,34,114,49,51,100,34,44,34,114,49,52,100,34,44,34,114,49,53,100,34,93,44,34,114,49,54,34,58,91,34,97,120,34,44,34,99,120,34,44,34,100,120,34,44,34,98,120,34,44,34,115,112,34,44,34,98,112,34,44,34,115,105,34,44,34,100,105,34,44,34,114,56,119,34,44,34,114,57,119,34,44,34,114,49,48,119,34,44,34,114,49,49,119,34,44,34,114,49,50,119,34,44,34,114,49,51,119,34,44,34,114,49,52,119,34,44,34,114,49,53,119,34,93,125,44,34,114,101,103,105,115,116,101,114,95,109,111,100,101,108,34,58,123,34,119,105,100,116,104,95,99,108,97,115,115,101,115,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,110,97,109,101,95,116,97,98,108,101,95,114,97,110,103,101,115,34,58,123,34,114,54,52,34,58,34,48,46,46,49,53,34,44,34,114,56,34,58,34,49,54,46,46,51,49,34,44,34,114,51,50,34,58,34,51,50,46,46,52,55,34,44,34,114,49,54,34,58,34,52,56,46,46,54,51,34,125,44,34,111,112,101,114,97,110,100,95,105,114,95,107,105,110,100,115,34,58,123,34,114,54,52,34,58,49,44,34,114,56,34,58,50,44,34,114,51,50,34,58,53,44,34,114,49,54,34,58,54,125,44,34,105,109,112,108,101,109,101,110,116,101,100,95,105,110,115,116,114,117,99,116,105,111,110,95,119,105,100,116,104,115,34,58,123,34,77,79,86,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,76,69,65,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,88,67,72,71,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,65,76,85,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,84,69,83,84,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,85,78,65,82,89,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,67,77,79,86,67,67,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,66,83,87,65,80,34,58,91,34,114,51,50,34,44,34,114,54,52,34,93,44,34,77,79,86,90,88,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,77,79,86,83,88,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,125,44,34,109,101,109,111,114,121,95,98,97,115,101,95,114,101,103,105,115,116,101,114,95,99,108,97,115,115,34,58,34,114,54,52,34,44,34,109,101,109,111,114,121,95,105,110,100,101,120,95,114,101,103,105,115,116,101,114,95,99,108,97,115,115,34,58,34,114,54,52,34,44,34,109,105,120,101,100,95,119,105,100,116,104,95,114,101,103,105,115,116,101,114,95,111,112,101,114,97,110,100,115,34,58,34,114,101,106,101,99,116,101,100,34,44,34,108,111,119,95,98,121,116,101,95,97,108,105,97,115,95,112,111,108,105,99,121,34,58,123,34,102,111,114,99,101,100,95,114,101,120,34,58,91,34,115,112,108,34,44,34,98,112,108,34,44,34,115,105,108,34,44,34,100,105,108,34,93,44,34,101,120,116,101,110,100,101,100,95,114,101,120,95,98,34,58,34,114,56,98,45,114,49,53,98,34,44,34,104,105,103,104,95,98,121,116,101,95,114,101,103,105,115,116,101,114,115,34
db 58,34,117,110,115,117,112,112,111,114,116,101,100,34,125,44,34,117,110,105,109,112,108,101,109,101,110,116,101,100,95,119,105,100,116,104,95,102,97,109,105,108,105,101,115,34,58,91,34,80,85,83,72,34,44,34,80,79,80,34,44,34,83,72,73,70,84,83,34,44,34,82,79,84,65,84,69,83,34,44,34,77,85,76,34,44,34,73,77,85,76,34,44,34,68,73,86,34,44,34,73,68,73,86,34,93,125,44,34,105,110,115,116,114,117,99,116,105,111,110,115,34,58,123,34,110,111,95,111,112,101,114,97,110,100,34,58,91,34,78,79,80,34,44,34,82,69,84,34,44,34,83,89,83,67,65,76,76,34,93,44,34,109,111,118,34,58,91,34,114,54,52,44,114,54,52,34,44,34,114,56,44,114,56,34,44,34,114,54,52,44,105,109,109,34,44,34,114,54,52,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,100,105,115,112,93,44,114,54,52,34,44,34,114,56,44,105,109,109,34,44,34,114,56,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,100,105,115,112,93,44,114,56,34,44,34,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,105,110,100,101,120,93,44,114,54,52,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,44,114,54,52,34,44,34,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,44,114,54,52,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,44,114,54,52,34,44,34,114,56,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,114,56,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,114,56,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,114,56,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,105,110,100,101,120,93,44,114,56,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,44,114,56,34,44,34,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,44,114,56,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,44,114,56,34,44,34,114,51,50,44,114,51,50,34,44,34,114,51,50,44,105,109,109,51,50,34,44,34,114,51,50,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,100,105,115,112,93,44,114,51,50,34,44,34,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,105,110,100,101,120,93,44,114,51,50,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,44,114,51,50,34,44,34,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,44,114,51,50,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,44,114,51,50,34,44,34,114,49,54,44,114,49,54,34,44,34,114,49,54,44,105,109,109,49,54,34,44,34,114,49,54,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,100,105,115,112,93,44,114,49,54,34,44,34,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,44,34,91,98,97,115,101,43,105,110,100,101,120,93,44,114,49,54,34,44,34,91,98,97
db 115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,44,114,49,54,34,44,34,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,44,114,49,54,34,44,34,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,44,114,49,54,34,93,44,34,97,108,117,34,58,123,34,109,110,101,109,111,110,105,99,115,34,58,91,34,65,68,68,34,44,34,65,68,67,34,44,34,83,66,66,34,44,34,83,85,66,34,44,34,65,78,68,34,44,34,79,82,34,44,34,88,79,82,34,44,34,67,77,80,34,93,44,34,119,105,100,116,104,115,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,111,112,101,114,97,110,100,95,102,111,114,109,115,34,58,91,34,114,101,103,105,115,116,101,114,44,114,101,103,105,115,116,101,114,34,44,34,114,101,103,105,115,116,101,114,44,105,109,109,101,100,105,97,116,101,34,93,125,44,34,116,101,115,116,34,58,91,34,84,69,83,84,32,114,54,52,44,114,54,52,34,44,34,84,69,83,84,32,114,54,52,44,105,109,109,51,50,34,44,34,84,69,83,84,32,114,56,44,114,56,34,44,34,84,69,83,84,32,114,56,44,105,109,109,56,34,44,34,84,69,83,84,32,114,51,50,44,114,51,50,34,44,34,84,69,83,84,32,114,51,50,44,105,109,109,51,50,34,44,34,84,69,83,84,32,114,49,54,44,114,49,54,34,44,34,84,69,83,84,32,114,49,54,44,105,109,109,49,54,34,93,44,34,97,100,100,114,101,115,115,34,58,91,34,76,69,65,32,114,54,52,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,76,69,65,32,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,76,69,65,32,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,76,69,65,32,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,76,69,65,32,114,54,52,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,44,34,76,69,65,32,114,51,50,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,76,69,65,32,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,76,69,65,32,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,76,69,65,32,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,76,69,65,32,114,51,50,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,44,34,76,69,65,32,114,49,54,44,91,98,97,115,101,43,100,105,115,112,93,34,44,34,76,69,65,32,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,93,34,44,34,76,69,65,32,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,93,34,44,34,76,69,65,32,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,43,100,105,115,112,93,34,44,34,76,69,65,32,114,49,54,44,91,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,93,34,93,44,34,101,120,99,104,97,110,103,101,34,58,91,34,88,67,72,71,32,114,54,52,44,114,54,52,34,44,34,88,67,72,71,32,114,51,50,44,114,51,50,34,44,34,88,67,72,71,32,114,49,54,44,114,49,54,34,93,44,34,115,116,97,99,107,34,58,91,34,80,85,83,72,32,114,54,52,34,44,34,80,85,83,72,32,105,109,109,56,34,44,34,80,85,83,72,32,105,109,109,51,50,34,44,34,80,79,80,32,114,54,52,34,93,44,34,117,110,97,114,121,34,58,91,34,73,78,67,32,114,56,47,114,49,54,47,114,51,50,47,114,54,52,34,44,34,68,69,67,32,114,56,47,114,49,54,47,114,51,50,47,114,54,52,34,44,34,78,79,84,32,114,56,47,114,49,54,47,114,51,50,47,114,54,52,34,44,34,78,69,71,32,114,56,47,114,49,54,47,114,51,50,47,114,54,52,34,93,44,34,115,104,105,102,116,34,58,91,34,83,72,76,32,114,54,52,44,105,109,109,56,34,44,34,83,72,76,32,114,54,52,44,99,108,34,44,34,83,72,76,32,114,56,44,105,109,109,56,34,44,34,83,72,76,32,114,56,44,99,108,34,44,34,83,72,82,32,114,54,52,44,105,109,109,56,34,44,34,83,72,82,32,114,54,52,44,99,108,34,44,34,83,72,82,32,114,56,44,105,109,109,56,34,44,34,83,72,82,32,114,56,44,99,108,34,44,34,83,65,82
db 32,114,54,52,44,105,109,109,56,34,44,34,83,65,82,32,114,54,52,44,99,108,34,44,34,83,65,82,32,114,56,44,105,109,109,56,34,44,34,83,65,82,32,114,56,44,99,108,34,93,44,34,114,111,116,97,116,101,34,58,91,34,82,79,76,32,114,54,52,44,105,109,109,56,34,44,34,82,79,76,32,114,54,52,44,99,108,34,44,34,82,79,76,32,114,56,44,105,109,109,56,34,44,34,82,79,76,32,114,56,44,99,108,34,44,34,82,79,82,32,114,54,52,44,105,109,109,56,34,44,34,82,79,82,32,114,54,52,44,99,108,34,44,34,82,79,82,32,114,56,44,105,109,109,56,34,44,34,82,79,82,32,114,56,44,99,108,34,44,34,82,67,76,32,114,54,52,44,105,109,109,56,34,44,34,82,67,76,32,114,54,52,44,99,108,34,44,34,82,67,76,32,114,56,44,105,109,109,56,34,44,34,82,67,76,32,114,56,44,99,108,34,44,34,82,67,82,32,114,54,52,44,105,109,109,56,34,44,34,82,67,82,32,114,54,52,44,99,108,34,44,34,82,67,82,32,114,56,44,105,109,109,56,34,44,34,82,67,82,32,114,56,44,99,108,34,93,44,34,98,114,97,110,99,104,101,115,34,58,91,34,74,77,80,32,108,97,98,101,108,34,44,34,67,65,76,76,32,108,97,98,101,108,34,44,34,74,79,32,108,97,98,101,108,34,44,34,74,78,79,32,108,97,98,101,108,34,44,34,74,66,32,108,97,98,101,108,34,44,34,74,65,69,32,108,97,98,101,108,34,44,34,74,69,32,108,97,98,101,108,34,44,34,74,78,69,32,108,97,98,101,108,34,44,34,74,66,69,32,108,97,98,101,108,34,44,34,74,65,32,108,97,98,101,108,34,44,34,74,83,32,108,97,98,101,108,34,44,34,74,78,83,32,108,97,98,101,108,34,44,34,74,80,32,108,97,98,101,108,34,44,34,74,78,80,32,108,97,98,101,108,34,44,34,74,76,32,108,97,98,101,108,34,44,34,74,71,69,32,108,97,98,101,108,34,44,34,74,76,69,32,108,97,98,101,108,34,44,34,74,71,32,108,97,98,101,108,34,44,34,74,90,32,108,97,98,101,108,34,44,34,74,78,90,32,108,97,98,101,108,34,93,44,34,98,114,97,110,99,104,95,101,110,99,111,100,105,110,103,34,58,34,97,117,116,111,109,97,116,105,99,45,114,101,108,56,45,114,101,108,51,50,34,44,34,98,114,97,110,99,104,95,114,101,108,97,120,97,116,105,111,110,34,58,123,34,97,108,103,111,114,105,116,104,109,34,58,34,109,111,110,111,116,111,110,105,99,45,102,105,120,101,100,45,112,111,105,110,116,34,44,34,115,104,111,114,116,95,100,105,115,112,108,97,99,101,109,101,110,116,34,58,34,115,105,103,110,101,100,45,56,45,98,105,116,34,44,34,110,101,97,114,95,100,105,115,112,108,97,99,101,109,101,110,116,34,58,34,115,105,103,110,101,100,45,51,50,45,98,105,116,34,44,34,114,101,108,97,120,101,100,95,109,110,101,109,111,110,105,99,115,34,58,91,34,74,77,80,34,44,34,74,79,34,44,34,74,78,79,34,44,34,74,66,34,44,34,74,65,69,34,44,34,74,69,34,44,34,74,78,69,34,44,34,74,66,69,34,44,34,74,65,34,44,34,74,83,34,44,34,74,78,83,34,44,34,74,80,34,44,34,74,78,80,34,44,34,74,76,34,44,34,74,71,69,34,44,34,74,76,69,34,44,34,74,71,34,44,34,74,90,34,44,34,74,78,90,34,93,44,34,99,97,108,108,34,58,34,115,105,103,110,101,100,45,51,50,45,98,105,116,34,125,44,34,98,121,116,101,95,111,114,100,101,114,34,58,91,34,66,83,87,65,80,32,114,51,50,34,44,34,66,83,87,65,80,32,114,54,52,34,93,44,34,101,120,116,101,110,100,34,58,91,34,77,79,86,90,88,32,114,49,54,44,114,56,34,44,34,77,79,86,90,88,32,114,51,50,44,114,56,34,44,34,77,79,86,90,88,32,114,54,52,44,114,56,34,44,34,77,79,86,90,88,32,114,49,54,44,91,109,101,109,93,34,44,34,77,79,86,90,88,32,114,51,50,44,91,109,101,109,93,34,44,34,77,79,86,90,88,32,114,54,52,44,91,109,101,109,93,34,44,34,77,79,86,83,88,32,114,49,54,44,114,56,34,44,34,77,79,86,83,88,32,114,51,50,44,114,56,34,44,34,77,79,86,83,88,32,114,54,52,44,114,56,34,44,34,77,79,86,83,88,32,114,49,54,44,91,109,101,109,93,34,44,34,77,79,86,83,88,32,114,51,50,44,91,109,101,109,93,34,44,34,77,79,86,83,88,32,114,54,52,44,91,109,101,109,93,34,93,44,34,101,120,116,101,110,100,95,115,111,117,114,99,101,34,58,123,34,115,111,117,114,99,101,95,119,105,100,116,104,95,98,121,116,101,115,34,58,49,44,34,115,111,117,114,99,101,95,111,112,101,114,97,110,100,95
db 102,111,114,109,115,34,58,91,34,114,56,34,44,34,109,101,109,111,114,121,34,93,44,34,100,101,115,116,105,110,97,116,105,111,110,95,119,105,100,116,104,115,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,119,105,100,116,104,95,112,111,108,105,99,121,34,58,34,100,101,115,116,105,110,97,116,105,111,110,45,114,101,103,105,115,116,101,114,59,32,109,101,109,111,114,121,32,115,111,117,114,99,101,32,105,115,32,105,109,112,108,105,99,105,116,108,121,32,98,121,116,101,34,44,34,101,110,99,111,100,105,110,103,115,34,58,123,34,77,79,86,90,88,34,58,34,48,70,32,66,54,32,47,114,34,44,34,77,79,86,83,88,34,58,34,48,70,32,66,69,32,47,114,34,125,125,44,34,98,121,116,101,95,111,114,100,101,114,95,101,110,99,111,100,105,110,103,34,58,34,48,70,32,67,56,43,114,100,59,32,82,69,88,46,66,32,102,111,114,32,114,56,100,45,114,49,53,100,59,32,82,69,88,46,87,32,102,111,114,32,114,54,52,34,44,34,109,117,108,116,105,112,108,121,95,100,105,118,105,100,101,34,58,91,34,77,85,76,32,114,54,52,34,44,34,77,85,76,32,114,56,34,44,34,73,77,85,76,32,114,54,52,34,44,34,73,77,85,76,32,114,56,34,44,34,68,73,86,32,114,54,52,34,44,34,68,73,86,32,114,56,34,44,34,73,68,73,86,32,114,54,52,34,44,34,73,68,73,86,32,114,56,34,93,44,34,97,108,117,95,109,101,109,111,114,121,34,58,123,34,109,110,101,109,111,110,105,99,115,34,58,91,34,65,68,68,34,44,34,65,68,67,34,44,34,83,66,66,34,44,34,83,85,66,34,44,34,65,78,68,34,44,34,79,82,34,44,34,88,79,82,34,44,34,67,77,80,34,93,44,34,119,105,100,116,104,115,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,111,112,101,114,97,110,100,95,111,114,100,101,114,115,34,58,91,34,114,101,103,105,115,116,101,114,44,109,101,109,111,114,121,34,44,34,109,101,109,111,114,121,44,114,101,103,105,115,116,101,114,34,93,125,44,34,116,101,115,116,95,109,101,109,111,114,121,34,58,123,34,109,110,101,109,111,110,105,99,34,58,34,84,69,83,84,34,44,34,119,105,100,116,104,115,34,58,91,34,114,56,34,44,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,111,112,101,114,97,110,100,95,111,114,100,101,114,115,34,58,91,34,114,101,103,105,115,116,101,114,44,109,101,109,111,114,121,34,44,34,109,101,109,111,114,121,44,114,101,103,105,115,116,101,114,34,93,125,44,34,115,101,116,99,99,34,58,123,34,99,111,110,100,105,116,105,111,110,115,34,58,91,34,111,34,44,34,110,111,34,44,34,98,34,44,34,97,101,34,44,34,101,34,44,34,110,101,34,44,34,98,101,34,44,34,97,34,44,34,115,34,44,34,110,115,34,44,34,112,34,44,34,110,112,34,44,34,108,34,44,34,103,101,34,44,34,108,101,34,44,34,103,34,93,44,34,97,108,105,97,115,101,115,34,58,123,34,122,34,58,34,101,34,44,34,110,122,34,58,34,110,101,34,125,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,114,56,95,111,114,95,109,101,109,111,114,121,34,44,34,109,101,109,111,114,121,95,119,105,100,116,104,95,98,121,116,101,115,34,58,49,44,34,101,110,99,111,100,105,110,103,34,58,34,48,70,32,57,48,43,99,99,32,47,48,34,125,44,34,99,109,111,118,99,99,34,58,123,34,99,111,110,100,105,116,105,111,110,95,115,111,117,114,99,101,34,58,34,115,101,116,99,99,34,44,34,119,105,100,116,104,115,34,58,91,34,114,49,54,34,44,34,114,51,50,34,44,34,114,54,52,34,93,44,34,111,112,101,114,97,110,100,95,102,111,114,109,115,34,58,91,34,114,49,54,44,114,49,54,34,44,34,114,49,54,44,91,109,101,109,93,34,44,34,114,51,50,44,114,51,50,34,44,34,114,51,50,44,91,109,101,109,93,34,44,34,114,54,52,44,114,54,52,34,44,34,114,54,52,44,91,109,101,109,93,34,93,44,34,101,110,99,111,100,105,110,103,34,58,34,48,70,32,52,48,43,99,99,32,47,114,34,44,34,119,105,100,116,104,95,112,111,108,105,99,121,34,58,34,109,97,116,99,104,101,100,45,114,101,103,105,115,116,101,114,59,109,101,109,111,114,121,45,105,110,102,101,114,114,101,100,34,125,44,34,98,105,116,95,111,112,101,114,97,116,105,111,110,115,34
db 58,123,34,102,111,114,109,115,34,58,91,34,114,49,54,47,114,51,50,47,114,54,52,58,114,101,103,45,114,101,103,124,114,101,103,45,105,109,109,56,124,109,101,109,45,114,101,103,34,93,44,34,101,110,99,111,100,105,110,103,34,58,34,48,70,32,65,51,47,65,66,47,66,51,47,66,66,59,48,70,32,66,65,32,47,52,46,46,55,32,105,98,34,44,34,109,101,109,111,114,121,95,119,105,100,116,104,34,58,34,114,101,103,105,115,116,101,114,45,105,110,102,101,114,114,101,100,34,44,34,117,110,115,117,112,112,111,114,116,101,100,34,58,91,34,76,79,67,75,34,44,34,109,101,109,45,105,109,109,56,34,93,125,125,44,34,109,101,109,111,114,121,34,58,123,34,97,100,100,114,101,115,115,105,110,103,34,58,34,98,97,115,101,43,105,110,100,101,120,42,115,99,97,108,101,43,100,105,115,112,108,97,99,101,109,101,110,116,34,44,34,98,97,115,101,95,114,101,103,105,115,116,101,114,115,34,58,34,114,54,52,34,44,34,105,110,100,101,120,95,114,101,103,105,115,116,101,114,115,34,58,34,114,54,52,34,44,34,105,110,100,101,120,95,114,101,103,105,115,116,101,114,95,101,120,99,108,117,100,101,115,34,58,91,34,114,115,112,34,93,44,34,115,99,97,108,101,95,102,97,99,116,111,114,115,34,58,91,49,44,50,44,52,44,56,93,44,34,100,105,115,112,108,97,99,101,109,101,110,116,34,58,34,115,105,103,110,101,100,45,51,50,45,98,105,116,34,44,34,111,112,116,105,111,110,97,108,95,105,110,100,101,120,34,58,116,114,117,101,44,34,111,112,116,105,111,110,97,108,95,115,99,97,108,101,34,58,116,114,117,101,44,34,111,112,116,105,111,110,97,108,95,100,105,115,112,108,97,99,101,109,101,110,116,34,58,116,114,117,101,44,34,111,112,101,114,97,110,100,95,119,105,100,116,104,95,112,111,108,105,99,121,34,58,34,105,110,102,101,114,114,101,100,45,102,114,111,109,45,114,101,103,105,115,116,101,114,34,125,44,34,115,121,109,98,111,108,115,34,58,123,34,109,97,120,95,99,111,117,110,116,34,58,49,48,50,52,44,34,114,101,115,111,108,117,116,105,111,110,34,58,34,100,101,112,101,110,100,101,110,99,121,45,103,114,97,112,104,45,112,108,117,115,45,102,105,120,101,100,45,112,111,105,110,116,45,108,97,121,111,117,116,45,97,110,100,45,109,111,110,111,116,111,110,105,99,45,98,114,97,110,99,104,45,114,101,108,97,120,97,116,105,111,110,34,44,34,100,101,112,101,110,100,101,110,99,121,95,103,114,97,112,104,34,58,123,34,97,108,103,111,114,105,116,104,109,34,58,34,75,97,104,110,45,116,111,112,111,108,111,103,105,99,97,108,45,115,111,114,116,34,44,34,101,100,103,101,95,115,99,111,112,101,34,58,34,69,81,85,45,116,111,45,69,81,85,32,114,101,102,101,114,101,110,99,101,115,34,44,34,111,114,100,101,114,105,110,103,34,58,34,100,101,112,101,110,100,101,110,99,105,101,115,45,102,105,114,115,116,34,44,34,116,105,101,95,98,114,101,97,107,34,58,34,108,111,119,101,115,116,45,115,121,109,98,111,108,45,116,97,98,108,101,45,105,110,100,101,120,34,44,34,99,121,99,108,101,95,100,105,97,103,110,111,115,116,105,99,34,58,34,69,95,69,81,85,95,67,89,67,76,69,34,125,44,34,109,97,120,95,105,116,101,114,97,116,105,111,110,115,34,58,50,48,52,56,125,44,34,99,108,105,34,58,91,34,45,45,118,101,114,115,105,111,110,34,44,34,45,45,118,101,114,115,105,111,110,61,106,115,111,110,34,44,34,45,45,104,101,108,112,34,44,34,45,45,102,101,97,116,117,114,101,115,34,44,34,45,45,102,101,97,116,117,114,101,115,61,106,115,111,110,34,44,34,45,45,99,104,101,99,107,34,44,34,45,45,99,104,101,99,107,32,45,45,100,105,97,103,110,111,115,116,105,99,115,61,106,115,111,110,34,44,34,45,45,100,105,97,103,110,111,115,116,105,99,115,61,106,115,111,110,34,93,44,34,115,116,97,116,105,115,116,105,99,115,34,58,123,34,101,110,97,98,108,101,100,95,98,121,34,58,34,45,45,116,105,109,101,34,44,34,102,105,101,108,100,115,34,58,91,34,76,97,121,111,117,116,32,112,97,115,115,101,115,34,44,34,83,104,111,114,116,32,98,114,97,110,99,104,101,115,34,93,125,44,34,109,110,101,109,111,110,105,99,115,34,58,91
msg_features_json_prefix_end:
msg_features_json_suffix:
db 44,34,115,101,116,111,34,44,34,115,101,116,110,111,34,44,34,115,101,116,98,34,44,34,115,101,116,97,101,34,44,34,115,101,116,101,34,44,34,115,101,116,110,101,34,44,34,115,101,116,98,101,34,44,34,115,101,116,97,34,44,34,115,101,116,115,34,44,34,115,101,116,110,115,34,44,34,115,101,116,112,34,44,34,115,101,116,110,112,34,44,34,115,101,116,108,34,44,34,115,101,116,103,101,34,44,34,115,101,116,108,101,34,44,34,115,101,116,103,34,44,34,115,101,116,122,34,44,34,115,101,116,110,122,34,44,34,99,109,111,118,111,34,44,34,99,109,111,118,110,111,34,44,34,99,109,111,118,98,34,44,34,99,109,111,118,97,101,34,44,34,99,109,111,118,101,34,44,34,99,109,111,118,110,101,34,44,34,99,109,111,118,98,101,34,44,34,99,109,111,118,97,34,44,34,99,109,111,118,115,34,44,34,99,109,111,118,110,115,34,44,34,99,109,111,118,112,34,44,34,99,109,111,118,110,112,34,44,34,99,109,111,118,108,34,44,34,99,109,111,118,103,101,34,44,34,99,109,111,118,108,101,34,44,34,99,109,111,118,103,34,44,34,99,109,111,118,122,34,44,34,99,109,111,118,110,122,34,93,44,34,105,110,116,101,114,109,101,100,105,97,116,101,95,114,101,112,114,101,115,101,110,116,97,116,105,111,110,34,58,123,34,118,101,114,115,105,111,110,34,58,50,44,34,114,101,99,111,114,100,95,98,121,116,101,115,34,58,52,44,34,109,97,120,95,115,116,97,116,101,109,101,110,116,115,34,58,49,57,54,54,48,55,44,34,114,101,99,111,114,100,95,102,105,101,108,100,115,34,58,91,34,115,111,117,114,99,101,95,111,102,102,115,101,116,95,117,49,56,34,44,34,107,105,110,100,95,117,56,34,44,34,105,115,97,95,105,110,100,101,120,95,117,54,34,93,44,34,115,116,97,116,101,109,101,110,116,95,107,105,110,100,115,34,58,123,34,48,34,58,34,98,108,97,110,107,95,111,114,95,99,111,109,109,101,110,116,34,44,34,49,34,58,34,108,97,98,101,108,34,44,34,50,34,58,34,101,113,117,34,44,34,51,34,58,34,100,97,116,97,34,44,34,52,34,58,34,105,110,115,116,114,117,99,116,105,111,110,34,44,34,50,53,53,34,58,34,117,110,107,110,111,119,110,34,125,44,34,105,115,97,95,100,105,115,112,97,116,99,104,34,58,34,99,97,99,104,101,100,45,105,115,97,45,114,101,99,111,114,100,45,105,110,100,101,120,34,44,34,111,112,101,114,97,110,100,95,110,111,100,101,95,98,121,116,101,115,34,58,56,44,34,111,112,101,114,97,110,100,95,115,108,111,116,115,95,112,101,114,95,115,116,97,116,101,109,101,110,116,34,58,50,44,34,109,97,120,95,111,112,101,114,97,110,100,95,110,111,100,101,115,34,58,51,57,51,50,49,52,44,34,111,112,101,114,97,110,100,95,110,111,100,101,95,102,105,101,108,100,115,34,58,91,34,107,105,110,100,95,117,56,34,44,34,114,101,103,105,115,116,101,114,95,111,114,95,114,101,115,101,114,118,101,100,95,117,56,34,44,34,116,111,107,101,110,95,108,101,110,103,116,104,95,117,56,34,44,34,115,111,117,114,99,101,95,111,102,102,115,101,116,95,105,110,95,108,105,110,101,95,117,51,50,34,44,34,114,101,115,101,114,118,101,100,95,117,56,34,93,44,34,111,112,101,114,97,110,100,95,110,111,100,101,95,107,105,110,100,115,34,58,123,34,49,34,58,34,114,54,52,95,114,101,103,105,115,116,101,114,34,44,34,50,34,58,34,114,56,95,114,101,103,105,115,116,101,114,34,44,34,51,34,58,34,109,101,109,111,114,121,95,115,111,117,114,99,101,95,115,112,97,110,95,119,105,116,104,95,99,97,99,104,101,100,95,97,100,100,114,101,115,115,95,102,105,101,108,100,115,34,44,34,52,34,58,34,105,109,109,101,100,105,97,116,101,95,101,120,112,114,101,115,115,105,111,110,95,115,111,117,114,99,101,95,115,112,97,110,95,119,105,116,104,95,97,115,116,95,114,101,102,101,114,101,110,99,101,34,44,34,53,34,58,34,114,51,50,95,114,101,103,105,115,116,101,114,34,44,34,54,34,58,34,114,49,54,95,114,101,103,105,115,116,101,114,34,125,44,34,111,112,101,114,97,110,100,95,114,101,112,114,101,115,101,110,116,97,116,105,111,110,34,58,34,116,121,112,101,100,45,114,101,103,105,115,116
db 101,114,45,119,105,100,116,104,45,112,108,117,115,45,101,120,112,114,101,115,115,105,111,110,45,97,115,116,34,44,34,116,121,112,101,100,95,111,112,101,114,97,110,100,95,110,111,100,101,115,34,58,116,114,117,101,44,34,101,120,112,114,101,115,115,105,111,110,95,97,115,116,95,110,111,100,101,115,34,58,116,114,117,101,44,34,109,101,109,111,114,121,95,110,111,100,101,95,108,97,121,111,117,116,34,58,123,34,114,101,99,111,114,100,95,98,121,116,101,115,34,58,56,44,34,102,105,101,108,100,115,34,58,91,34,107,105,110,100,95,117,56,34,44,34,98,97,115,101,95,114,101,103,105,115,116,101,114,95,105,110,100,101,120,95,117,56,34,44,34,115,111,117,114,99,101,95,116,111,107,101,110,95,108,101,110,103,116,104,95,117,56,34,44,34,115,111,117,114,99,101,95,111,102,102,115,101,116,95,105,110,95,108,105,110,101,95,117,51,50,34,44,34,112,97,99,107,101,100,95,105,110,100,101,120,95,115,99,97,108,101,95,102,108,97,103,115,95,117,56,34,93,44,34,112,97,99,107,101,100,95,105,110,100,101,120,95,115,99,97,108,101,95,102,108,97,103,115,34,58,123,34,105,110,100,101,120,95,114,101,103,105,115,116,101,114,95,105,110,100,101,120,34,58,34,98,105,116,115,95,48,95,51,34,44,34,115,99,97,108,101,95,99,111,100,101,34,58,34,98,105,116,115,95,52,95,53,59,32,48,61,49,44,32,49,61,50,44,32,50,61,52,44,32,51,61,56,34,44,34,104,97,115,95,105,110,100,101,120,34,58,34,98,105,116,95,54,34,44,34,114,101,115,101,114,118,101,100,34,58,34,98,105,116,95,55,59,32,122,101,114,111,34,125,44,34,97,100,100,114,101,115,115,95,99,111,109,112,111,110,101,110,116,115,34,58,91,34,98,97,115,101,95,114,101,103,105,115,116,101,114,34,44,34,111,112,116,105,111,110,97,108,95,105,110,100,101,120,95,114,101,103,105,115,116,101,114,34,44,34,111,112,116,105,111,110,97,108,95,115,99,97,108,101,34,44,34,100,105,115,112,108,97,99,101,109,101,110,116,95,101,120,112,114,101,115,115,105,111,110,95,97,115,116,34,93,125,44,34,101,120,112,114,101,115,115,105,111,110,95,97,115,116,34,58,123,34,118,101,114,115,105,111,110,34,58,49,44,34,110,111,100,101,95,98,121,116,101,115,34,58,49,54,44,34,109,97,120,95,110,111,100,101,115,34,58,49,57,54,54,48,56,44,34,110,111,100,101,95,105,100,115,34,58,34,49,45,98,97,115,101,100,59,32,112,101,114,45,111,112,101,114,97,110,100,32,99,111,110,116,105,103,117,111,117,115,32,112,111,115,116,111,114,100,101,114,32,114,97,110,103,101,115,34,44,34,110,111,100,101,95,102,105,101,108,100,115,34,58,91,34,107,105,110,100,95,117,56,34,44,34,111,112,101,114,97,116,111,114,95,117,56,34,44,34,115,121,109,98,111,108,95,108,101,110,103,116,104,95,117,56,34,44,34,114,101,115,101,114,118,101,100,95,117,52,48,34,44,34,112,97,121,108,111,97,100,95,117,54,52,34,93,44,34,110,111,100,101,95,107,105,110,100,115,34,58,123,34,49,34,58,34,108,105,116,101,114,97,108,95,117,54,52,34,44,34,50,34,58,34,115,121,109,98,111,108,95,110,97,109,101,95,112,111,111,108,95,114,101,102,101,114,101,110,99,101,34,44,34,51,34,58,34,98,105,110,97,114,121,95,111,112,101,114,97,116,105,111,110,34,44,34,52,34,58,34,117,110,97,114,121,95,110,101,103,97,116,105,111,110,34,125,44,34,98,105,110,97,114,121,95,111,112,101,114,97,116,111,114,95,99,111,100,101,115,34,58,123,34,49,34,58,34,97,100,100,34,44,34,50,34,58,34,115,117,98,116,114,97,99,116,34,44,34,51,34,58,34,115,104,105,102,116,95,108,101,102,116,34,44,34,52,34,58,34,108,111,103,105,99,97,108,95,115,104,105,102,116,95,114,105,103,104,116,34,44,34,53,34,58,34,98,105,116,119,105,115,101,95,97,110,100,34,44,34,54,34,58,34,98,105,116,119,105,115,101,95,111,114,34,125,44,34,112,97,121,108,111,97,100,95,108,97,121,111,117,116,34,58,123,34,108,105,116,101,114,97,108,34,58,34,117,110,115,105,103,110,101,100,95,117,54,52,95,118,97,108,117,101,34,44,34,115,121,109,98,111,108,34,58,34,112,111,105,110,116
db 101,114,95,116,111,95,105,109,109,117,116,97,98,108,101,95,110,97,109,101,95,112,111,111,108,95,99,111,112,121,34,44,34,98,105,110,97,114,121,34,58,34,108,101,102,116,95,110,111,100,101,95,105,100,95,117,51,50,95,108,111,119,95,114,105,103,104,116,95,110,111,100,101,95,105,100,95,117,51,50,95,104,105,103,104,34,44,34,117,110,97,114,121,34,58,34,99,104,105,108,100,95,110,111,100,101,95,105,100,95,117,54,52,34,125,44,34,111,112,101,114,97,110,100,95,109,101,116,97,100,97,116,97,34,58,123,34,98,121,116,101,115,95,112,101,114,95,115,108,111,116,34,58,56,44,34,102,105,101,108,100,115,34,58,91,34,115,116,97,114,116,95,110,111,100,101,95,105,100,95,117,51,50,34,44,34,114,111,111,116,95,110,111,100,101,95,105,100,95,117,51,50,34,93,44,34,114,97,110,103,101,34,58,34,49,45,98,97,115,101,100,32,105,110,99,108,117,115,105,118,101,59,32,122,101,114,111,32,109,101,97,110,115,32,110,111,32,65,83,84,34,125,44,34,115,99,111,112,101,34,58,91,34,105,110,115,116,114,117,99,116,105,111,110,95,105,109,109,101,100,105,97,116,101,34,44,34,109,101,109,111,114,121,95,100,105,115,112,108,97,99,101,109,101,110,116,34,44,34,69,81,85,34,44,34,68,66,34,44,34,68,87,34,44,34,68,68,34,44,34,68,81,34,93,44,34,114,101,101,118,97,108,117,97,116,105,111,110,34,58,34,65,83,84,32,114,111,111,116,115,32,97,114,101,32,99,97,99,104,101,100,32,98,121,32,97,98,115,111,108,117,116,101,32,115,111,117,114,99,101,45,98,121,116,101,32,111,102,102,115,101,116,59,32,115,121,109,98,111,108,32,118,97,108,117,101,115,32,97,114,101,32,114,101,115,111,108,118,101,100,32,97,103,97,105,110,32,111,110,32,101,118,101,114,121,32,101,118,97,108,117,97,116,105,111,110,34,44,34,108,101,103,97,99,121,95,101,120,112,114,101,115,115,105,111,110,95,112,97,116,104,115,34,58,91,93,44,34,103,101,110,101,114,105,99,95,101,120,112,114,101,115,115,105,111,110,95,99,97,99,104,101,34,58,123,34,107,101,121,34,58,34,97,98,115,111,108,117,116,101,95,115,111,117,114,99,101,95,98,121,116,101,95,111,102,102,115,101,116,34,44,34,101,110,116,114,121,95,98,121,116,101,115,34,58,56,44,34,99,97,112,97,99,105,116,121,34,58,49,57,54,54,48,56,44,34,99,111,110,116,101,120,116,115,34,58,91,34,69,81,85,34,44,34,68,66,34,44,34,68,87,34,44,34,68,68,34,44,34,68,81,34,93,125,125,125,44,34,105,115,97,95,109,111,100,101,108,34,58,123,34,115,99,104,101,109,97,95,118,101,114,115,105,111,110,34,58,52,44,34,114,101,99,111,114,100,95,98,121,116,101,115,34,58,56,44,34,100,101,99,108,97,114,97,116,105,118,101,95,102,111,114,109,115,34,58,91
msg_features_json_suffix_end:
msg_isa_record_open:
db 123,34,109,110,101,109,111,110,105,99,34,58,34
msg_isa_record_open_end:
msg_isa_record_middle_none:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,110,111,110,101,34,44,34,101,110,99,111,100,105,110,103,95,104,101,120,34,58,34
msg_isa_record_middle_none_end:
msg_isa_record_middle_r64:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,114,54,52,34,44,34,101,110,99,111,100,105,110,103,95,104,101,120,34,58,34
msg_isa_record_middle_r64_end:
msg_isa_record_middle_alu:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,103,112,114,95,114,114,95,109,101,109,95,105,109,109,34,44,34,100,101,115,99,114,105,112,116,111,114,95,107,105,110,100,34,58,34,97,108,117,95,103,114,111,117,112,95,101,120,116,101,110,115,105,111,110,34,44,34,100,101,115,99,114,105,112,116,111,114,95,104,101,120,34,58,34
msg_isa_record_middle_alu_end:
msg_isa_record_middle_test:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,103,112,114,95,114,114,95,109,101,109,95,105,109,109,34,44,34,100,101,115,99,114,105,112,116,111,114,95,107,105,110,100,34,58,34,116,101,115,116,95,111,112,99,111,100,101,95,112,97,105,114,34,44,34,100,101,115,99,114,105,112,116,111,114,95,104,101,120,34,58,34
msg_isa_record_middle_test_end:
msg_isa_record_middle_jcc:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,108,97,98,101,108,34,44,34,100,101,115,99,114,105,112,116,111,114,95,107,105,110,100,34,58,34,106,99,99,95,114,101,108,97,120,97,116,105,111,110,34,44,34,100,101,115,99,114,105,112,116,111,114,95,104,101,120,34,58,34
msg_isa_record_middle_jcc_end:
msg_isa_record_middle_jmp:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,108,97,98,101,108,34,44,34,100,101,115,99,114,105,112,116,111,114,95,107,105,110,100,34,58,34,106,109,112,95,114,101,108,97,120,97,116,105,111,110,34,44,34,100,101,115,99,114,105,112,116,111,114,95,104,101,120,34,58,34
msg_isa_record_middle_jmp_end:
msg_isa_record_middle_call:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,108,97,98,101,108,34,44,34,100,101,115,99,114,105,112,116,111,114,95,107,105,110,100,34,58,34,99,97,108,108,95,114,101,108,51,50,34,44,34,100,101,115,99,114,105,112,116,111,114,95,104,101,120,34,58,34
msg_isa_record_middle_call_end:
msg_isa_record_middle_group3:
db 34,44,34,111,112,101,114,97,110,100,95,102,111,114,109,34,58,34,103,112,114,95,115,105,110,103,108,101,34,44,34,100,101,115,99,114,105,112,116,111,114,95,107,105,110,100,34,58,34,103,114,111,117,112,51,95,111,112,99,111,100,101,95,101,120,116,101,110,115,105,111,110,34,44,34,100,101,115,99,114,105,112,116,111,114,95,104,101,120,34,58,34
msg_isa_record_middle_group3_end:
msg_isa_record_close_prefix:
db 34,44,34,111,112,101,114,97,110,100,95,99,111,110,116,114,97,99,116,95,105,100,34,58
msg_isa_record_close_prefix_end:
msg_isa_record_close_middle:
db 44,34,101,110,99,111,100,105,110,103,95,115,116,114,97,116,101,103,121,95,105,100,34,58
msg_isa_record_close_middle_end:
msg_isa_record_close_end:
db 125
msg_isa_record_close_end_end:
msg_isa_record_close_none:
db 34,125
msg_isa_record_close_none_end:
msg_isa_record_close_r64:
db 34,44,34,101,110,99,111,100,105,110,103,95,114,117,108,101,34,58,34,111,112,99,111,100,101,95,112,108,117,115,95,114,101,103,105,115,116,101,114,95,108,111,119,51,95,114,101,120,95,98,34,125
msg_isa_record_close_r64_end:
msg_isa_model_close:
db 93,44,34,114,101,109,97,105,110,105,110,103,95,102,111,114,109,115,34,58,34,115,112,101,99,105,97,108,105,122,101,100,95,104,97,110,100,108,101,114,115,34,44,34,111,112,101,114,97,110,100,95,99,111,110,116,114,97,99,116,115,34,58,123,34,48,34,58,34,115,112,101,99,105,97,108,105,122,101,100,95,104,97,110,100,108,101,114,34,44,34,49,34,58,34,122,101,114,111,95,111,112,101,114,97,110,100,115,34,44,34,50,34,58,34,116,121,112,101,100,95,100,97,116,97,95,101,120,112,114,101,115,115,105,111,110,95,108,105,115,116,34,44,34,51,34,58,34,115,97,109,101,95,119,105,100,116,104,95,103,112,114,95,114,114,95,109,101,109,111,114,121,95,111,114,95,105,109,109,101,100,105,97,116,101,34,44,34,52,34,58,34,108,97,98,101,108,95,116,97,114,103,101,116,34,44,34,53,34,58,34,115,105,110,103,108,101,95,103,112,114,95,114,56,95,111,114,95,114,54,52,34,44,34,54,34,58,34,115,116,97,99,107,95,114,101,103,105,115,116,101,114,95,111,114,95,112,117,115,104,95,105,109,109,101,100,105,97,116,101,34,125,44,34,101,110,99,111,100,105,110,103,95,115,116,114,97,116,101,103,105,101,115,34,58,123,34,48,34,58,34,115,112,101,99,105,97,108,105,122,101,100,95,104,97,110,100,108,101,114,34,44,34,49,34,58,34,102,105,120,101,100,95,111,112,99,111,100,101,95,98,121,116,101,115,34,44,34,50,34,58,34,111,112,99,111,100,101,95,112,108,117,115,95,114,101,103,105,115,116,101,114,95,108,111,119,51,95,114,101,120,95,98,34,44,34,51,34,58,34,97,108,117,95,103,112,114,95,114,114,95,109,101,109,111,114,121,95,111,114,95,105,109,109,101,100,105,97,116,101,95,116,101,109,112,108,97,116,101,34,44,34,52,34,58,34,116,101,115,116,95,103,112,114,95,114,114,95,109,101,109,111,114,121,95,111,114,95,105,109,109,101,100,105,97,116,101,95,116,101,109,112,108,97,116,101,34,44,34,53,34,58,34,114,101,108,56,95,114,101,108,51,50,95,98,114,97,110,99,104,95,114,101,108,97,120,97,116,105,111,110,34,44,34,54,34,58,34,103,114,111,117,112,51,95,111,112,99,111,100,101,95,101,120,116,101,110,115,105,111,110,34,44,34,55,34,58,34,99,97,108,108,95,114,101,108,51,50,34,44,34,56,34,58,34,116,121,112,101,100,95,100,97,116,97,95,108,105,116,116,108,101,95,101,110,100,105,97,110,34,125,125,125,10
msg_isa_model_close_end:
msg_check_success:
db 82,85,65,83,77,58,32,115,121,110,116,97,120,32,79,75,10
msg_check_success_end:
msg_version:
db 82,85,65,83,77,32,49,46,49,49,46,53,10
msg_version_end:
msg_help:
db 82,85,65,83,77,32,49,46,49,49,46,53,10,85,115,97,103,101,58,32,114,117,97,115,109,32,105,110,112,117,116,46,97,115,109,32,45,111,32,111,117,116,112,117,116,10,67,111,109,109,97,110,100,115,58,32,45,45,118,101,114,115,105,111,110,44,32,45,45,118,101,114,115,105,111,110,61,106,115,111,110,44,32,45,45,104,101,108,112,44,32,45,45,102,101,97,116,117,114,101,115,44,32,45,45,102,101,97,116,117,114,101,115,61,106,115,111,110,10,67,104,101,99,107,58,32,114,117,97,115,109,32,105,110,112,117,116,46,97,115,109,32,45,45,99,104,101,99,107,32,91,45,45,100,105,97,103,110,111,115,116,105,99,115,61,106,115,111,110,93,10,67,111,109,112,105,108,101,58,32,114,117,97,115,109,32,105,110,112,117,116,46,97,115,109,32,45,111,32,111,117,116,112,117,116,32,91,45,45,113,117,105,101,116,124,45,45,116,105,109,101,124,45,45,100,105,97,103,110,111,115,116,105,99,115,61,106,115,111,110,93,10
msg_help_end:
msg_features:
db 82,85,65,83,77,32,49,46,49,49,46,53,10,83,117,112,112,111,114,116,101,100,58,32,68,66,47,68,87,47,68,68,47,68,81,44,32,71,80,82,32,114,56,47,114,49,54,47,114,51,50,47,114,54,52,44,32,77,79,86,47,76,69,65,47,88,67,72,71,44,32,65,76,85,47,84,69,83,84,32,114,101,103,105,115,116,101,114,47,105,109,109,101,100,105,97,116,101,47,109,101,109,111,114,121,32,102,111,114,109,115,44,32,69,81,85,44,32,117,110,105,102,105,101,100,32,69,120,112,114,101,115,115,105,111,110,32,65,83,84,44,32,99,111,110,100,105,116,105,111,110,97,108,32,98,114,97,110,99,104,101,115,44,32,115,104,105,102,116,115,47,114,111,116,97,116,101,115,44,32,77,85,76,47,73,77,85,76,47,68,73,86,47,73,68,73,86,32,114,101,103,105,115,116,101,114,32,102,111,114,109,115,46,10,66,83,87,65,80,58,32,114,51,50,47,114,54,52,46,32,77,79,86,90,88,47,77,79,86,83,88,58,32,114,49,54,47,114,51,50,47,114,54,52,32,100,101,115,116,105,110,97,116,105,111,110,115,32,102,114,111,109,32,114,56,32,111,114,32,98,121,116,101,32,109,101,109,111,114,121,46,10,83,69,84,99,99,47,67,77,79,86,99,99,58,32,49,54,32,99,111,110,100,105,116,105,111,110,115,32,97,110,100,32,100,111,99,117,109,101,110,116,101,100,32,97,108,105,97,115,101,115,46,10,66,84,47,66,84,83,47,66,84,82,47,66,84,67,32,114,49,54,47,114,51,50,47,114,54,52,59,32,76,79,67,75,32,97,110,100,32,109,101,109,45,105,109,109,56,32,117,110,115,117,112,112,111,114,116,101,100,46,10
msg_features_end:
msg_usage:
db 114,117,97,115,109,58,32,117,115,97,103,101,58,32,114,117,97,115,109,32,105,110,112,117,116,46,97,115,109,32,45,111,32,111,117,116,112,117,116,10
msg_usage_end:
msg_success:
db 82,85,65,83,77,32,49,46,49,49,46,53,10,67,111,109,112,105,108,97,116,105,111,110,32,115,117,99,99,101,115,115,10,84,105,109,101,58,32
msg_success_end:
msg_microseconds:
db 32,117,115,10,79,117,116,112,117,116,32,115,105,122,101,58,32
msg_microseconds_end:
msg_bytes:
db 32,98,121,116,101,115,10
msg_bytes_end:
msg_layout_passes:
db 76,97,121,111,117,116,32,112,97,115,115,101,115,58,32
msg_layout_passes_end:
msg_short_branches:
db 83,104,111,114,116,32,98,114,97,110,99,104,101,115,58,32
msg_short_branches_end:
msg_json_output:
db 123,34,99,111,100,101,34,58,34,69,95,79,85,84,80,85,84,34,44,34,109,101,115,115,97,103,101,34,58,34,102,97,105,108,101,100,32,116,111,32,119,114,105,116,101,32,111,117,116,112,117,116,32,102,105,108,101,34,125,10
msg_json_output_end:
msg_json_input:
db 123,34,99,111,100,101,34,58,34,69,95,73,78,80,85,84,34,44,34,109,101,115,115,97,103,101,34,58,34,102,97,105,108,101,100,32,116,111,32,114,101,97,100,32,115,111,117,114,99,101,32,105,110,112,117,116,34,44,34,108,105,110,101,34,58
msg_json_input_end:
msg_json_syntax:
db 123,34,99,111,100,101,34,58,34,69,95,83,89,78,84,65,88,34,44,34,109,101,115,115,97,103,101,34,58,34,105,110,118,97,108,105,100,32,115,121,110,116,97,120,32,111,114,32,117,110,115,117,112,112,111,114,116,101,100,32,99,111,110,115,116,114,117,99,116,34,44,34,108,105,110,101,34,58
msg_json_syntax_end:
msg_text_range:
db 82,85,65,83,77,58,32,69,95,82,65,78,71,69,32,97,116,32,108,105,110,101,32
msg_text_range_end:
msg_json_range:
db 123,34,99,111,100,101,34,58,34,69,95,82,65,78,71,69,34,44,34,109,101,115,115,97,103,101,34,58,34,105,110,116,101,103,101,114,32,108,105,116,101,114,97,108,32,101,120,99,101,101,100,115,32,54,52,45,98,105,116,32,117,110,115,105,103,110,101,100,32,114,97,110,103,101,34,44,34,108,105,110,101,34,58
msg_json_range_end:
msg_text_identifier:
db 82,85,65,83,77,58,32,69,95,73,68,69,78,84,73,70,73,69,82,32,97,116,32,108,105,110,101,32
msg_text_identifier_end:
msg_json_identifier:
db 123,34,99,111,100,101,34,58,34,69,95,73,68,69,78,84,73,70,73,69,82,34,44,34,109,101,115,115,97,103,101,34,58,34,105,110,118,97,108,105,100,32,111,114,32,114,101,115,101,114,118,101,100,32,115,121,109,98,111,108,32,110,97,109,101,34,44,34,108,105,110,101,34,58
msg_json_identifier_end:
msg_text_duplicate:
db 82,85,65,83,77,58,32,69,95,68,85,80,76,73,67,65,84,69,95,83,89,77,66,79,76,32,97,116,32,108,105,110,101,32
msg_text_duplicate_end:
msg_json_duplicate:
db 123,34,99,111,100,101,34,58,34,69,95,68,85,80,76,73,67,65,84,69,95,83,89,77,66,79,76,34,44,34,109,101,115,115,97,103,101,34,58,34,115,121,109,98,111,108,32,97,108,114,101,97,100,121,32,100,101,102,105,110,101,100,34,44,34,108,105,110,101,34,58
msg_json_duplicate_end:
msg_text_undefined:
db 82,85,65,83,77,58,32,69,95,85,78,68,69,70,73,78,69,68,95,83,89,77,66,79,76,32,97,116,32,108,105,110,101,32
msg_text_undefined_end:
msg_json_undefined:
db 123,34,99,111,100,101,34,58,34,69,95,85,78,68,69,70,73,78,69,68,95,83,89,77,66,79,76,34,44,34,109,101,115,115,97,103,101,34,58,34,115,121,109,98,111,108,32,105,115,32,110,111,116,32,100,101,102,105,110,101,100,34,44,34,108,105,110,101,34,58
msg_json_undefined_end:
msg_text_symbol_limit:
db 82,85,65,83,77,58,32,69,95,83,89,77,66,79,76,95,76,73,77,73,84,32,97,116,32,108,105,110,101,32
msg_text_symbol_limit_end:
msg_json_symbol_limit:
db 123,34,99,111,100,101,34,58,34,69,95,83,89,77,66,79,76,95,76,73,77,73,84,34,44,34,109,101,115,115,97,103,101,34,58,34,115,121,109,98,111,108,32,116,97,98,108,101,32,101,120,99,101,101,100,115,32,49,48,50,52,32,101,110,116,114,105,101,115,34,44,34,108,105,110,101,34,58
msg_json_symbol_limit_end:
msg_text_output_limit:
db 82,85,65,83,77,58,32,69,95,79,85,84,80,85,84,95,76,73,77,73,84,32,97,116,32,108,105,110,101,32
msg_text_output_limit_end:
msg_json_output_limit:
db 123,34,99,111,100,101,34,58,34,69,95,79,85,84,80,85,84,95,76,73,77,73,84,34,44,34,109,101,115,115,97,103,101,34,58,34,111,117,116,112,117,116,32,101,120,99,101,101,100,115,32,54,53,53,51,54,32,98,121,116,101,115,34,44,34,108,105,110,101,34,58
msg_json_output_limit_end:
msg_json_column:
db 44,34,99,111,108,117,109,110,34,58
msg_json_column_end:
msg_text_equ_cycle:
db 82,85,65,83,77,58,32,69,95,69,81,85,95,67,89,67,76,69,32,97,116,32,108,105,110,101,32
msg_text_equ_cycle_end:
msg_json_equ_cycle:
db 123,34,99,111,100,101,34,58,34,69,95,69,81,85,95,67,89,67,76,69,34,44,34,109,101,115,115,97,103,101,34,58,34,99,121,99,108,105,99,32,69,81,85,32,100,101,112,101,110,100,101,110,99,121,34,44,34,108,105,110,101,34,58
msg_json_equ_cycle_end:
msg_json_col_null:
db 44,34,99,111,108,117,109,110,34,58,110,117,108,108,125,10
msg_json_col_null_end:
msg_json_end:
db 125,10
msg_json_end_end:
msg_text_column:
db 44,32,99,111,108,117,109,110,32
msg_text_column_end:
msg_text_column_unknown:
db 44,32,99,111,108,117,109,110,32,117,110,97,118,97,105,108,97,98,108,101
msg_text_column_unknown_end:
msg_newline:
db 10
msg_newline_end:
msg_output_error:
db 82,85,65,83,77,58,32,69,95,79,85,84,80,85,84,58,32,102,97,105,108,101,100,32,116,111,32,119,114,105,116,101,32,111,117,116,112,117,116,32,102,105,108,101,10
msg_output_error_end:
msg_json_comma:
db 44
msg_json_quote:
db 34
file_end:
