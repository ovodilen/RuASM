# Спецификация языка RUASM ASM для ИИ-агентов

**Версия документа:** 1.0  
**Языковой baseline:** RUASM 1.11.5  
**Манифест возможностей:** schema 29  
**Режим:** x86-64 long mode, результат — flat binary  
**Нормативный контракт конкретного бинарника:** [`../spec/contracts/ruasm-features-v29.example.json`](../spec/contracts/ruasm-features-v29.example.json)

## 1. Принцип соответствия

RUASM ASM — регистрозависимый язык ассемблера с одной инструкцией/директивой на физическую строку. Язык компилируется в плоский поток байтов x86-64. В текущей версии отсутствует макропроцессор и большинство удобств традиционных ассемблеров; намеренно узкая грамматика облегчает статическую проверку и генерацию агентами.

**Обязательное правило для генератора:** поддерживаемая архитектурой x86-64 инструкция не обязательно поддерживается RUASM. Перед генерацией запросите `ruasm --features=json`. Для каждой инструкции проверьте точную форму, класс регистра, порядок операндов, ширину и допустимость memory/immediate. Не выводите дополнительные формы из привычного синтаксиса FASM, NASM, GAS или Intel manual.

## 2. Лексика и структура исходника

### 2.1. Ограничения

| Параметр | Значение |
|---|---:|
| Максимальный исходник | 196 607 байт |
| Максимальная физическая строка | 4 095 байт |
| Максимальный токен | 65 байт |
| Максимум символов | 1 024 |
| Максимум выходных байт | 65 536 |
| Чувствительность к регистру | Да |
| Операторов на строку | Один |
| Разрешённые переводы строк | LF и CRLF |

Строки отделяются LF или CRLF. Пробел и горизонтальная табуляция используются как разделители. Символ `;` начинает комментарий до конца строки. Пустые строки и комментарии допустимы.

Ключевые слова, мнемоники, регистры, директивы и идентификаторы регистрозависимы. Генератор ДОЛЖЕН выдавать lowercase для мнемоник, регистров, `equ`, `db`, `dw`, `dd`, `dq`.

### 2.2. Идентификаторы

Идентификатор:

- состоит только из ASCII;
- начинается с латинской буквы `A..Z` / `a..z` или `_`;
- далее содержит латинские буквы, цифры или `_`;
- имеет длину не более 63 байт;
- не совпадает с зарезервированным именем.

Зарезервированы имена регистров, директивы `db`, `dw`, `dd`, `dq`, `equ`, все поддерживаемые мнемоники и их алиасы. Пространство имён меток и `equ` едино. Повторное объявление запрещено.

### 2.3. Строки и statements

Одна физическая строка содержит не более одного statement. Метка занимает отдельную строку; нельзя писать `label: mov rax, 1`.

Канонический формат операндов — через запятую и с пробелом после запятой:

```asm
mov rax, rbx
add eax, 1
```

Не используйте перенос инструкции на следующую строку, строковые литералы, обратную косую черту для продолжения или директивы включения.

### 2.4. Каноническая EBNF

Грамматика ниже намеренно задаёт рекомендуемую форму записи. Матрица из `--features=json` дополнительно фильтрует инструкции по точным формам операндов.

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

This EBNF does not replace the binary's feature manifest. In particular, `mnemonic` must be selected from the exact accepted instruction inventory and its operand form must be supported. Expressions are contiguous tokens; agents should not insert spaces inside `equ` or immediate expressions.

## 3. Операторы исходного языка и семантика символов

### 3.1. Метки

```asm
entry:
    mov eax, 42
    ret
```

A label's value is the current byte offset from the beginning of the output. It emits no bytes. Labels are valid branch targets and can be referenced from expressions and memory displacements where permitted. A label must be declared exactly once.

### 3.2. Константы EQU

```asm
PAGE_SIZE equ 4096
MASK equ (1<<8)-1
NEXT_PAGE equ PAGE_SIZE+4096
```

