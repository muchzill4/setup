---
name: research
description: Investigate a topic methodically, verify claims, and return a decision-ready brief. Use for research questions, comparisons, vendor/tool choices, technical investigations, factual briefings, and any request asking to research, compare, evaluate, verify, or synthesize evidence.
---

# Purpose

Produce an evidence-backed, decision-ready answer.

## Workflow

1. Identify the question and decision it supports. Ask one concise clarifying question only when missing constraints materially affect the answer.
2. Choose a rigor mode: `quick` for 2–4 high-signal sources and a concise answer; `standard` to verify load-bearing claims; `rigorous` for consequential topics, with broader cross-checking, explicit assumptions, and confidence calibration. Default to `standard`; prefer `rigorous` for high-stakes decisions unless speed is requested.
3. Inspect relevant local files first. Cite their paths directly when they inform the answer.
4. Gather the highest-signal evidence available. Prefer primary sources; use secondary sources for leads, context, or when primary sources are unavailable.
5. Cross-check load-bearing claims when feasible. Record material disagreements, assumptions, version, geography, pricing, and date caveats.
6. Synthesize a recommendation or comparison. Stop when it is decision-ready and additional evidence is repetitive.

## Output

Use the user's requested format, or provide:

- **Question** and **Mode**
- **Findings** with inline source links and verified facts distinguished from interpretation
- **Recommendation** with key tradeoffs; include confidence for rigorous research
- **Decision impact** and **Uncertainties**
- **Sources** with the most important material consulted

For multi-step or rigorous work, include a short plan with completed and remaining steps.

## Validation

- Source every claim the user may act on.
- State the relevant “as of” date for time-sensitive findings.
- Match depth to the selected rigor mode.
