# RUASM ASM Language Specification for AI Agents

**Document version:** 1.0  
**Language baseline:** RUASM 1.11.5  
**Feature manifest:** schema 29  
**Mode:** x86-64 long mode; flat-binary output  
**Normative capability contract for this binary:** [`../spec/contracts/ruasm-features-v29.example.json`](../spec/contracts/ruasm-features-v29.example.json)

## 1. Conformance rule

RUASM ASM is a case-sensitive assembly language with one instruction or directive per physical line. It compiles to a flat x86-64 byte stream. The current version intentionally has a narrow grammar and does not have a macro processor or many conveniences found in traditional assemblers. The explicit language boundary is intended to make static validation and agent generation more predictable.

**Mandatory generator rule:** an x86-64 instruction being architecturally valid does not mean RUASM accepts it. Query `ruasm --features=json` before code generation. Check the exact operand form, register class, operand order, width, and memory/immediate policy. Never infer extra forms from FASM, NASM, GAS, or an Intel manual.

## 2. Lexical and source-file structure

### 2.1. Limits

| Property | Value |
|---|---:|
| Maximum source file | 196,607 bytes |
| Maximum physical line | 4,095 bytes |
| Maximum token | 65 bytes |
| Maximum symbols | 1,024 |
| Maximum output | 65,536 bytes |
| Case sensitivity | Yes |
| Statements per line | One |
| Line endings | LF and CRLF |

Lines are separated by LF or CRLF. A space or horizontal tab is a separator. `;` starts a comment that continues to the end of the line. Blank lines and full-line comments are valid.

Keywords, mnemonics, registers, directives, and identifiers are case-sensitive. Generators MUST emit lowercase mnemonics, registers, `equ`, `db`, `dw`, `dd`, and `dq`.

### 2.2. Identifiers

An identifier:

- contains ASCII only;
- starts with an English letter `A..Z` / `a..z` or `_`;
- continues with English letters, digits, or `_`;
- is at most 63 bytes long;
- is not a reserved name.

Register names, directives `db`, `dw`, `dd`, `dq`, `equ`, every supported mnemonic, and its aliases are reserved. Labels and `equ` symbols share one namespace. Duplicate declarations are rejected.

### 2.3. Lines and statements

A physical line contains at most one statement. A label occupies its own line; `label: mov rax, 1` is invalid.

Canonical operand formatting uses commas and a space after the comma:

```asm
mov rax, rbx
add eax, 1
```

Do not use line continuation, string literals, include directives, or multiple statements on one line.

### 2.4. Canonical EBNF

The grammar below describes the recommended spelling. The live `--features=json` manifest further filters instruction statements by exact operand forms.

```ebnf
source          = { line }, [ final_line ] ;
line            = line_content, newline ;
final_line      = line_content ;
line_content    = [ hspace ], [ statement ], [ hspace ], [ comment ] ;
statement       = label | equ_stmt | data_stmt | instruction ;
label           = identifier, ":" ;
equ_stmt        = identifier, hspace, "equ", hspace, expression ;
data_stmt       = data_directive, hspace, expression,
                  { [ hspace ], ",", [ hspace ], expression } ;
data_directive  = "db" | "dw" | "dd" | "dq" ;
instruction     = mnemonic, [ hspace, operand_list ] ;
operand_list    = operand, { [ hspace ], ",", [ hspace ], operand } ;
operand         = register | expression | memory ;
memory          = "[", base_register, [ memory_tail ], "]" ;
memory_tail     = displacement_only | index_part ;
displacement_only = ("+" | "-"), expression ;
index_part      = "+", index_register, [ "*", scale ],
                  [ ("+" | "-"), expression ] ;
scale           = "1" | "2" | "4" | "8" ;
expression      = bit_or ;
bit_or          = bit_and, { "|", bit_and } ;
bit_and         = shift, { "&", shift } ;
shift           = additive, { ("<<" | ">>"), additive } ;
additive        = unary, { ("+" | "-"), unary } ;
unary           = { "+" | "-" }, primary ;
primary         = decimal | hexadecimal | identifier | "(", expression, ")" ;
identifier      = ident_start, { ident_continue } ;
ident_start     = letter | "_" ;
ident_continue = letter | digit | "_" ;
register        = register64 | register32 | register16 | register8 ;
base_register   = register64 ;
index_register  = register64, except "rsp" ;
decimal         = digit, { digit } ;
hexadecimal     = ("0x" | "0X"), hex_digit, { hex_digit } ;
comment         = ";", { any_byte_except_newline } ;
hspace          = one_or_more(" " | TAB) ;
newline         = LF | CR, LF ;
```

