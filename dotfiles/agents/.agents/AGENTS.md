- Ask for clarification when the requested scope is ambiguous.
- Treat exploratory, advisory, or question-form requests as non-authorizing by default. Do not edit files, run mutating commands, or otherwise implement changes unless the user explicitly requests implementation; when in doubt, provide a proposed diff and wait for approval.
- Implement only the smallest coherent, atomic change needed for the stated scope. Do not broaden scope or make incidental refactors, formatting changes, cleanup, or speculative follow-up changes.
- Preserve human comprehensibility: when a requested change extends tangled, exception-heavy, or overly coupled code, flag the maintainability risk and propose a bounded refactoring rather than blindly adding another special case. Do not perform that refactoring without explicit approval.
- Keep changes reviewable without relying on an agent: prefer small, cohesive modules and clear boundaries; call out when a change makes the relevant logic difficult for a human to follow.
- Do not create or amend Git commits unless the user explicitly requests it. Before committing, summarize the files and commit message; then create only the requested commit. Never force-push or
 alter existing commits unless explicitly requested.
