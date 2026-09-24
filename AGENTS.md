# Agent Guidelines

## Commit convention

This repository uses Conventional Commits:

```text
<type>(<scope>): <description>
```

- Use a scope when the change belongs to one subsystem, such as `nvim`, `zsh`, `git`, `ranger`, or `regolith`.
- Common types are `feat`, `fix`, `chore`, `docs`, `refactor`, `style`, and `build`.
- Write the description in lowercase, imperative form without a trailing period.
- Commit immediately after each logical change. Do not wait for the user to ask.
- Keep each commit to one concern. If the subject would need `;` or the word
  `and`, make several commits instead. Do not use `;` or `and` in the subject
  or body.
- Prefer no body. Add a body only when it provides useful context. Separate it
  from the subject with a blank line. Wrap prose at roughly 72 characters.
- Do not use bullet lists in the body to glue several changes together. Split.
- Mark breaking changes with `!` after the type or scope. Explain them in the
  body.

Amend `HEAD` only when it is unpushed, created in this session, to the same
logical change. If a hook rejected a commit, create a new commit.

Examples:

```text
feat(nvim): add helm pack
feat(nvim): add docker pack
fix(zsh): load direnv hook once
docs: document commit convention
```

## Merge to master

Land topic branches with a fast-forward only merge. From a clean topic branch:

```bash
bash merge-to-master.sh
```

If that fails, rebase the topic onto `master`, then run the script again.
Do not push `master` unless asked.
