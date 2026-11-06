---
name: accessibility-unit-testing
description: Integrate automated accessibility validation into Jest unit tests using axe-core and jest-axe. Use when creating new UI components, generating or modifying unit tests, updating forms, dialogs, tables or interactive elements, or fixing accessibility issues.
---

# Accessibility Unit Testing

## Objective

Integrate automated accessibility validation into Jest unit tests using `axe-core` and `jest-axe`, so accessibility regressions are caught during normal unit test execution.

## When to activate

- Creating new UI components.
- Generating or modifying unit tests.
- Updating forms, dialogs, tables or interactive elements.
- Fixing accessibility issues.

## Instructions

1. Detect the existing testing framework and dependencies.
2. Reuse existing Jest and React Testing Library configuration.
3. Integrate `jest-axe` if not already installed.
4. Create a shared accessibility test utility.
5. Add accessibility assertions to relevant component tests.
6. Ensure accessibility failures fail the Jest test.

## Dependencies

Use NPM when the project uses NPM:

```bash
npm install --save-dev jest-axe
```

Reuse existing `axe-core`, Jest and Testing Library dependencies. If the project is TypeScript, also add `@types/jest-axe` when it is missing.

## Shared utility

Create `src/test-utils/accessibility.ts`:

```ts
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

export const checkAccessibility = async (
  container: HTMLElement
) => {
  const results = await axe(container, {
    runOnly: {
      type: 'tag',
      values: [
        'wcag2a',
        'wcag2aa',
        'wcag21a',
        'wcag21aa'
      ]
    }
  });

  expect(results).toHaveNoViolations();
};
```

## Unit test integration

```tsx
import { render } from '@testing-library/react';
import { checkAccessibility } from '../test-utils/accessibility';
import LoginForm from './LoginForm';

describe('LoginForm Accessibility', () => {
  it('should have no accessibility violations', async () => {
    const { container } = render(<LoginForm />);

    await checkAccessibility(container);
  });
});
```

## Required validation scenarios

Test relevant component states:

- Default state.
- Loading state.
- Error state.
- Success state.
- Disabled state.
- Modal open state.
- Dynamic content state.
- Form validation state.

## Rules

- Never suppress violations just to make tests pass.
- Fix issues in the actual component wherever possible.
- Avoid duplicate accessibility tests.
- Always await asynchronous axe checks.
- Preserve existing unit tests.
- Do not modify application business logic.
- Follow existing Jest configuration.
- Use WCAG 2.1 AA as the default baseline unless the project specifies otherwise.
- Do not claim full accessibility compliance based on automated tests alone.
- Recognize JSDOM limitations, especially visual contrast and browser-specific behavior.

## Validation

1. Run relevant Jest tests.
2. Execute accessibility assertions.
3. Report violated rules and affected elements.
4. Suggest appropriate fixes.
5. Re-run tests after fixes.
6. Ensure accessibility violations produce test failures.

## Expected outcome

Relevant UI components have automated accessibility validation integrated into their Jest unit tests. Accessibility regressions are caught during normal unit test execution.
