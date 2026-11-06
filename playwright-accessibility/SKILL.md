---
name: playwright-accessibility
description: Integrate axe-core accessibility validation into Playwright browser tests to detect WCAG violations in real browser-rendered UI. Use when creating Playwright tests, implementing new pages or UI workflows, modifying existing UI, validating dialogs, forms, navigation and dynamic content, or preparing UI for release.
---

# Playwright Accessibility

## Objective

Integrate `axe-core` accessibility validation into Playwright browser tests to detect accessibility violations in real browser environments.

## When to activate

- Creating Playwright test cases.
- Implementing new pages or UI workflows.
- Modifying existing UI functionality.
- Validating dialogs, forms, navigation and dynamic content.
- Preparing UI for release.

## Dependencies

Use NPM when applicable:

```bash
npm install --save-dev @axe-core/playwright
```

Reuse existing Playwright dependencies.

## Implementation

Create a reusable helper at `tests/utils/accessibility.ts`:

```ts
import AxeBuilder from '@axe-core/playwright';
import { Page, expect } from '@playwright/test';

export async function checkAccessibility(page: Page) {
  const results = await new AxeBuilder({ page })
    .withTags([
      'wcag2a',
      'wcag2aa',
      'wcag21a',
      'wcag21aa'
    ])
    .analyze();

  expect(results.violations).toEqual([]);
}
```

## Playwright test integration

```ts
import { test } from '@playwright/test';
import { checkAccessibility } from './utils/accessibility';

test('dashboard should have no accessibility violations', async ({ page }) => {
  await page.goto('/dashboard');

  await checkAccessibility(page);
});
```

## Required scenarios

Validate accessibility for:

1. Initial page load.
2. Navigation and menu interactions.
3. Form interactions and validation errors.
4. Modal and dialog open/close states.
5. Dropdowns and expandable sections.
6. Loading and error states.
7. Dynamic content updates.
8. Responsive layouts where applicable.

## Rules

- Execute accessibility checks after the UI reaches the expected state.
- Wait for asynchronous content to load.
- Test meaningful interaction states, not only initial page rendering.
- Do not ignore violations without documented justification.
- Do not suppress failing rules merely to achieve a passing build.
- Avoid duplicate scans of identical page states.
- Reuse shared accessibility utilities.
- Preserve existing Playwright test conventions.
- Report incomplete coverage separately from detected violations.
- Do not assume axe-core validates every keyboard, screen-reader or visual accessibility requirement.

## Reporting

For every violation report:

- **Page URL**
- **Affected element**
- **Violation ID**
- **WCAG tags**
- **Impact level**
- **Description**
- **Suggested remediation**

## Expected outcome

Playwright tests automatically detect accessibility violations in actual browser-rendered UI and fail when unapproved violations are found.
