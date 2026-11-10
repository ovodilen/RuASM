# RUASM Compiler Specification for AI Agents

**Document version:** 1.0  
**Compiler baseline:** RUASM 1.11.5  
**Feature contract:** schema 29  
**Target architecture:** x86-64  
**Output:** flat binary, maximum 65,536 bytes  
**Normative machine-readable companion:** [`spec/contracts/ruasm-features-v29.example.json`](../spec/contracts/ruasm-features-v29.example.json)

## 1. Purpose and conformance

This document specifies the observable command-line, compilation, output, diagnostic, and machine-readable interface of RUASM 1.11.5. It is written as an operational contract for both people and autonomous coding agents.

RUASM is a self-hosted native assembler/compiler for a deliberately constrained x86-64 assembly language. The intended long-term use is systems software: boot code, kernels, loaders, drivers, embedded firmware, and compact native components. The current release is an implementation subset, not a complete x86-64 assembler and not a complete operating-system toolchain.

**Conformance rule:** an instruction spelling alone never proves that a particular operand form is accepted. An agent MUST discover the exact forms from the running compiler's `--features=json` output and MUST NOT infer support from an x86 manual, another assembler, or familiarity with a mnemonic.

Precedence of information:

1. The running binary's `--version=json` and `--features=json` are authoritative for that binary.
2. The versioned schemas in `spec/contracts/` define the machine-readable response shape.
3. This document explains the intended interaction and stable behavior for version 1.11.5.
4. Examples are illustrative and are not an extension of the accepted grammar.

If the executable reports a different feature schema, the agent MUST stop applying schema-29 assumptions and inspect the new manifest.

## 2. Distribution artifacts

| Artifact | Path | Format | Size in this package |
|---|---|---|---:|
| Linux compiler | `bin/linux-x86_64/ruasm` | x86-64 ELF64, static | 41,812 bytes |
| Windows compiler | `bin/windows-x86_64/ruasm.exe` | x86-64 PE32+ console | 49,664 bytes |
| Shared compiler core | `src/core/ruasm-core.asm` | RUASM source | 128,939 bytes |
| Linux complete translation unit | `src/generated/linux/ruasm.asm` | RUASM source | 177,043 bytes |
| Windows complete translation unit | `src/generated/windows/ruasm-windows.asm` | RUASM source | 196,306 bytes |

The Linux and Windows executables are host programs. They both target x86-64 and both emit the same `flat-binary` output format. The output is not an ELF executable, PE executable, COFF object, ELF relocatable object, or linked program.

The Linux binary can compile both translation units: it rebuilds the Linux compiler and cross-builds the Windows PE image. In the packaged build, compiling the Linux translation unit reproduces the shipped Linux executable byte-for-byte; compiling the Windows translation unit reproduces the shipped PE byte-for-byte. The Windows translation unit is close to the source-size limit; keep edits small and always run `--check` after changes.

## 3. Operating model

Input: one source file containing one RUASM program.  
Output: one raw byte stream.  
Target ISA: x86-64 long mode.  
Maximum output: 65,536 bytes.

Labels and `equ` declarations do not emit bytes. Data directives and instructions emit bytes in source order after symbol/layout resolution. RUASM does not create sections, symbol tables for an object file, relocations, import tables for the user's program, or a linker script. It does not call the operating system's compiler or assembler to produce output.

The current compiler has two host shells around one physical shared parser/IR/encoder core:

- Linux host layer: ELF64 startup and Linux system-call I/O.
- Windows host layer: PE32+ startup and Windows API I/O.
- Shared core: lexical processing, parsing, symbol handling, layout, instruction selection, and byte emission.

The Linux host executable is statically linked and has no ELF section table. The Windows executable is a native PE32+ console program. Host OS APIs are not language-level dependencies of generated flat binaries.

## 4. Command-line interface

The executable name is `ruasm` on Linux and `ruasm.exe` on Windows.

```text
ruasm --help
ruasm --version
ruasm --version=json
ruasm --features
ruasm --features=json
ruasm input.asm --check
ruasm input.asm --check --diagnostics=json
ruasm input.asm -o output.bin
ruasm input.asm -o output.bin --quiet
ruasm input.asm -o output.bin --time
ruasm input.asm -o output.bin --diagnostics=json
```