`equ` creates an integer symbol and emits no bytes. Forward dependencies between `equ` declarations are resolved deterministically. Cycles are errors. Labels and `equ` share one unique symbol namespace.

The expression after `equ` must be emitted as one contiguous token. Use no spaces inside the expression.

### 3.3. Типизированные целочисленные данные

| Directive | Element size | Accepted result range | Byte order |
|---|---:|---:|---|
| `db` | 1 | 0..255 | little-endian |
| `dw` | 2 | 0..65,535 | little-endian |
| `dd` | 4 | 0..4,294,967,295 | little-endian |
| `dq` | 8 | 0..18,446,744,073,709,551,615 | little-endian |

Syntax:

```asm
MAGIC equ 0x52554153
db 0x52, 0x55, 0x41, 0x53
dw 0x1234, 65535
dd MAGIC, 4294967295
dq 0x0123456789abcdef
```

Each comma-separated element is evaluated independently. Empty elements, trailing commas, missing values, and out-of-range values are errors. RUASM does not silently truncate an out-of-range typed data value. Strings, character literals, repetition counts, alignment, reservation and file inclusion are not implemented.

## 4. Выражения

### 4.1. Литералы и операторы

Supported literals:

- decimal unsigned integers;
- hexadecimal unsigned integers with `0x` or `0X` prefix;
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

Multiplication, division, remainder, XOR, bitwise NOT, exponentiation and string values are not part of the expression language.

### 4.2. Область целочисленных значений

Expression values are unsigned 64-bit bit patterns.

- Decimal and hexadecimal literals must fit `0..2^64-1`.
- Addition, subtraction and unary negation wrap modulo `2^64`.
- Right shift is logical.
- Shift count must be `0..63`.
- A left shift that discards set bits is rejected with `E_RANGE`.
- A data directive then applies its own narrower unsigned range check.
- An instruction immediate is checked against the exact form selected by the instruction encoder; never rely on truncation.

Because `0-1` evaluates to `0xffffffffffffffff`, `db 0-1` is outside the `DB` range and must be rejected. To encode a negative byte where an instruction form explicitly permits signed immediate values, use that instruction's documented signed range and validate it with `--check`.

## 5. Регистры общего назначения

All 16 architectural GPR indices are available in four named width classes where the current instruction form permits the class.

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

The eight-bit class contains the 16 low-byte registers shown above. Legacy high-byte names `ah`, `bh`, `ch`, `dh` are unsupported. `spl`, `bpl`, `sil`, `dil` require a REX prefix. `r8b`–`r15b` require the appropriate REX extension.

Do not infer that every instruction supports all four width classes. The feature manifest has explicit width lists for each family.

## 6. Операнды памяти

### 6.1. Эффективный адрес

A memory operand uses a 64-bit base register, an optional 64-bit index register, an optional scale, and an optional signed 32-bit displacement:

```text
[base + index*scale + displacement]
```

The actual source forms include:

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
- scale is one of `1`, `2`, `4`, `8`; omitted scale is `1`.
- displacement is optional and must fit signed 32-bit range.
- address size is 64-bit regardless of the data register width.
- memory width is inferred from the paired register when that instruction form uses a GPR to define it.

The encoder chooses a legal compact ModR/M/SIB representation, using no displacement where possible, signed disp8 where it fits, otherwise signed disp32. RBP/R13 encodings may require a zero disp8 in architectural cases where the encoding has no no-displacement form.

### 6.2. Неподдерживаемые способы адресации

The current language does not provide:

- RIP-relative addressing;
- base-less indexed addressing;
- segment overrides;
- address-size overrides;
- a standalone absolute memory expression;
- a memory-size keyword such as `byte`, `word`, `dword`, `qword`.

When memory width is inferred, the companion register determines it. Special one-byte memory forms such as `SETcc`, `MOVZX` and `MOVSX` are determined by the instruction itself.

## 7. Реализованные семейства инструкций

