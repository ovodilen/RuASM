# Instructions for AI coding agents

This file defines the minimum repository workflow for coding agents. The live compiler binary and its JSON feature manifest are authoritative for the release being used.

## Read before editing

1. `README.md` or `README.en.md` for project scope and current limitations.
2. `docs/COMPILER-SPEC-AI-EN.md` for compiler, CLI, output, diagnostics, build, and agent contracts.
3. `docs/LANGUAGE-SPEC-AI-EN.md` for grammar, expression semantics, registers, memory operands, and instruction forms.
4. `spec/contracts/ruasm-features-v29.schema.json` and the example JSON for the machine interface.

## Mandatory discovery

Run the compiler you will actually invoke:

```sh
./bin/linux-x86_64/ruasm --version=json
./bin/linux-x86_64/ruasm --features=json > /tmp/ruasm-features.json
```

On Windows, use `bin/windows-x86_64/ruasm.exe`. Do not assume that the host-specific fields in a saved example match the current binary.

## Source-generation rules

- Treat the live `--features=json` response as the source of truth for supported instructions and operand forms.
- A supported mnemonic does not imply support for all forms of that instruction.
- Use lowercase syntax, ASCII identifiers, one statement per physical line, and labels on their own lines.
- Do not invent macros, include directives, sections, alignment directives, object-file output, ABI declarations, or other unavailable syntax.
- Use `--check --diagnostics=json` before emitting a final binary.
- Compile to a fresh output path; verify exit status, byte count, and expected bytes or hash.
- A flat binary is raw machine code, not a native Linux or Windows executable with a loader/ABI.

## Editing compiler source

- Shared parser/IR/encoding logic belongs in `src/core/ruasm-core.asm`.
- OS-specific startup and host I/O belong in `src/platform/linux/` or `src/platform/windows/`.
- `src/generated/linux/ruasm.asm` and `src/generated/windows/ruasm-windows.asm` are complete generated translation units. Regenerate them after edits to fragments/core; do not make an isolated edit to a generated file and forget its source fragments.
- Use `./tools/compose-sources.sh` to regenerate both translation units.
- The Windows generated source has a strict 196,607-byte source-file ceiling. Check its final byte count after every source change.

## Required validation after a compiler change

1. Run `./scripts/verify-package.sh`.
2. Run `./scripts/rebuild-linux.sh` and require byte-for-byte identity unless the release intentionally changes the Linux binary.
3. Run `./scripts/rebuild-windows-cross.sh` and require byte-for-byte identity unless the release intentionally changes the Windows binary.
4. Run the native Windows build/verification script on Windows before publishing a release.
5. If expected bytes or feature support change, update examples, specifications, JSON schemas/examples, and checksums in the same change.

## Engineering constraints

Make the smallest change that satisfies the task. State assumptions and a measurable success condition before implementation. Add a regression test that fails before the fix where practical. Do not broaden feature claims beyond the compiler's measured behavior. Do not claim patent clearance based on the MIT license or on an engineering provenance record.