Supported command families:

| Purpose | Invocation | Behavior |
|---|---|---|
| Help | `--help` | Prints command syntax and supported command families. |
| Human version | `--version` | Prints product and version. |
| Version contract | `--version=json` | Prints schema-1 JSON identity, host, target, self-hosted flag, and output format. |
| Human capabilities | `--features` | Prints the feature summary. |
| Machine capabilities | `--features=json` | Prints the complete schema-29 feature manifest. |
| Validation only | `input.asm --check` | Parses and validates without publishing a binary. |
| JSON validation | `input.asm --check --diagnostics=json` | Validation with structured diagnostics on standard error. |
| Compilation | `input.asm -o output.bin` | Emits a flat binary. |
| Quiet compilation | `input.asm -o output.bin --quiet` | Suppresses the normal success message. |
| Timed compilation | `input.asm -o output.bin --time` | Reports elapsed time, layout-pass count, short-branch count, and output size. |

Unknown option-like arguments are usage errors. Do not rely on undocumented command-line combinations or argument ordering.

`--diagnostics=json` is a reporting mode; it does not change language semantics. Diagnostics are written to `stderr`. A successful compile writes the requested byte stream to the output path.

## 5. Machine-readable agent interface

### 5.1 Version discovery

Run:

```sh
./bin/linux-x86_64/ruasm --version=json
```

Schema 1 has these required fields:

- `schema_version`: integer, currently `1`.
- `name`: `RUASM`.
- `version`: semantic product version, currently `1.11.5`.
- `host`: compiler host identifier, for example `linux-x86_64` or `windows-x86_64`.
- `target`: currently `x86_64`.
- `self_hosted`: boolean, currently `true`.
- `output_format`: currently `flat-binary`.

### 5.2 Feature discovery

Run:

```sh
./bin/linux-x86_64/ruasm --features=json > features.json
```

The response uses schema 29. Its top-level fields are:

| Field | Meaning |
|---|---|
| `compiler` | Running compiler identity. |
| `output` | Output format and byte limit. |
| `source` | Source size, line/token limits, case sensitivity, line model. |
| `directives`, `data` | Supported directives and typed integer-data semantics. |
| `expressions` | Literal kinds and expression operators. |
| `registers`, `register_model` | Register names, width classes, aliases, and width support. |
| `instructions` | Mnemonics and supported operand-form descriptions. |
| `memory` | Address grammar constraints and displacement range. |
| `symbols` | Symbol capacity and deterministic dependency/layout strategy. |
| `cli`, `statistics` | Command-line contract and `--time` fields. |
| `mnemonics` | Accepted instruction spellings, including condition aliases. |
| `intermediate_representation` | Published internal statement/operand/AST contract. |
| `isa_model` | Declarative ISA descriptor model and its current entries. |

The manifest is an exact capability contract for the running build. Some entries are compact matrices or cross-products; agents MUST expand only the dimensions explicitly supplied by the object. For example, `instructions.alu` describes its own register/register and register/immediate matrix. It does not imply memory forms. Memory forms are declared separately under `alu_memory` and `test_memory`.

The presence of a mnemonic in `mnemonics` does not mean every architectural form is implemented. The `instructions` object and its operand-form fields are authoritative.

### 5.3 JSON Schemas

Use the shipped schemas:

- `spec/contracts/ruasm-version-v1.schema.json`
- `spec/contracts/ruasm-features-v29.schema.json`
- `spec/contracts/ruasm-diagnostic-v1.schema.json`

Example responses are snapshots from the Linux binary in this package. For another host build, query the executable itself; the `host` field is expected to differ.

## 6. Source and resource limits

The current feature contract reports:

| Resource | Limit / policy |
|---|---:|
| Source bytes | 196,607 maximum |
| Physical line bytes | 4,095 maximum |
| Token bytes | 65 maximum |
| Symbols | 1,024 maximum |
| Output bytes | 65,536 maximum |
| Layout stabilization | 2,048 maximum iterations |
| Statements | 196,607 maximum records |
| Source case | Case-sensitive |
| Statements per physical line | Exactly one |