The tables below summarize the current contract. Exact support remains defined by `instructions` in schema 29. Unsupported operand permutations MUST be rejected by an agent before use or by compiler preflight.

### 7.1. Инструкции без операндов

| Mnemonics | Operand form |
|---|---|
| `nop`, `ret`, `syscall` | no operands |

### 7.2. Перемещение данных MOV

Supported classes include:

- register/register: r8, r16, r32, r64 where advertised;
- register/immediate: only the exact width forms advertised by the manifest;
- register/memory and memory/register for r8, r16, r32, r64;
- memory addressing uses Section 6.

The current manifest publishes the full list of concrete memory patterns and immediate forms. Memory-to-memory is not supported. Do not assume sign-extension forms or arbitrary immediate widths beyond the explicit manifest.

### 7.3. Целочисленные арифметические и логические операции

The eight mnemonics are:

`add`, `adc`, `sbb`, `sub`, `and`, `or`, `xor`, `cmp`.

The register matrix is:

- widths: `r8`, `r16`, `r32`, `r64`;
- forms: `register,register` and `register,immediate`.

The memory matrix is separate:

- widths: `r8`, `r16`, `r32`, `r64`;
- orders: `register,memory` and `memory,register`;
- the GPR operand determines memory width.

Memory-to-memory and immediate-to-memory are unsupported. Register-width mismatches are rejected. `cmp` updates flags like the corresponding x86 instruction but does not write its destination.

### 7.4. Проверка битов TEST

`test` supports register/register and register/immediate forms for `r8`, `r16`, `r32`, and `r64`, plus register/memory and memory/register for all four widths. The register determines memory width. Memory-to-memory and immediate-to-memory are unsupported. TEST does not store a result; the CPU updates flags according to x86 semantics.

### 7.5. Вычисление адреса и обмен

- `lea`: r16/r32/r64 destination with supported `[base+disp]`, `[base+index]`, `[base+index*scale]`, and indexed-plus-displacement address forms. It computes an effective address; it does not read from the memory location.
- `xchg`: matching register/register pairs at r16, r32, and r64. No r8 or memory XCHG form is advertised.

### 7.6. Стековые и унарные целочисленные операции

| Family | Current forms |
|---|---|
| `push` | r64, signed imm8, signed imm32 |
| `pop` | r64 |
| `inc`, `dec`, `not`, `neg` | one r8/r16/r32/r64 register as listed by the live manifest |

These tables do not imply memory forms or additional widths.

### 7.7. Сдвиги и циклические сдвиги

| Mnemonics | Destination | Count |
|---|---|---|
| `shl`, `shr`, `sar` | r8 or r64 | immediate byte or exactly `cl` |
| `rol`, `ror`, `rcl`, `rcr` | r8 or r64 | immediate byte or exactly `cl` |

Do not substitute another count register. Widths r16/r32 and memory destinations are not advertised for these families in this contract.

### 7.8. Переходы и условное управление

`jmp` and all 18 listed conditional spellings take exactly one label target:

`jo`, `jno`, `jb`, `jae`, `je`, `jne`, `jbe`, `ja`, `js`, `jns`, `jp`, `jnp`, `jl`, `jge`, `jle`, `jg`, `jz`, `jnz`.

`call` also takes one label target, but uses rel32 only. `jmp` and the Jcc family use automatic rel8/rel32 relaxation. There are no explicit `short` or `near` source qualifiers. A branch target is an identifier naming a label; do not use an arbitrary expression as a branch target.

Aliases: `jz` has the same condition as `je`; `jnz` has the same condition as `jne`.

### 7.9. Установка значения по условию SETcc

All 16 condition suffixes are supported:

`o`, `no`, `b`, `ae`, `e`, `ne`, `be`, `a`, `s`, `ns`, `p`, `np`, `l`, `ge`, `le`, `g`.

Forms:

- one low-byte GPR destination (`al`, `cl`, `dl`, `bl`, `spl`, `bpl`, `sil`, `dil`, `r8b`–`r15b`);
- or one memory destination of exactly one byte.