This EBNF does not replace the executable's feature manifest. `mnemonic` must be selected from the accepted inventory and its exact operand form must be supported. Expressions are contiguous tokens; agents should not insert spaces inside `equ` or immediate expressions.

## 3. Statements and symbol semantics

### 3.1. Labels

```asm
entry:
    mov eax, 42
    ret
```

A label's value is the current output byte offset. It emits no bytes. Labels may be branch targets and may be referenced from expressions and supported memory displacements. A symbol can be declared once.

### 3.2. EQU

```asm
PAGE_SIZE equ 4096
MASK equ (1<<8)-1
NEXT_PAGE equ PAGE_SIZE+4096
```

`equ` declares an integer symbol and emits no bytes. Forward dependencies among `equ` declarations are resolved deterministically. Cyclic definitions are errors. Labels and `equ` declarations share a unique namespace.

The expression following `equ` must be one contiguous token. Do not insert spaces inside it.

### 3.3. Typed integer data

| Directive | Element width | Accepted result range | Byte order |
|---|---:|---:|---|
| `db` | 1 byte | 0..255 | little-endian |
| `dw` | 2 bytes | 0..65,535 | little-endian |
| `dd` | 4 bytes | 0..4,294,967,295 | little-endian |
| `dq` | 8 bytes | 0..18,446,744,073,709,551,615 | little-endian |

Syntax:

```asm
MAGIC equ 0x52554153
db 0x52, 0x55, 0x41, 0x53
dw 0x1234, 65535
dd MAGIC, 4294967295
dq 0x0123456789abcdef
```

Each comma-separated element is evaluated independently. Empty elements, trailing commas, missing values, and out-of-range values are errors. RUASM does not silently truncate a typed data value. Strings, character literals, repetition, alignment, reservation, and file inclusion are not implemented.

## 4. Expressions

### 4.1. Literals and operators

Supported literals:

- unsigned decimal integers;
- unsigned hexadecimal integers with a `0x` or `0X` prefix;
- declared symbol names.

Supported operators, from lowest to highest precedence:

| Precedence | Operators | Associativity |
|---:|---|---|
| 1 | `|` | left |
| 2 | `&` | left |
| 3 | `<<`, `>>` | left, equal precedence |
| 4 | `+`, `-` | left, equal precedence |
| 5 | unary `+`, unary `-` | prefix |
| 6 | `( ... )` | grouping |

Examples:

```asm
PAGE_SHIFT equ 12
PAGE_SIZE equ 1<<PAGE_SHIFT
FLAG_MASK equ (1<<4)|(1<<7)
OFFSET equ PAGE_SIZE+0x20-4
NEGATED equ 0-1
```

Multiplication, division, remainder, XOR, bitwise NOT, exponentiation, and string values are outside the expression language.

### 4.2. Integer domain

Expression values are unsigned 64-bit bit patterns.

- Decimal and hexadecimal literals must fit `0..2^64-1`.
- Addition, subtraction, and unary negation wrap modulo `2^64`.
- Right shift is logical.
- Shift count must be `0..63`.
- A left shift that discards set bits is rejected with `E_RANGE`.
- A data directive then applies its own narrower unsigned range check.
- An instruction immediate is checked against the exact selected instruction form; never rely on truncation.

Because `0-1` evaluates to `0xffffffffffffffff`, `db 0-1` is outside the `DB` range and must be rejected. For negative instruction immediates, use only a form whose signed range is explicitly allowed and validate it with `--check`.

