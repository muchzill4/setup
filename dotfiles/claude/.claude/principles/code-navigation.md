# Code Navigation

Prefer the most semantically aware tool available:

1. **LSP** — definitions, references, call hierarchy, type info, diagnostics
2. **ast-grep** — structural/pattern queries LSP can't answer (anti-patterns, codemod-style searches)
3. **Grep/Glob** — text-only searches (TODOs, config values, string literals, comments)

Default to understanding over searching.
