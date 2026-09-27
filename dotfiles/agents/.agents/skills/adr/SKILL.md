---
name: adr
description: Record an agreed, non-obvious design decision as an architecture decision record in the repository. Use when the user asks to record, document, or capture a decision or ADR.
---

# Purpose

Record why a decision was made so later sessions reuse it instead of relitigating it.

## Workflow

1. Record only decisions the user has agreed to. If the decision is still open, name the blocking question and stop.
2. Follow the repository's existing ADR location, numbering, and template. If none exist, propose `docs/adr/NNNN-kebab-title.md` and confirm before creating it.
3. Write briefly:
   - **Status** and date;
   - **Context**: the forces and constraints that made the choice necessary;
   - **Decision**: what was chosen, stated as a rule future changes must follow;
   - **Consequences**: tradeoffs accepted, and what would justify revisiting the decision.
4. Cite the relevant code, plans, or prior ADRs by path. If this decision replaces an earlier ADR, update the earlier ADR's status to link to the new one.

## Validation

- A reader can tell what future changes must do or avoid without reading the conversation.
- Only the ADR files are changed; do not commit unless asked.