## 5. General-purpose registers

All 16 architectural GPR indices are available in four named width classes where an instruction form supports that class.

| Index | 64-bit | 32-bit | 16-bit | 8-bit low alias |
|---:|---|---|---|---|
| 0 | `rax` | `eax` | `ax` | `al` |
| 1 | `rcx` | `ecx` | `cx` | `cl` |
| 2 | `rdx` | `edx` | `dx` | `dl` |
| 3 | `rbx` | `ebx` | `bx` | `bl` |
| 4 | `rsp` | `esp` | `sp` | `spl` |
| 5 | `rbp` | `ebp` | `bp` | `bpl` |
| 6 | `rsi` | `esi` | `si` | `sil` |
| 7 | `rdi` | `edi` | `di` | `dil` |
| 8 | `r8` | `r8d` | `r8w` | `r8b` |
| 9 | `r9` | `r9d` | `r9w` | `r9b` |
| 10 | `r10` | `r10d` | `r10w` | `r10b` |
| 11 | `r11` | `r11d` | `r11w` | `r11b` |
| 12 | `r12` | `r12d` | `r12w` | `r12b` |
| 13 | `r13` | `r13d` | `r13w` | `r13b` |
| 14 | `r14` | `r14d` | `r14w` | `r14b` |
| 15 | `r15` | `r15d` | `r15w` | `r15b` |

The 8-bit class contains the 16 low-byte names listed above. Legacy high-byte registers `ah`, `bh`, `ch`, `dh` are unsupported. `spl`, `bpl`, `sil`, and `dil` require a REX prefix. `r8b`–`r15b` require the corresponding REX extension.

Do not infer that every instruction supports all four width classes. The feature manifest specifies widths separately for each family.

## 6. Memory operands

### 6.1. Effective address

A memory operand uses a 64-bit base register, an optional 64-bit index register, an optional scale, and an optional signed 32-bit displacement:

```text
[base + index*scale + displacement]
```

Supported source shapes include:

```asm
[rbx]
[rbx+16]
[rbp-8]
[rsp+32]
[rbx+rcx]
[rbx+rcx*4]
[rbx+rcx*4+16]
[rdi+rsi*8-8]
[r13+r9*8]
```

Rules:

- `base` is always a 64-bit GPR.
- `index` is optional and is a 64-bit GPR.
- `rsp` is not allowed as an index; `r12` is allowed.
- scale is one of `1`, `2`, `4`, `8`; omitted scale means `1`.
- displacement is optional and must fit signed 32-bit range.
- address size remains 64-bit regardless of data-register width.
- when a paired GPR defines memory width, that register determines the width.

The encoder selects a legal compact ModR/M/SIB representation: no displacement where possible, signed disp8 when it fits, otherwise signed disp32. RBP/R13 may require a zero disp8 in architectural cases where the encoding has no no-displacement form.

### 6.2. Unsupported addressing

The current language does not provide:

- RIP-relative addressing;
- base-less indexed addressing;
- segment overrides;
- address-size overrides;
- a standalone absolute memory expression;
- a memory-size keyword such as `byte`, `word`, `dword`, or `qword`.

When memory width is inferred, the paired register determines it. Special one-byte memory forms such as `SETcc`, `MOVZX`, and `MOVSX` get their width from the instruction itself.

## 7. Implemented instruction families

The following tables summarize the current contract. Exact support is still defined by `instructions` in schema 29. Unsupported operand permutations MUST be rejected by an agent or by compiler preflight.

### 7.1. No-operand instructions

| Mnemonics | Operand form |
|---|---|
| `nop`, `ret`, `syscall` | no operands |

### 7.2. MOV

Supported classes include:

- register/register: r8, r16, r32, r64 where advertised;
- register/immediate: only the exact width forms advertised by the manifest;
- register/memory and memory/register for r8, r16, r32, r64;
- memory addressing according to Section 6.

The live manifest publishes the complete list of concrete memory patterns and immediate forms. Memory-to-memory is unsupported. Do not infer sign-extension forms or arbitrary immediate widths beyond the manifest.

