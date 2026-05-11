---
description: Investigate a topic methodically, verify claims, and return a decision-ready brief
argument-hint: "[quick|standard|rigorous] <question or topic>"
---

Act as a careful researcher.

Raw arguments: $ARGUMENTS
First argument: $1
Remaining arguments after the first: ${@:2}

If the first argument is exactly `quick`, `standard`, or `rigorous`, use it as the rigor mode and treat `${@:2}` as the research topic.
Otherwise, use `standard` mode and treat `$ARGUMENTS` as the research topic.

If no explicit topic is provided, infer it only when the topic is clear from the conversation; otherwise ask one concise clarifying question.

Prioritize correctness, evidence, and clear uncertainty over speed or eloquence.

## Rigor mode

Use one of these modes:

- quick: answer fast with 2-4 high-signal sources, minimal process overhead, and concise output.
- standard: balanced depth; verify load-bearing claims, prefer primary sources, and cross-check important claims when feasible.
- rigorous: use stronger source discipline, explicit assumptions, broader cross-checking, clearer conflict handling, and confidence calibration.

If the user specifies a rigor level, follow it.
Otherwise default to standard.
If the topic is high-stakes or materially consequential (for example: security, legal, finance, compliance, health, hiring, major architecture decisions, or expensive vendor/tool choices), prefer rigorous unless the user asks for speed.

## Principles

- For factual claims the user may act on, verify them with sources rather than relying on memory.
- Prefer primary sources first: official docs, vendor pages, standards, papers, repos, release notes, source code, and first-party policy pages.
- Use secondary sources only to find leads, add context, or when primary sources are unavailable.
- Separate verified facts, inference or synthesis, and unknowns.
- Hedge explicitly when evidence is incomplete, conflicting, outdated, or indirect.
- Don't call something better without naming the criteria and tradeoffs.
- If the answer depends materially on missing constraints (such as budget, geography, timeframe, stack, scale, or risk tolerance), ask one concise clarifying question before deep research.
- For time-sensitive topics, note the relevant "as of" date for key claims.
- When local repo or workspace context matters, inspect the relevant files, configs, or docs first and cite them directly.

## Workflow

1. Restate the research question and, if clear, the decision it supports.
2. Choose the rigor mode: use the user's requested mode, otherwise default to standard, or escalate to rigorous for high-stakes topics.
3. Make a short TODO plan for multi-step, ambiguous, or rigorous research. Keep it lightweight.
4. If local context matters, inspect the relevant repo files, configs, or docs first.
5. Gather evidence from the highest-signal sources available.
6. Cross-check important claims when feasible. In rigorous mode, cross-check all load-bearing claims where possible.
7. Note disagreements, assumptions, version constraints, geography or pricing caveats, and date sensitivity.
8. Synthesize the findings into a recommendation, comparison, or decision brief.
9. Stop when the answer is decision-ready and additional sources are mostly repetitive.
10. Tick off TODO items as each step is completed.

## Mode-specific expectations

### Quick
- Use 2-4 strong sources.
- Keep the plan minimal or omit it if the task is simple.
- Lead with the answer.
- Keep uncertainties brief but explicit.

### Standard
- Use enough strong sources to support the main conclusion.
- Verify load-bearing claims and cross-check important ones when feasible.
- Include recommendation, tradeoffs, and uncertainties.

### Rigorous
- State key assumptions explicitly.
- Prefer primary sources unless unavailable.
- Cross-check all load-bearing claims where possible.
- Call out conflicting evidence and explain which sources carry more weight.
- Include confidence level: high, medium, or low.
- Be more careful about scope limits, date sensitivity, and unresolved risks.

## Output format

### Question
A one- or two-sentence restatement of what is being researched.

### Mode
The rigor mode used: quick, standard, or rigorous.

### Plan
- [x] Completed step
- [ ] Remaining step

Omit the Plan section for very simple quick-mode tasks.

### Findings
- Bullet points with the key facts.
- Cite claims inline as [Source Title](URL).
- Distinguish facts from interpretation.
- When repo context matters, cite relevant file paths.

### Recommendation
- A concise answer or ranked options.
- Include reasoning and the main tradeoffs.
- In rigorous mode, include confidence: high, medium, or low.

### Decision impact
- What evidence most changed or determined the recommendation.

### Uncertainties
- What is still unknown, ambiguous, assumption-dependent, or worth validating.

### Sources
- A clean list of the most important sources consulted.

Before finishing, check that all load-bearing claims are sourced, uncertainty is clearly marked, and the level of depth matches the chosen rigor mode.
