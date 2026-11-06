---
name: ui-code-quality
description: Ensure AI-generated and modified UI code follows consistent engineering standards, clean architecture, TypeScript and React best practices, and performance-conscious patterns. Use when creating or modifying UI components, refactoring code, creating API integrations, reviewing UI implementation, or adding new dependencies.
---

# UI Code Quality

## Objective

Ensure AI-generated and modified UI code follows consistent engineering standards, clean architecture, performance best practices and maintainable coding patterns.

## When to activate

- Creating new UI components.
- Modifying existing components.
- Refactoring code.
- Creating API integrations.
- Reviewing UI implementation.
- Adding new dependencies.

## Review standards

### 1. Component architecture

- Follow single-responsibility principles.
- Create reusable components.
- Avoid unnecessarily large components.
- Separate UI, business logic and data access.
- Avoid unnecessary prop drilling.
- Use composition where appropriate.

### 2. TypeScript

- Prefer strict TypeScript typing.
- Avoid `any` unless justified.
- Define reusable interfaces and types.
- Handle nullable and optional values safely.
- Avoid unnecessary type assertions.

### 3. React best practices

- Follow React Hooks rules.
- Avoid unnecessary re-renders.
- Use stable keys for dynamic lists.
- Avoid unnecessary `useEffect` logic.
- Use `useMemo` and `useCallback` only when beneficial.
- Clean up subscriptions and event listeners.
- Avoid unnecessary state duplication.

### 4. Performance

- Identify unnecessary component renders.
- Avoid expensive calculations during rendering.
- Optimize large lists when appropriate.
- Avoid unnecessary dependencies.
- Use lazy loading where beneficial.
- Optimize image loading and rendering.

### 5. API and state management

- Handle loading, success and error states.
- Avoid duplicate API requests.
- Follow existing state management conventions.
- Handle API failures gracefully.
- Keep API logic separate from presentation components.

### 6. Testing

- Maintain meaningful unit test coverage.
- Test important user interactions.
- Test edge cases and error states.
- Follow existing testing conventions.
- Ensure test IDs are present on relevant UI elements.
- Include accessibility assertions where applicable.

### 7. Code standards

- Follow existing ESLint and Prettier configuration.
- Avoid duplicated logic.
- Remove unused imports and variables.
- Avoid unnecessary abstractions.
- Use meaningful naming conventions.
- Avoid hardcoded configuration values.
- Follow existing folder and file naming conventions.

## Rules

- Inspect the existing project architecture before making changes.
- Reuse existing dependencies and utilities.
- Do not introduce new libraries without justification.
- Avoid unnecessary refactoring.
- Do not modify unrelated files.
- Preserve existing functionality.
- Prefer small, focused changes.
- Never sacrifice readability for premature optimization.

## Validation

After implementation:

1. Run ESLint.
2. Run TypeScript type checking.
3. Run relevant Jest tests.
4. Run production build.
5. Review potential performance issues.
6. Report unresolved warnings and errors.

## Expected outcome

All newly generated and modified UI code follows consistent, maintainable, type-safe and performance-conscious engineering practices.