### 7.3. Integer ALU operations

The eight mnemonics are:

`add`, `adc`, `sbb`, `sub`, `and`, `or`, `xor`, `cmp`.

Register matrix:

- widths: `r8`, `r16`, `r32`, `r64`;
- forms: `register,register` and `register,immediate`.

Separate memory matrix:

- widths: `r8`, `r16`, `r32`, `r64`;
- orders: `register,memory` and `memory,register`;
- the GPR operand determines memory width.

Memory-to-memory and immediate-to-memory are unsupported. Register-width mismatches are rejected. `cmp` updates flags like the corresponding x86 instruction but does not write the destination.

### 7.4. TEST

`test` supports register/register and register/immediate at widths r8/r16/r32/r64, plus register/memory and memory/register for all four widths. The GPR determines memory width. Memory-to-memory and immediate-to-memory are unsupported. TEST does not store a result; the CPU updates flags using x86 semantics.

### 7.5. Address generation and exchange

- `lea`: r16/r32/r64 destination with supported `[base+disp]`, `[base+index]`, `[base+index*scale]`, and indexed-plus-displacement forms. It computes an effective address; it does not load from the memory location.
- `xchg`: matching register/register pairs at r16, r32, r64. No r8 or memory XCHG form is advertised.

### 7.6. Stack and unary integer operations

| Family | Current forms |
|---|---|
| `push` | r64, signed imm8, signed imm32 |
| `pop` | r64 |
| `inc`, `dec`, `not`, `neg` | one r8/r16/r32/r64 register as listed by the live manifest |

These tables do not imply memory forms or additional widths.

### 7.7. Shifts and rotates

| Mnemonics | Destination | Count |
|---|---|---|
| `shl`, `shr`, `sar` | r8 or r64 | immediate byte or exactly `cl` |
| `rol`, `ror`, `rcl`, `rcr` | r8 or r64 | immediate byte or exactly `cl` |

Do not substitute another count register. r16/r32 and memory destinations are not advertised for these families in this contract.

### 7.8. Branches and conditional control flow

`jmp` and all 18 conditional spellings take exactly one label target:

`jo`, `jno`, `jb`, `jae`, `je`, `jne`, `jbe`, `ja`, `js`, `jns`, `jp`, `jnp`, `jl`, `jge`, `jle`, `jg`, `jz`, `jnz`.

`call` also takes one label target but uses rel32 only. `jmp` and the Jcc family use automatic rel8/rel32 relaxation. There are no explicit `short` or `near` source qualifiers. A branch target is an identifier naming a label; do not use an arbitrary expression as a branch target.

Aliases: `jz` has the same condition as `je`; `jnz` has the same condition as `jne`.

### 7.9. SETcc

All 16 condition suffixes are supported:

`o`, `no`, `b`, `ae`, `e`, `ne`, `be`, `a`, `s`, `ns`, `p`, `np`, `l`, `ge`, `le`, `g`.

Forms:

- one low-byte GPR destination (`al`, `cl`, `dl`, `bl`, `spl`, `bpl`, `sil`, `dil`, `r8b`–`r15b`);
- or one memory destination exactly one byte wide.

Aliases: `setz` = `sete`; `setnz` = `setne`. No memory size qualifier is used. `SETcc` reads CPU flags at runtime, writes `0` or `1`, and does not modify flags.

### 7.10. CMOVcc

All 16 condition suffixes are supported, including the `cmovz` and `cmovnz` aliases. Destination: r16/r32/r64. Source: same-width GPR or memory whose width is inferred from the destination. Immediate source, byte-register form, memory destination, and mismatched register widths are unsupported. Flags are not modified.

### 7.11. Byte-order and byte-extension operations

- `bswap`: r32 or r64 register.
- `movzx`: r16/r32/r64 destination and r8-register or one-byte memory source.
- `movsx`: r16/r32/r64 destination and r8-register or one-byte memory source.