These limits are part of the public contract. An agent SHOULD count generated source bytes before invoking the compiler and MUST NOT assume that the limits are unlimited.

## 7. Compilation pipeline and internal data contracts

The compiler exposes selected implementation details to agents because they describe how the current implementation organizes a source program. These are versioned compiler contracts; agents should not author these structures directly.

### 7.1 Statement IR v2

Each physical source line can be represented by a packed 32-bit statement record:

| Bits | Field | Meaning |
|---|---|---|
| 0..17 | `source_offset_u18` | Absolute source-byte offset. |
| 18..25 | `kind_u8` | Statement kind. |
| 26..31 | `isa_index_u6` | ISA registry index. |

Statement kinds:

- `0`: blank or comment.
- `1`: label.
- `2`: `equ` declaration.
- `3`: data directive.
- `4`: instruction.
- `255`: unknown classification, which is sent to the canonical parser for a diagnostic.

The ISA index is a cache into the shared ISA table; source text remains the language interface. This IR is not a supported user input format.

### 7.2 Typed operand IR v1

The current implementation uses two 8-byte operand slots per statement. The exposed node kinds are:

- `1`: r64 register.
- `2`: r8 register.
- `3`: memory source span with cached address fields.
- `4`: immediate-expression source span with AST reference.
- `5`: r32 register.
- `6`: r16 register.

Memory nodes contain a base-register index, a source span, and packed optional index/scale flags. The public JSON describes the exact fields and bit layout. Do not depend on reserved fields being nonzero or on undocumented internal addresses.

### 7.3 Expression AST v1

The AST uses 16-byte nodes and supports:

- unsigned 64-bit literal;
- symbol reference;
- binary operation;
- unary negation.

The currently exposed binary operator codes are addition, subtraction, left shift, logical right shift, bitwise AND, and bitwise OR. AST node identifiers are 1-based. The AST is internal; write source expressions, not AST records.

AST roots are cached by source position, but expression values are evaluated again against the current symbol environment. This matters for label-dependent expressions during layout. An agent MUST NOT assume that caching a parsed expression makes its value constant.

### 7.4 Symbol resolution

`EQU`-to-`EQU` references are resolved using a deterministic dependency graph and Kahn topological ordering. The published tie-break is the lowest symbol-table index. Label addresses are layout-dependent and are re-evaluated during stabilization. Cycles produce `E_EQU_CYCLE`; unresolved names produce `E_UNDEFINED_SYMBOL`.

### 7.5 Layout and branch relaxation

The compiler repeatedly lays out the source until the symbol and size state stabilizes. Supported `JMP` and conditional branches may be encoded as signed rel8 (`-128..127`) or signed rel32. The compiler automatically chooses short branches when valid and repeats layout as needed. `CALL` is rel32-only. Final emission rechecks short displacements; an invalid short branch is widened and layout restarts. A conservative fallback exists for layout cycles. In pathological files this may retain a near branch rather than the smallest possible encoding, but it prioritizes valid output and convergence.

`--time` reports aggregate layout-pass count and selected short-branch count; these are diagnostic telemetry, not a promise of a fixed number of passes.

## 8. Diagnostics and failure behavior

Stable diagnostic codes include:

| Code | Meaning |
|---|---|
| `E_SYNTAX` | Malformed syntax or unsupported operand/form. |
| `E_INPUT` | Input path or input read failure. |
| `E_OUTPUT` | Output creation/write/commit failure. |
| `E_RANGE` | Literal, immediate, data value, shift count, or displacement outside an accepted range. |
| `E_IDENTIFIER` | Invalid or reserved identifier. |
| `E_DUPLICATE_SYMBOL` | Duplicate label/EQU declaration. |
| `E_UNDEFINED_SYMBOL` | Unresolved symbol. |
| `E_SYMBOL_LIMIT` | More than 1,024 symbols. |
| `E_OUTPUT_LIMIT` | More than 65,536 output bytes. |
| `E_EQU_CYCLE` | Cyclic EQU dependency. |

The schema-1 diagnostic object has required fields `code` and `message`, and optional `line` and `column`. Source locations are 1-based. A diagnostic without a source location may use `line: 0` and `column: null`.

