# agent-ui-skills

A collection of reusable [Agent Skills](https://docs.claude.com) that help AI coding agents produce accessible, well-tested and maintainable UI code. Each skill is a self-contained folder with a `SKILL.md` file (YAML frontmatter plus instructions) that an agent loads when the task matches its description.

## Skills

| Skill | Purpose | Use when |
|---|---|---|
| [`accessibility-code-review`](./accessibility-code-review/SKILL.md) | Reviews new or changed UI code against a WCAG 2.1 AA checklist (semantics, ARIA, keyboard, forms, media, visuals) and reports findings with severity and status. | Generating or modifying components, reviewing PRs, building forms, navigation or dialogs. |
| [`accessibility-unit-testing`](./accessibility-unit-testing/SKILL.md) | Adds automated axe checks to Jest and React Testing Library tests using `jest-axe`, with a shared test utility. | Creating components, writing or changing unit tests, fixing accessibility issues. |
| [`playwright-accessibility`](./playwright-accessibility/SKILL.md) | Adds axe checks to Playwright browser tests using `@axe-core/playwright`, covering real interaction states. | Writing Playwright tests, shipping new pages or workflows, preparing a release. |
| [`ui-code-quality`](./ui-code-quality/SKILL.md) | Enforces component architecture, strict TypeScript, React best practices, performance, API handling, testing and code standards. | Creating or refactoring components, building API integrations, adding dependencies. |

## Repository structure

```
agent-ui-skills/
├── accessibility-code-review/
│   └── SKILL.md
├── accessibility-unit-testing/
│   └── SKILL.md
├── playwright-accessibility/
│   └── SKILL.md
├── ui-code-quality/
│   └── SKILL.md
└── README.md
```

## Installation

### Claude Code (project-level)

Copy the skill folders you want into your project's `.claude/skills/` directory:

```bash
git clone https://github.com/VinodhDeva/agent-ui-skills.git
mkdir -p .claude/skills
cp -r agent-ui-skills/accessibility-code-review .claude/skills/
cp -r agent-ui-skills/accessibility-unit-testing .claude/skills/
cp -r agent-ui-skills/playwright-accessibility .claude/skills/
cp -r agent-ui-skills/ui-code-quality .claude/skills/
```

### Claude Code (personal, all projects)

Copy the folders into `~/.claude/skills/` instead.

### Claude.ai

Zip an individual skill folder (for example `accessibility-code-review/`) and upload it under Settings, Capabilities, Skills.

## Recommended combination

The skills are designed to complement each other when building a UI feature:

1. **`ui-code-quality`** guides the implementation.
2. **`accessibility-code-review`** checks the new code for accessibility issues.
3. **`accessibility-unit-testing`** locks accessibility into Jest component tests.
4. **`playwright-accessibility`** verifies real-browser behavior end to end.

## Baseline and assumptions

- Accessibility baseline is **WCAG 2.1 AA** unless a project specifies otherwise.
- Skills assume a React and TypeScript stack, with Jest, React Testing Library and Playwright for testing. They instruct the agent to reuse existing project conventions and dependencies first.
- Automated checks (axe-core) catch only a portion of accessibility issues. They do not replace manual keyboard testing, screen reader testing, or visual contrast review. JSDOM in particular cannot evaluate color contrast.

## Contributing

To add a skill, create a new folder with a `SKILL.md` containing frontmatter:

```markdown
---
name: your-skill-name
description: What the skill does and when an agent should use it.
---
```

Keep the `name` identical to the folder name, make the `description` specific about triggers, and add a row to the table above.