`MOVZX` zero-extends the source byte. `MOVSX` sign-extends the source byte. These instructions do not modify flags. `BSWAP r32` follows x86-64 semantics for a 32-bit GPR write, including clearing the upper half of the corresponding 64-bit register.

### 7.12. Multiply and divide

`mul`, `imul`, `div`, `idiv` accept exactly one r8 or r64 register source in the current contract. Accumulator and data registers are implicit according to x86 instruction semantics. r16/r32 and memory sources are not advertised.

### 7.13. Bit-test and bit-modification operations

`bt`, `bts`, `btr`, `btc` support:

- matching-width register/register at r16/r32/r64;
- register plus imm8;
- memory destination plus register source, with memory width inferred from the register.

`lock` prefixes and memory/immediate forms are unsupported. `BT` tests a bit; `BTS` sets it; `BTR` resets it; `BTC` complements it. The original selected bit is returned in CF. For memory bit-string forms, the CPU applies x86 bit-string addressing to the effective address and index register.

## 8. Condition-code mapping

The condition order in the live manifest is:

| Suffix | Predicate |
|---|---|
| `o` | OF = 1 |
| `no` | OF = 0 |
| `b` | CF = 1 |
| `ae` | CF = 0 |
| `e` | ZF = 1 |
| `ne` | ZF = 0 |
| `be` | CF = 1 or ZF = 1 |
| `a` | CF = 0 and ZF = 0 |
| `s` | SF = 1 |
| `ns` | SF = 0 |
| `p` | PF = 1 |
| `np` | PF = 0 |
| `l` | SF != OF |
| `ge` | SF = OF |
| `le` | ZF = 1 or SF != OF |
| `g` | ZF = 0 and SF = OF |

The compiler selects the encoding. The CPU evaluates the condition at runtime. RUASM does not statically prove that a preceding instruction established the flags the program intends to consume.

## 9. Immediate values and width safety

The feature manifest describes operand forms but is not a complete per-instruction range table. Compiler range checks are authoritative. Agents MUST:

- never assume an immediate is silently truncated;
- never widen or narrow a register operand to force an unsupported form;
- keep paired register widths equal when required;
- respect signed branch/displacement limits;
- run `--check --diagnostics=json` before final compilation.

The source expression domain is unsigned 64-bit; each instruction encoding may impose additional signed or narrower limits. These are separate checks.

## 10. Output and runtime contract

The compiler emits a flat byte sequence starting at offset zero. Label values are offsets from byte zero. There is no implicit executable header, relocation base, section table, stack setup, entry-point metadata, ABI prologue, or system-call wrapper.

The flat-binary consumer is responsible for mapping/loading the bytes at the intended address, arranging registers/stack/memory, calling the code according to a chosen ABI, and satisfying CPU/OS preconditions. Successful assembly is not proof that machine code is safe or that it can run as a standalone process.

## 11. Unsupported language constructs

Not implemented in this release:

- macros, preprocessor directives, conditional assembly, include/import;
- strings, character literals, UTF-8 identifiers;
- `org`, `align`, sections, `times`, reservations, file embedding;
- named procedures, function prototypes, ABI declarations, stack-frame synthesis;
- ELF/COFF object files, relocations, symbol exports, libraries, linker;
- RIP-relative or absolute memory syntax and segment overrides;
- complete x86-64 instruction coverage, SSE/AVX/x87/MMX, system/control/debug-register families;
- labels followed by an instruction on the same line.

Do not emulate a missing directive by inventing syntax the parser does not implement. Use explicit numeric data and byte layout within the supported grammar.

## 12. Compiler validation protocol

Recommended AI-agent workflow:

```text
1. ruasm --version=json
2. ruasm --features=json
3. Check every proposed mnemonic/form against the live manifest.
4. Generate canonical one-statement-per-line source.
5. ruasm input.asm --check --diagnostics=json
6. Parse E_* diagnostics and make a minimal correction.
7. ruasm input.asm -o fresh-output.bin --quiet
8. Verify process status, output length, and expected bytes/hash.
```

A mnemonic inventory is not an operand-form allow-list. The live manifest is the machine contract; this document is the human/agent explanation.
