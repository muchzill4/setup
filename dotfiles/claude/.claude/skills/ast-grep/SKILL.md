---
name: ast-grep
description: Structural code search using AST patterns. Use for finding code structures, anti-patterns, or complex queries beyond text search.
allowed-tools:
  - Bash
  - Read
---

# ast-grep Code Search

## Workflow

1. Understand what pattern, language, and edge cases the user wants to match
2. Write a test snippet and rule, start simple
3. Test with CLI, debug with `--debug-query=cst` if no matches
4. Search the codebase once the rule works

## CLI Commands

### Pattern search (simple, single-node matches)

```bash
ast-grep run --pattern 'console.log($ARG)' --lang javascript .
```

### Rule search (complex structural queries)

```bash
# With rule file
ast-grep scan --rule my_rule.yml /path/to/project

# Inline (escape $ as \$ in shell)
ast-grep scan --inline-rules "id: my-rule
language: javascript
rule:
  kind: function_declaration
  has:
    pattern: await \$EXPR
    stopBy: end" /path/to/project
```

### AST inspection (debugging)

```bash
ast-grep run --pattern 'your code here' --lang javascript --debug-query=cst
```

Formats: `cst` (all nodes), `ast` (named nodes only), `pattern` (how ast-grep reads your pattern).

### Test against stdin

```bash
echo "const x = await fetch();" | ast-grep scan --inline-rules "..." --stdin
```

## Rule Writing

- Always use `stopBy: end` on relational rules (`has`, `inside`)
- Start with `pattern`, fall back to `kind` + `has`/`inside`, then compose with `all`/`any`/`not`
- Use `--debug-query=cst` to find correct `kind` values when patterns don't match

See `references/rule_reference.md` for full rule syntax.
