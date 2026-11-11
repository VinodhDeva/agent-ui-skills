---
trigger: glob
globs: src/components/**/*.tsx
---

# UI Component Guardrail

Mandatory checklist whenever you create or modify a UI component, page or user flow.
Run the four stages in order. Do not report the task as done until every stage passes or its open issues are reported.

Baseline: WCAG 2.1 AA, unless the project specifies otherwise.

## When to run

| Change | Stages |
|---|---|
| New component | 1, 2, 3 (+4 if it is rendered on a page or flow) |
| Markup change: forms, dialogs, navigation, tables, interactive elements | 1, 2, 3 (+4 if on a page or flow) |
| New page or UI workflow | 1, 2, 3, 4 |
| Logic or style refactor with no DOM change | 1 |

## General rules

- Inspect the existing project architecture, dependencies and conventions before changing anything.
- Reuse existing dependencies, utilities and test configuration. Do not add libraries without justification.
- Keep changes small and focused. Do not modify unrelated files or business logic.
- Preserve existing functionality and existing tests.
- Fix straightforward violations directly. Report issues that need a design or product decision.
- Never suppress a violation or disable a rule just to make a check pass.
- Do not claim full accessibility compliance from automated tests alone.

---

## Stage 1: Code quality

### Component architecture
- Single responsibility. Avoid unnecessarily large components.
- Separate UI, business logic and data access.
- Prefer composition. Avoid unnecessary prop drilling.

### TypeScript
- Strict typing. Avoid `any` unless justified.
- Define reusable interfaces and types.
- Handle nullable and optional values safely. Avoid unnecessary type assertions.

### React
- Follow the Rules of Hooks.
- Use stable keys for dynamic lists.
- Avoid unnecessary `useEffect`, state duplication and re-renders.
- Use `useMemo` and `useCallback` only when beneficial.
- Clean up subscriptions and event listeners.

### Performance
- Avoid expensive calculations during render.
- Virtualize or paginate large lists when needed.
- Use lazy loading and optimized images where beneficial.

### API and state
- Handle loading, success and error states.
- Avoid duplicate API requests. Handle failures gracefully.
- Keep API logic out of presentation components. Follow existing state management.

### Code standards
- Follow existing ESLint and Prettier configuration.
- Remove unused imports and variables. Avoid duplicated logic.
- Use meaningful names. No hardcoded configuration values.
- Follow existing folder and file naming conventions.
- Add test IDs to relevant interactive UI elements, following the project's convention.

---

## Stage 2: Accessibility code review

### Semantic HTML
- Use `header`, `main`, `nav`, `section`, `article`, `footer` where appropriate.
- Buttons for actions, anchors for navigation. No clickable `div`s.
- Keep a logical heading hierarchy.

### ARIA
- Prefer native HTML semantics over ARIA. No redundant or incorrect ARIA.
- Every interactive element has an accessible name (`aria-label`, `aria-labelledby`, or visible label).
- Use `aria-describedby` for hints and errors, `aria-expanded` for expandable controls, `aria-live` for important dynamic announcements.

### Keyboard
- All interactive elements are keyboard accessible, with a logical tab order.
- Visible focus indicators.
- Enter and Space work where expected.
- Dialogs move focus in, trap it while open, and restore it on close. No keyboard traps elsewhere.

### Forms
- Every input has an associated label.
- Required fields are marked programmatically.
- Error and validation messages are accessible and linked to their input.
- Complex inputs have clear instructions.

### Images and media
- Informative images have meaningful `alt` text. Decorative images use `alt=""`.
- Relevant media has captions or an alternative.

### Visual
- Text and background contrast meets AA.
- Status is never communicated by color alone.
- Layout supports browser zoom and responsive sizes.

---

## Stage 3: Jest unit tests with jest-axe

1. Detect the existing test setup and reuse the Jest and React Testing Library configuration.
2. If missing, install: `npm install --save-dev jest-axe` (and `@types/jest-axe` for TypeScript). Use the project's package manager.
3. Create the shared utility once, at `src/test-utils/accessibility.ts`:

```ts
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

export const checkAccessibility = async (container: HTMLElement) => {
  const results = await axe(container, {
    runOnly: { type: 'tag', values: ['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'] },
  });
  expect(results).toHaveNoViolations();
};
```

4. Add an accessibility assertion to the component's test:

```tsx
import { render } from '@testing-library/react';
import { checkAccessibility } from '../test-utils/accessibility';
import LoginForm from './LoginForm';

describe('LoginForm accessibility', () => {
  it('has no accessibility violations', async () => {
    const { container } = render(<LoginForm />);
    await checkAccessibility(container);
  });
});
```

5. Cover the states the component actually has: default, loading, error, success, disabled, modal open, dynamic content, form validation.

Rules:
- Always `await` the axe check. Accessibility failures must fail the test.
- Do not duplicate accessibility tests for the same state.
- JSDOM cannot check color contrast or real browser behavior. Stage 4 covers that.

---

## Stage 4: Playwright browser tests with @axe-core/playwright

Run this stage when the component is rendered on a page or in a user flow.

1. If missing, install: `npm install --save-dev @axe-core/playwright`. Reuse existing Playwright dependencies.
2. Create the shared helper once, at `tests/utils/accessibility.ts`:

```ts
import AxeBuilder from '@axe-core/playwright';
import { Page, expect } from '@playwright/test';

export async function checkAccessibility(page: Page) {
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
    .analyze();
  expect(results.violations).toEqual([]);
}
```

3. Add a check to the page or flow test:

```ts
import { test } from '@playwright/test';
import { checkAccessibility } from './utils/accessibility';

test('dashboard has no accessibility violations', async ({ page }) => {
  await page.goto('/dashboard');
  await checkAccessibility(page);
});
```

4. Scan each meaningful state: initial load, navigation and menus, form errors, dialog open and closed, dropdowns and expandable sections, loading and error states, dynamic updates, responsive layouts.

Rules:
- Scan only after the UI reaches the expected state. Wait for async content.
- Do not scan identical states twice.
- Any ignored rule needs a documented justification.
- axe-core does not cover every keyboard, screen reader or visual requirement. Report incomplete coverage separately from violations.

---

## Validation

Run what the project has, using its own scripts:

1. ESLint
2. TypeScript type check (`tsc --noEmit`)
3. Jest tests for the changed components
4. Playwright tests for affected pages (Stage 4 only)
5. Production build

Fix failures and re-run until they pass, or report what is still failing.

## Final report

End with one summary table:

| Stage | Result | Fixed | Needs attention |
|---|---|---|---|
| 1. Code quality | pass / fail | ... | ... |
| 2. Accessibility review | pass / fail | ... | ... |
| 3. Jest + jest-axe | pass / fail / skipped | ... | ... |
| 4. Playwright + axe | pass / fail / skipped | ... | ... |

For each accessibility finding, give: file, affected element, issue, WCAG criterion, severity (Critical, High, Medium, Low), recommended fix, and status (Fixed or Requires attention). For Playwright violations, also give the page URL, violation ID and impact level.
