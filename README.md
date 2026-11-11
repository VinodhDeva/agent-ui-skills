# agent-ui-skills

Reusable agent skills that help AI coding agents produce accessible, well-tested and maintainable UI code, plus one combined **UI Component Guardrail** that works across AI coding tools: Claude Code, Kiro, Cursor, GitHub Copilot, Windsurf, and any tool that reads `AGENTS.md` (Codex, Gemini CLI and others).

## Contents

| Folder | Purpose | Use when |
|---|---|---|
| [`ui-component-guardrail`](./ui-component-guardrail/) | **Combined guardrail.** Runs all four skills below, in order, every time a UI component is created or changed. Works in every major AI coding tool. | You want these checks applied automatically, not only when someone remembers to ask. |
| [`ui-code-quality`](./ui-code-quality/SKILL.md) | Enforces component architecture, strict TypeScript, React best practices, performance, API handling, testing and code standards. | Creating or refactoring components, building API integrations, adding dependencies. |
| [`accessibility-code-review`](./accessibility-code-review/SKILL.md) | Reviews new or changed UI code against a WCAG 2.1 AA checklist (semantics, ARIA, keyboard, forms, media, visuals) and reports findings with severity and status. | Generating or modifying components, reviewing PRs, building forms, navigation or dialogs. |
| [`accessibility-unit-testing`](./accessibility-unit-testing/SKILL.md) | Adds automated axe checks to Jest and React Testing Library tests using `jest-axe`, with a shared test utility. | Creating components, writing or changing unit tests, fixing accessibility issues. |
| [`playwright-accessibility`](./playwright-accessibility/SKILL.md) | Adds axe checks to Playwright browser tests using `@axe-core/playwright`, covering real interaction states. | Writing Playwright tests, shipping new pages or workflows, preparing a release. |

The four individual skills still work on their own. The guardrail merges their content into one file, because tools other than Claude Code cannot call one skill from another.

---

## UI Component Guardrail

### What it does

When an agent creates or edits a component, it runs four stages in order:

1. **Code quality**: architecture, TypeScript, React, performance, API and state handling.
2. **Accessibility review**: semantic HTML, ARIA, keyboard, forms, images, contrast.
3. **Jest + jest-axe**: an accessibility assertion in the component's unit test, for each relevant state.
4. **Playwright + axe**: a browser scan of the page or flow that renders the component.

It then runs lint, type check, tests and build, and ends with one summary table.

| Change | Stages run |
|---|---|
| New component | 1, 2, 3 (+4 if on a page or flow) |
| Markup change in forms, dialogs, navigation, tables or interactive elements | 1, 2, 3 (+4 if on a page or flow) |
| New page or UI workflow | 1, 2, 3, 4 |
| Logic or style refactor with no DOM change | 1 |

### How it is built

```
ui-component-guardrail/
├── GUARDRAIL.md   ← single source of truth: edit this file only
├── sync.sh        ← generates every tool's adapter from GUARDRAIL.md
└── adapters/      ← generated output, mirrors an app repo's root layout
```

The rules are the same in every tool. Only the trigger differs:

| Tool | Generated file | Trigger | Enforced? |
|---|---|---|---|
| Claude Code | `.claude/skills/ui-component-guardrail/SKILL.md` + `.claude/hooks/ui-guardrail.sh` | `PostToolUse` hook fires after every write or edit of a matching file | Yes, the hook reminds the agent every time |
| Kiro | `.kiro/steering/ui-component-guardrail.md` + `.kiro/hooks/ui-component-guardrail.kiro.hook` | Steering loads on file match; hook fires on file edit | Yes, via the hook |
| Cursor | `.cursor/rules/ui-component-guardrail.mdc` | Rule auto-attaches when a matching file is in context | Rules loaded, not forced |
| GitHub Copilot | `.github/instructions/ui-component-guardrail.instructions.md` | `applyTo` glob | Rules loaded, not forced |
| Windsurf | `.windsurf/rules/ui-component-guardrail.md` | Glob trigger | Rules loaded, not forced |
| Codex, Gemini CLI, others | `AGENTS.ui-guardrail.md` (append to `AGENTS.md`) | Always loaded | Rules loaded, not forced |

### Install in an app repo

**1. Generate adapters for your component path.** The default glob is `src/components/**/*.tsx`. Set your own if it differs:

```bash
git clone https://github.com/VinodhDeva/agent-ui-skills.git
cd agent-ui-skills/ui-component-guardrail
COMPONENT_GLOB='app/components/**/*.tsx' COMPONENT_REGEX='app/components/.*\.tsx$' ./sync.sh
```

`COMPONENT_GLOB` is used by Kiro, Cursor, Copilot and Windsurf. `COMPONENT_REGEX` is used by the Claude Code hook. Keep both matching the same files. Start the glob with a folder name, not `**`, so the YAML frontmatter stays valid.

**2. Copy the adapters into your app repo.** Copy only the tools your team uses. To copy all of them:

```bash
cp -R adapters/. /path/to/your-app/
```

**3. Finish two manual merges.** These files are named so they never overwrite your existing config:

- **Claude Code:** merge `.claude/settings.ui-guardrail.json` into `.claude/settings.json` (add its `PostToolUse` entry to your `hooks`), then delete `settings.ui-guardrail.json`.
- **`AGENTS.md` tools:** append the content of `AGENTS.ui-guardrail.md` to your `AGENTS.md`, then delete `AGENTS.ui-guardrail.md`.

**4. Install the test dependencies in the app.** The agent also installs them on first use if they are missing.

```bash
npm install --save-dev jest-axe @types/jest-axe @axe-core/playwright
```

### Updating the rules

1. Edit `ui-component-guardrail/GUARDRAIL.md` only. Never edit files in `adapters/` by hand; `sync.sh` overwrites them.
2. Run `./sync.sh`.
3. Commit both `GUARDRAIL.md` and `adapters/`, then copy the adapters into your app repos again.

### Limits

- **Only the Claude Code and Kiro hooks actively push the agent to run the guardrail.** In Cursor, Copilot, Windsurf and `AGENTS.md` tools, the rules are loaded into context and the agent normally follows them, but nothing forces it.
- **Hooks only cover code an agent writes.** Hand-written code needs CI.
- **For a hard gate, run the tests in CI** and fail the pull request on violations. This works no matter which tool, or person, wrote the code:

  ```yaml
  - run: npx jest
  - run: npx playwright test
  ```

- Tool config formats change often. If a tool stops picking up a file, check its current docs for the rule or hook format and update `sync.sh`.

---

## Installing the individual skills

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

## Baseline and assumptions

- Accessibility baseline is **WCAG 2.1 AA** unless a project specifies otherwise.
- The skills assume a React and TypeScript stack, with Jest, React Testing Library and Playwright for testing. They tell the agent to reuse existing project conventions and dependencies first.
- Automated checks (axe-core) catch only part of accessibility issues. They do not replace manual keyboard testing, screen reader testing, or visual contrast review. JSDOM in particular cannot evaluate color contrast.

## Contributing

To add a skill, create a new folder with a `SKILL.md` containing frontmatter:

```markdown
---
name: your-skill-name
description: What the skill does and when an agent should use it.
---
```

Keep the `name` identical to the folder name, make the `description` specific about triggers, and add a row to the table above.

To change the guardrail, edit `ui-component-guardrail/GUARDRAIL.md` and run `ui-component-guardrail/sync.sh`. If you change one of the four individual skills, update the matching stage in `GUARDRAIL.md` too.
