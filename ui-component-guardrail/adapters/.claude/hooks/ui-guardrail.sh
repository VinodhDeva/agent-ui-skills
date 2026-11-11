#!/bin/sh
# Reminds Claude to run the guardrail after it writes or edits a component file.
f=$(grep -oE '"file_path" *: *"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"$/\1/')
printf '%s' "$f" | grep -qE 'src/components/.*\.tsx$' || exit 0
printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"A UI component changed. Apply the UI component guardrail: run all required stages and finish with the summary table. Use the ui-component-guardrail skill."}}'
