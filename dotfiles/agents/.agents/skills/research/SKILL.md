---
name: research
description: Investigate a topic methodically, verify claims, and return a decision-ready brief. Use for research questions, comparisons, vendor/tool choices, technical investigations, factual briefings, and any request asking to research, compare, evaluate, verify, or synthesize evidence.
---

# Research

Use this skill when the user wants evidence-backed research rather than an unsupported answer.

## Inputs

- Research topic or question from the user.
- Optional rigor mode: `quick`, `standard`, or `rigorous`.
- If no mode is given, use `standard`.
- If the topic is high-stakes or materially consequential, prefer `rigorous` unless the user explicitly asks for speed.

High-stakes examples: security, legal, finance, compliance, health, hiring, major architecture decisions, or expensive vendor/tool choices.

If the topic is unclear or depends materially on missing constraints, ask one concise clarifying question before deep research.

## Rigor modes

- `quick`: answer fast with 2-4 high-signal sources, minimal process overhead, and concise output.
- `standard`: balanced depth; verify load-bearing claims, prefer primary sources, and cross-check important claims when feasible.
- `rigorous`: stronger source discipline, explicit assumptions, broader cross-checking, conflict handling, and confidence calibration.

## Source discipline

- Verify factual claims the user may act on with sources rather than relying on memory.
- Prefer primary sources: official docs, vendor pages, standards, papers, repos, release notes, source code, and first-party policy pages.
- Use secondary sources only to find leads, add context, or when primary sources are unavailable.
- For time-sensitive topics, note the relevant “as of” date.
- When local repo or workspace context matters, inspect relevant files, configs, or docs first and cite file paths directly.

## Workflow

1. Restate the research question and the decision it supports, if clear.
2. Choose the rigor mode.
3. Make a short TODO plan for multi-step, ambiguous, or rigorous research. Keep it lightweight.
4. Inspect local context first when relevant.
5. Gather evidence from the highest-signal sources available.
6. Cross-check important claims when feasible; in rigorous mode, cross-check all load-bearing claims where possible.
7. Note disagreements, assumptions, version constraints, geography or pricing caveats, and date sensitivity.
8. Synthesize into a recommendation, comparison, or decision brief.
9. Stop when the answer is decision-ready and additional sources are mostly repetitive.

## Output format

Use this structure unless the user asks for a different format:

### Question
A one- or two-sentence restatement of what is being researched.

### Mode
`quick`, `standard`, or `rigorous`.

### Plan
- [x] Completed step
- [ ] Remaining step

Omit this section for very simple quick-mode tasks.

### Findings
- Bullet points with key facts.
- Cite claims inline as `[Source Title](URL)`.
- Distinguish verified facts from interpretation.
- When repo context matters, cite relevant file paths.

### Recommendation
- Concise answer or ranked options.
- Include reasoning and main tradeoffs.
- In rigorous mode, include confidence: high, medium, or low.

### Decision impact
- What evidence most changed or determined the recommendation.

### Uncertainties
- Unknowns, ambiguities, assumptions, or validation needed.

### Sources
- Clean list of the most important sources consulted.

Before finishing, check that all load-bearing claims are sourced, uncertainty is clearly marked, and depth matches the chosen rigor mode.
