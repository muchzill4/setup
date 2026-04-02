# Code Navigation

## Tool Hierarchy

Prefer the most semantically aware tool available for the task:

1. **LSP** — first choice for all code navigation (definitions, references, call hierarchy, type info, diagnostics)
2. **ast-grep** — structural/pattern queries LSP can't answer (anti-patterns, missing error handling, codemod-style searches)
3. **Grep/Glob** — text-only searches where structure doesn't matter (TODOs, config values, string literals, comments)

## When to use each

| Task | Tool |
|---|---|
| Where is X defined? | LSP `goToDefinition` |
| What calls X? | LSP `findReferences` |
| Who implements interface method X? | LSP `findReferences` on the interface definition |
| Find all callers of method X? | LSP `findReferences` |
| Type info without reading a file | LSP `hover` |
| Find async functions without error handling | ast-grep |
| Find structural anti-patterns | ast-grep |
| Find a string in comments or config | Grep |
| Find files by name | Glob |

## Key point

Grep finds text. LSP understands code. ast-grep understands structure. Default to understanding over searching.