On compilation/validation failure, do not consume a partially produced output as a valid program. The current output-publication path is designed and regression-tested so a pre-existing output file is not replaced by a failed compilation. Agents SHOULD compile to a fresh temporary path, check the exit status, then validate the result before moving it into a release location.

## 9. Determinism and reproducibility

For the same compiler binary, identical source bytes, and identical command-line arguments, the compiler is intended to emit identical bytes. No random seed or wall-clock input is part of instruction selection. `--time` changes reporting only.

Rebuild the current compiler using the shipped Linux compiler:

```sh
mkdir -p build
./bin/linux-x86_64/ruasm src/generated/linux/ruasm.asm -o build/ruasm --quiet
cmp bin/linux-x86_64/ruasm build/ruasm
./bin/linux-x86_64/ruasm src/generated/windows/ruasm-windows.asm -o build/ruasm.exe --quiet
cmp bin/windows-x86_64/ruasm.exe build/ruasm.exe
```

On Windows, the native compiler can rebuild its own host image:

```powershell
New-Item -ItemType Directory -Force .\build | Out-Null
.\bin\windows-x86_64\ruasm.exe .\src\generated\windows\ruasm-windows.asm -o .\build\ruasm.exe --quiet
if ($LASTEXITCODE -ne 0) { throw 'RUASM build failed' }
Get-FileHash .\build\ruasm.exe -Algorithm SHA256
```

`cmp` success means byte identity on the host used for that command. The compiler does not need FASM or another assembler to execute or to compile the packaged source with the shipped RUASM binaries. Shell, PowerShell, `cmp`, and checksum utilities are only orchestration/verification tools in the example workflows.

## 10. Agent operating protocol

A coding agent SHOULD follow this procedure for every generated source file:

1. Query `--version=json` and `--features=json` from the exact executable it will invoke.
2. Verify `name`, `version`, `target`, `output.format`, and `schema_version`.
3. Build an allow-list from the feature manifest for the exact mnemonic, operand order, register widths, memory form, and immediate type.
4. Emit lowercase source, ASCII identifiers, one statement per physical line, and canonical comma-separated operands.
5. Avoid unsupported language features and implicit assumptions about ABI, sections, linker behavior, or runtime.
6. Run `input.asm --check --diagnostics=json`.
7. If validation fails, parse the structured diagnostic and make the smallest local correction; do not guess an alternative operand form.
8. Compile to a new output path.
9. Require a successful process exit, check output size, and compare an expected byte sequence or hash when the task provides one.
10. Only then publish or embed the output.

### Agent response format

When reporting a compilation task, an agent SHOULD state:

- RUASM version and host;
- target architecture and output format;
- source file and output file;
- validation result;
- compilation result and output byte count;
- hash or byte-level verification result, if requested;
- all unsupported assumptions or unresolved external ABI requirements.

## 11. Current boundaries and non-goals

RUASM 1.11.5 is not a drop-in replacement for FASM. The current compiler does not implement a complete x86-64 ISA, a macro/preprocessor system, file inclusion, string literals, `org`, `align`, sections, ELF/COFF relocatable object generation, relocations, a linker, procedure/ABI declarations, an OS SDK, a debugger, or a standard runtime. Exact instruction limits are in the feature manifest and language specification.

The long-term product goals are greater ISA coverage, compact output, fast compilation, explicit machine-checkable semantics, low ambiguity for agent-generated code, and use in a sovereign operating-system toolchain. Claims that RUASM already exceeds FASM in total functionality or general performance are not made by this specification.

The agent-first design hypothesis is that a narrow, explicit, versioned contract and deterministic failure behavior can reduce model retries and invalid code generation. This is a design goal; an empirical claim about token savings or agent reliability requires controlled benchmark datasets and published methodology.

## 12. Patent and provenance boundary

The MIT license grants the rights expressed in the license text; it is not a patent search, patent licence, freedom-to-operate opinion, or legal opinion. This repository does not claim that a patent/FTO audit has been completed. Independent development and build reproducibility are engineering evidence, not a legal conclusion.

The project is distributed without bundled third-party assembler source or binaries. The compiler source is in `src/`; the shipped compiler binaries are the bootstrap executables for the documented self-rebuild. Do not add copied implementation code from other assemblers or tools without a provenance review and explicit license analysis.
