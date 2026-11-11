#!/bin/sh
# Generates per-tool adapters from GUARDRAIL.md into ./adapters.
# Usage: COMPONENT_GLOB='src/components/**/*.tsx' ./sync.sh
set -eu

cd "$(dirname "$0")"
SRC=GUARDRAIL.md
OUT=adapters
GLOB="${COMPONENT_GLOB:-src/components/**/*.tsx}"
# Regex used by the Claude Code hook; must match the same files as GLOB.
REGEX="${COMPONENT_REGEX:-src/components/.*\\.tsx\$}"
DESC="UI component guardrail: code quality, accessibility review, jest-axe and Playwright axe checks. Use when creating or modifying UI components, pages or flows."
PROMPT="A UI component changed. Apply the UI component guardrail: run all required stages and finish with the summary table."

[ -f "$SRC" ] || { echo "missing $SRC" >&2; exit 1; }
rm -rf "$OUT"

# write <path> <frontmatter>: frontmatter block (may be empty) + GUARDRAIL.md body
write() {
  mkdir -p "$(dirname "$OUT/$1")"
  { [ -n "$2" ] && printf -- '---\n%s\n---\n\n' "$2"; cat "$SRC"; } > "$OUT/$1"
}

# Claude Code: skill
write .claude/skills/ui-component-guardrail/SKILL.md "name: ui-component-guardrail
description: \"$DESC\""

# Claude Code: PostToolUse hook script + settings snippet to merge
mkdir -p "$OUT/.claude/hooks"
cat > "$OUT/.claude/hooks/ui-guardrail.sh" <<EOF
#!/bin/sh
# Reminds Claude to run the guardrail after it writes or edits a component file.
f=\$(grep -oE '"file_path" *: *"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"\$/\1/')
printf '%s' "\$f" | grep -qE '$REGEX' || exit 0
printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"$PROMPT Use the ui-component-guardrail skill."}}'
EOF
chmod +x "$OUT/.claude/hooks/ui-guardrail.sh"
cat > "$OUT/.claude/settings.ui-guardrail.json" <<'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/ui-guardrail.sh" }
        ]
      }
    ]
  }
}
EOF

# Cursor: auto-attached rule
write .cursor/rules/ui-component-guardrail.mdc "description: \"$DESC\"
globs: $GLOB
alwaysApply: false"

# Kiro: steering file + file-edit hook
write .kiro/steering/ui-component-guardrail.md "inclusion: fileMatch
fileMatchPattern: \"$GLOB\""
mkdir -p "$OUT/.kiro/hooks"
cat > "$OUT/.kiro/hooks/ui-component-guardrail.kiro.hook" <<EOF
{
  "enabled": true,
  "name": "UI component guardrail",
  "description": "Runs the UI component guardrail when a component file is saved.",
  "version": "1",
  "when": { "type": "fileEdited", "patterns": ["$GLOB"] },
  "then": { "type": "askAgent", "prompt": "$PROMPT See .kiro/steering/ui-component-guardrail.md." }
}
EOF

# GitHub Copilot: path-scoped instructions
write .github/instructions/ui-component-guardrail.instructions.md "applyTo: \"$GLOB\""

# Windsurf: glob-triggered rule
write .windsurf/rules/ui-component-guardrail.md "trigger: glob
globs: $GLOB"

# Codex, Gemini CLI, other AGENTS.md readers: section to append to AGENTS.md
write AGENTS.ui-guardrail.md ""

echo "Generated adapters for glob '$GLOB':"
find "$OUT" -type f | sort
