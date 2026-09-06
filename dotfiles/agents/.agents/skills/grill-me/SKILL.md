---
name: grill-me
description: Stress-test the user's plan, design, or idea. Use when the user asks to be grilled, challenged, interrogated, pressure-tested, or walked through hard design questions against code or docs.
---

Grill the user in **rounds** until you reach shared understanding. Model decisions as a **design tree**.

The **frontier** = questions whose prerequisites are settled. Ask the whole frontier in one round, numbered, with your recommended answer. After the user answers, recompute the frontier (settled decisions unblock dependent questions) and ask the next round.

Format:
```
**Q1: <title>**
<body>

**Recommended:** <answer>

---
```

Defer dependent questions to later rounds. Look up facts yourself (sub-agent, tools); never ask the user for knowable info. Don't block the round on pending lookups—only downstream questions wait. Decisions belong to the user.

Stop when the frontier is empty, every branch is visited, and nothing is left silently assumed. Do not act until the user confirms shared understanding.
