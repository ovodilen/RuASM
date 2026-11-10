# RUASM — a Russian Assembly Language and Compiler

**Version:** 1.11.5 · **Target:** x86-64 · **License:** MIT · **Documentation:** Russian and English

RUASM is an independently implemented, native, self-hosting assembly language and compiler. This repository provides native Linux and Windows x86-64 compiler binaries, both platform source variants, the shared implementation, a machine-readable capability contract, detailed AI-agent specifications, examples, and reproducible build scripts.

> **Implementation status.** RUASM 1.11.5 is a working compiler for a limited, explicitly specified subset of x86-64. It is not a complete x86-64 ISA implementation, not yet a full functional replacement for FASM, and not a complete operating-system toolchain. Long-term goals are stated separately from implemented capabilities.

[Русский README](README.md) · [AI compiler specification](docs/COMPILER-SPEC-AI-EN.md) · [AI language specification](docs/LANGUAGE-SPEC-AI-EN.md)

## 1. Project purpose

The long-term goal is to build a Russian assembly language and compiler for systems programming: bootloaders, kernels, drivers, firmware, and compact native programs. A further strategic goal is to use the language as one of the core development tools for a sovereign Russian operating system.

RUASM is designed with **predictable AI-agent use** as a first-class objective. The project is developing explicit, testable properties:

- a documented and versioned grammar;
- a machine-readable manifest of the actual capabilities of the selected compiler binary;
- exact instruction-form matrices rather than assumptions based on mnemonic names;
- one statement per physical source line;
- case-sensitive ASCII identifiers and canonical spelling;
- deterministic `EQU` resolution and controlled layout stabilization;
- a validation-only mode (`--check`);
- structured JSON diagnostics with stable error codes;
- self-hosting and byte-for-byte reproducible builds.

**Research hypothesis:** explicit constraints and machine contracts can reduce invalid generations, retry compilations, and tokens spent by an AI agent fixing code. This is a design hypothesis, not a proven comparative advantage. It requires a published benchmark suite and reproducible agent experiments.

## 2. RUASM 1.11.5 at a glance

| Property | Current implementation |
|---|---|
| Target ISA | x86-64 long mode |
| Instructions | 95 supported mnemonic spellings; exact forms are in the manifest |
| Declarative ISA forms | 38 records in this version's contract; remaining forms use specialized handlers |
| Data directives | `db`, `dw`, `dd`, `dq`, `equ` |
| Output format | Flat byte stream (`flat-binary`) |
| Maximum output | 65,536 bytes |
| Maximum source | 196,607 bytes |
| Symbol table | Up to 1,024 symbols |
| JSON capability contract | Schema 29 |
| Self-hosted | Yes |
| Host binaries | Linux x86-64 and Windows x86-64 |

A mnemonic does not imply support for every architectural operand form. The authority is `--features=json` from the exact compiler binary being used.

### Implemented instruction families

`NOP`, `RET`, `SYSCALL`; `MOV`; integer arithmetic and logic `ADD`, `ADC`, `SBB`, `SUB`, `AND`, `OR`, `XOR`, `CMP`, `TEST`; `LEA`, `XCHG`; `PUSH`, `POP`; `INC`, `DEC`, `NOT`, `NEG`; `SHL`, `SHR`, `SAR`, `ROL`, `ROR`, `RCL`, `RCR`; `JMP`, `CALL` and conditional branches; `SETcc`, `CMOVcc`; `BSWAP`, `MOVZX`, `MOVSX`; `MUL`, `IMUL`, `DIV`, `IDIV`; `BT`, `BTS`, `BTR`, `BTC`.

Exact width and operand restrictions are described in the [language specification](docs/LANGUAGE-SPEC-AI-EN.md) and [`ruasm-features-v29.example.json`](spec/contracts/ruasm-features-v29.example.json).

## 3. Quick start

### Linux x86-64

```sh
chmod +x ./bin/linux-x86_64/ruasm

# Identify the compiler and inspect its actual capabilities.
./bin/linux-x86_64/ruasm --version=json
./bin/linux-x86_64/ruasm --features=json > features.json

# Validate without producing an output file.
./bin/linux-x86_64/ruasm examples/hello.asm --check

# Compile to a flat binary image.
mkdir -p build
./bin/linux-x86_64/ruasm examples/hello.asm -o build/hello.bin

# Request structured diagnostics.
./bin/linux-x86_64/ruasm examples/hello.asm --check --diagnostics=json
```

### Windows x86-64 (PowerShell 7)

```powershell
$ruasm = '.\bin\windows-x86_64\ruasm.exe'

& $ruasm --version=json
& $ruasm --features=json | Set-Content -Encoding utf8 .\features.json
& $ruasm .\examples\hello.asm --check

New-Item -ItemType Directory -Force .\build | Out-Null
& $ruasm .\examples\hello.asm -o .\build\hello.bin
if ($LASTEXITCODE -ne 0) { throw 'RUASM compilation failed' }
```

### Your first source file

```asm
; examples/hello.asm
entry:
    mov eax, 42
    ret
```

