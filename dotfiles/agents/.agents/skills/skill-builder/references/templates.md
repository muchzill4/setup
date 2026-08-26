# Skill Templates

## Minimal skill

```markdown
---
name: <skill-name>
description: <What the skill does and when to use it. Be specific about trigger conditions.>
---

# <Human Title>

## Goal

<One or two sentences describing the repeatable task this skill handles.>

## Workflow

1. <Step one>
2. <Step two>
3. <Step three>

## Constraints

- <Important rule>
- <Important rule>

## Output

Return:

- <Expected output item>
- <Expected output item>
```

## Skill with progressive disclosure

```markdown
---
name: <skill-name>
description: <What the skill does and when to use it. Mention important trigger words/domains.>
---

# <Human Title>

## Goal

<One or two sentences.>

## Routing

- If the user asks to <mode A>, follow [Mode A](#mode-a).
- If the user asks to <mode B>, follow [Mode B](#mode-b).

## Mode A

1. Gather context.
2. If detailed scoring is needed, read `references/scoring-rubric.md`.
3. Produce <output>.

## Mode B

1. Read the supplied artifact.
2. If examples are needed, read `references/examples.md`.
3. Produce <output>.

## Constraints

- Keep the main context small; only load references when relevant.
- Ask clarifying questions when required inputs are missing.

## Output format

<Define the exact format.>
```

## Script-backed skill

```markdown
---
name: <skill-name>
description: <What the skill does and when to use it. Mention that it can inspect or transform real project data.>
---

# <Human Title>

## Goal

<One or two sentences.>

## Workflow

1. Inspect the user's request and identify the target path/input.
2. Run the helper script when deterministic data is needed:

   ```bash
   python3 <skill-dir>/scripts/<script>.py <args>
   ```

3. Use the script output as evidence.
4. Produce the final answer.

## Constraints

- Never invent facts the script could verify.
- If the script fails, report the failure and ask for the missing input.
- Do not run destructive commands without explicit confirmation.

## Output format

<Define the exact format.>
```

## Test prompts for a new skill

Use prompts like these after installing a skill:

1. Natural trigger: "<Ask for the task without naming the skill.>"
2. Explicit trigger: `Use /skill:<skill-name> to <task>`
3. Ambiguous request: "<Underspecified task>" — should ask clarifying questions.
4. Out-of-scope request: "<Related but unsupported task>" — should decline or route elsewhere.
5. Reference-heavy request: "<Task requiring rubric/examples>" — should load the reference only when needed.

## Evaluation checklist

- Did the skill load for the intended natural-language request?
- Did it avoid loading for unrelated work?
- Did it ask useful questions when details were missing?
- Did it follow the output format?
- Did it avoid bloating context with unnecessary references?
- Did scripts run successfully, if any?
- Did the final answer cite evidence when required?