Aliases: `setz` = `sete`; `setnz` = `setne`. No explicit size qualifier is used for memory. `SETcc` reads CPU flags at runtime, writes `0` or `1`, and does not modify the flags.

### 7.10. Условное перемещение CMOVcc

All 16 condition suffixes are supported, including `cmovz` and `cmovnz` aliases. Destination: r16/r32/r64. Source: same-width GPR or memory with width inferred from destination. Immediate source, byte-register form, memory destination, and mismatched register widths are unsupported. Flags are not modified.

### 7.11. Изменение порядка байтов и расширение байта

- `bswap`: r32 or r64 register.
- `movzx`: r16/r32/r64 destination and r8-register or one-byte memory source.
- `movsx`: r16/r32/r64 destination and r8-register or one-byte memory source.

`MOVZX` zero-extends the source byte. `MOVSX` sign-extends the source byte. These instructions do not modify flags. `BSWAP r32` follows x86-64 semantics for a 32-bit GPR write, including clearing the upper half of the corresponding 64-bit register.

### 7.12. Умножение и деление

`mul`, `imul`, `div`, `idiv` accept exactly one r8 or r64 register source in the current contract. Accumulator and data registers are implicit according to the x86 instruction semantics. r16/r32 and memory sources are not advertised.

### 7.13. Проверка и изменение битов

`bt`, `bts`, `btr`, `btc` support:

- matching-width register/register at r16/r32/r64;
- register plus imm8;
- memory destination plus register source, with memory width inferred from the register.

`lock` prefixes and memory/immediate forms are unsupported. `BT` tests a bit; `BTS` sets, `BTR` resets, `BTC` complements. The original selected bit is returned in CF. For memory bit-string forms, the CPU applies x86 bit-string addressing to the effective address and index register.

## 8. Отображение кодов условий

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

The compiler selects the encoding. The CPU evaluates the condition at runtime. RUASM does not statically prove that a preceding instruction established the flags that the program intends to consume.

## 9. Непосредственные операнды и контроль разрядности

The feature manifest describes operand forms, but it is not a complete per-instruction range table. The compiler's range checks are authoritative. Agents MUST:

- avoid assuming an immediate is silently truncated;
- avoid widening/narrowing a register operand to make a form fit;
- keep paired register widths equal where required;
- check signed branch/displacement constraints;
- run `--check --diagnostics=json` before final compilation.

The source expression domain is unsigned 64-bit; individual instruction encodings may impose signed or narrower ranges. These are separate checks.

## 10. Контракт результата и среды выполнения

The compiler emits a flat byte sequence beginning at offset zero. Label values are offsets from byte zero. There is no implicit executable header, relocation base, section table, stack setup, entry-point metadata, ABI prologue, or system-call wrapper.

The consumer of the flat binary is responsible for mapping/loading it at the intended address, arranging registers/stack/memory, calling it using a chosen ABI, and satisfying CPU/OS preconditions. A successful assembly is not proof that the machine code is safe or that it can run as a process by itself.

## 11. Нереализованные конструкции языка

Not implemented in this release:

- macros, preprocessor directives, conditional assembly, include/import;
- strings, character literals, UTF-8 identifiers;
- `org`, `align`, sections, `times`, reservations, file embedding;
- named procedures, function prototypes, ABI declarations, stack-frame synthesis;
- ELF/COFF object files, relocations, symbol exports, libraries, linker;
- RIP-relative or absolute memory syntax and segment overrides;
- complete x86-64 instruction coverage, SSE/AVX/x87/MMX, system/control/debug-register families;
- labels with trailing instructions on the same line.

Do not emulate a missing directive by adding syntax that the parser does not implement. Use explicit numeric data and byte layout within the supported source subset.

## 12. Протокол проверки компилятором

Recommended interaction for an AI agent:

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

A mnemonic inventory is not a substitute for an operand-form allow-list. The current manifest is the machine contract; this document is its human/agent explanation.
