---
name: accessibility-code-review
description: Review newly generated or modified UI code for accessibility best practices (WCAG 2.1 AA) and report or fix issues before they enter the codebase. Use when generating or modifying UI components, reviewing pull requests or changed files, or implementing forms, navigation, dialogs and interactive components.
---

# Accessibility Code Review

## Objective

Review all newly generated or modified UI code for accessibility best practices and prevent accessibility issues before they enter the codebase.

## When to activate

- Generating new UI components.
- Modifying existing UI components.
- Reviewing pull requests or changed files.
- Implementing forms, navigation, dialogs and interactive components.

## Review checklist

### 1. Semantic HTML

- Prefer semantic elements such as `header`, `main`, `nav`, `section`, `article` and `footer`.
- Use buttons for actions and anchors for navigation.
- Maintain logical heading hierarchy.
- Avoid unnecessary div-based interactive elements.

### 2. ARIA attributes

- Use appropriate accessible roles and names.
- Validate `aria-label`, `aria-labelledby` and `aria-describedby`.
- Use `aria-expanded` for expandable controls.
- Use `aria-live` for important dynamic announcements.
- Avoid redundant or incorrect ARIA attributes.
- Prefer native HTML semantics over unnecessary ARIA.

### 3. Keyboard accessibility

- Ensure interactive elements are keyboard accessible.
- Verify logical tab order.
- Provide visible focus indicators.
- Support Enter and Space where appropriate.
- Ensure dialogs manage focus correctly.
- Avoid keyboard traps.

### 4. Forms

- Associate labels with inputs.
- Provide accessible error messages.
- Identify required fields programmatically.
- Ensure validation messages are accessible.
- Provide clear instructions for complex inputs.

### 5. Images and media

- Add meaningful alt text to informative images.
- Use empty alt text for decorative images.
- Provide captions or alternatives for relevant media.

### 6. Visual accessibility

- Check text and background contrast.
- Do not communicate status through color alone.
- Support browser zoom and responsive layouts.
- Ensure focus indicators are visible.

## Rules

- Follow WCAG 2.1 AA by default.
- Respect existing project conventions.
- Do not introduce unnecessary ARIA attributes.
- Avoid changing business logic or visual design unnecessarily.
- Do not automatically rewrite unrelated components.
- Fix straightforward violations directly.
- Report issues requiring design or product decisions.
- Distinguish verified violations from potential issues.

## Output report

For each finding provide:

- **Component/file name**
- **Affected element**
- **Accessibility issue**
- **WCAG criterion** (where identifiable)
- **Severity:** Critical, High, Medium or Low
- **Recommended fix**
- **Status:** Fixed or Requires attention

Example:

| Field | Value |
|---|---|
| Component/file | `src/components/LoginForm.tsx` |
| Affected element | `<input type="email">` |
| Issue | Input has no associated label |
| WCAG criterion | 1.3.1 Info and Relationships, 3.3.2 Labels or Instructions |
| Severity | High |
| Recommended fix | Add `<label htmlFor="email">` linked to the input's `id` |
| Status | Fixed |

## Expected outcome

All new and modified UI code follows accessibility best practices, with issues identified and corrected before completion.
