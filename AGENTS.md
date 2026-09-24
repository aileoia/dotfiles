# Agent Guidelines

## Commit convention

This repository uses Conventional Commits:

```text
<type>(<scope>): <description>
```

- Use a scope when the change belongs to one subsystem, such as `nvim`, `zsh`, `git`, `ranger`, or `regolith`.
- Common types are `feat`, `fix`, `chore`, `docs`, `refactor`, `style`, and `build`.
- Write the description in lowercase, imperative form without a trailing period.
- Keep each commit focused on one logical change. Separate documentation, recovery snapshots, and implementation work when they can be reviewed independently.
- Add a body only when it provides useful context. Separate it from the subject with a blank line, explain why the change is needed, and wrap prose at roughly 72 characters.
- Use bullet points in the body when summarizing several related changes.
- Mark breaking changes with `!` after the type or scope and explain them in the body.

Examples:

```text
feat(nvim): add helm and docker packs
fix(zsh): load direnv hook once
docs: document commit convention
```