This example emits two x86-64 instructions. The compiler produces **raw bytes**, not a standalone operating-system executable. A consumer must map/load the result and provide the chosen ABI, stack, and other runtime preconditions.

More examples are in [`examples/`](examples/).

## 4. Mandatory AI-agent workflow

Agents must query the exact compiler binary that will be used:

1. Run `ruasm --version=json`; verify the version, host, and target.
2. Run `ruasm --features=json`; verify `schema_version` and save the manifest.
3. For every instruction, check the **exact** operand form, order, width, and immediate/memory restrictions.
4. Never infer support from a mnemonic name, external documentation, or experience with another assembler.
5. Generate ASCII, lowercase syntax, and one statement per physical line.
6. Run `input.asm --check --diagnostics=json`.
7. Make minimal corrections based on the structured diagnostic; do not guess unsupported forms.
8. Compile to a new output path and verify the exit code, file size, and expected bytes/hash.

See [COMPILER-SPEC-AI-EN.md](docs/COMPILER-SPEC-AI-EN.md) for the compiler contract and [LANGUAGE-SPEC-AI-EN.md](docs/LANGUAGE-SPEC-AI-EN.md) for grammar and semantics. Russian equivalents are also provided.

## 5. Repository layout

```text
bin/
  linux-x86_64/ruasm
  windows-x86_64/ruasm.exe
src/
  core/ruasm-core.asm
  platform/linux/
  platform/windows/
  generated/linux/ruasm.asm
  generated/windows/ruasm-windows.asm
docs/
  COMPILER-SPEC-AI-RU.md
  COMPILER-SPEC-AI-EN.md
  LANGUAGE-SPEC-AI-RU.md
  LANGUAGE-SPEC-AI-EN.md
spec/contracts/
  ruasm-features-v29.schema.json
  ruasm-version-v1.schema.json
  ruasm-diagnostic-v1.schema.json
  *.example.json
examples/
scripts/
LICENSE
README.md
README.en.md
AGENTS.md
PROVENANCE.md
SHA256SUMS
```

This repository intentionally contains only RUASM source code, compiler binaries, required contracts, specifications, examples, and minimal scripts. It excludes third-party assemblers and their code/binaries, historical archives, old qualification workspaces, and unrelated utilities.

## 6. Rebuild and reproducibility

The Linux compiler can rebuild both target binaries:

```sh
./scripts/rebuild-linux.sh
./scripts/rebuild-windows-cross.sh
```

Both scripts compare the generated result with the distributed binary using `cmp`. A byte-for-byte match confirms reproducibility in the environment where the command is run.

To rebuild the Windows PE natively on Windows, use PowerShell:

```powershell
.\scripts\rebuild-windows.ps1
```

After changing the shared core or a platform fragment, regenerate the complete translation units:

```sh
./tools/compose-sources.sh
```

Then run `./scripts/verify-package.sh`, rebuild both platforms, and refresh `SHA256SUMS`.

## 7. Current limitations

Version 1.11.5 does not implement full x86-64 ISA coverage, a macro processor/preprocessor, `include`, string literals, `org`, `align`, sections, `times`, reservation/file inclusion, RIP-relative addressing, segment overrides, ELF/COFF object files, relocations, a linker, symbol exports, ABI declarations, stack-frame generation, a debugger, an OS SDK, or a target standard library. See the language specification for the complete list.

The compiler does not guarantee that an arbitrary flat image can be run directly as a Linux or Windows process. It does not provide a loader or select an ABI for the user.

## 8. Long-term engineering objectives

1. Expand the precisely specified instruction set and reach competitive functional coverage for systems programming.
2. Measure compile speed and generated-code size using shared, reproducible workloads; improve them without sacrificing correctness.
3. Reduce both compiler size and output size using measurements rather than impressions.
4. Make the language suitable for AI generation through a formal grammar, explicit semantics, constrained forms, stable diagnostics, and a machine-readable contract.
5. Validate the hypothesis of fewer agent errors and lower token use through published comparative experiments.
6. Maintain a reproducible, documented evolution of an independently implemented compiler without copying third-party compiler implementations.
7. In the longer term, use RUASM to build boot and system infrastructure for a Russian operating system.

These are development goals, not claims that RUASM currently matches or exceeds FASM in functionality, speed, or readiness for operating-system development.

## 9. Independent implementation, patents, and licensing

Compiler code in this repository is distributed under the MIT License. The package does not contain third-party assembler implementations. Detailed engineering provenance and evolution records are maintained separately from this compact user-facing repository.

**MIT does not establish patent freedom.** The project does not claim that a complete patent search, freedom-to-operate (FTO) opinion, or legal guarantee of absence of patent risk has been completed. Such work requires separate patent and legal analysis for the relevant jurisdictions and intended use cases.

## 10. Contributions

A language change must update its specification, the `--features=json` schema/example as appropriate, and tests. Breaking machine-interface changes require a new schema version. Do not document a feature until it is implemented and testable.

A change proposal should identify the affected contract, minimal regression test, expected output bytes, compatibility impact, and reproducible build results.

## License

MIT. See [`LICENSE`](LICENSE) for the complete text.
