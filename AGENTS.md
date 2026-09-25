# Agent Guidelines

## Branch hygiene

- At the start of every user prompt, inspect the current branch and working
  tree status.
- Before starting a new concern, ensure the previous topic branch is clean and
  landed on `master`, then create a fresh topic branch.
- Preserve unrelated user changes when landing or switching branches.

## Commit convention

This repository uses Conventional Commits:

```text
<type>(<scope>): <description>
```

- Use a scope when the change belongs to one subsystem, such as `nvim`, `zsh`, `git`, `ranger`, or `regolith`.
- Common types are `feat`, `fix`, `chore`, `docs`, `refactor`, `style`, and `build`.
- Write the description in lowercase, imperative form without a trailing period.
- Commit immediately after each logical change. Do not wait for the user to ask.
- Do not batch unrelated files into one commit.
- Keep each commit to one concern. If the subject would need `;` or the word
  `and`, make several commits instead. Do not use `;` or `and` in the subject
  or body.
- Prefer no body. Add a body only when it provides useful context. Separate it
  from the subject with a blank line. Wrap prose at roughly 72 characters.
- Do not use bullet lists in the body to glue several changes together. Split.
- Mark breaking changes with `!` after the type or scope. Explain them in the
  body.

Amend `HEAD` only when it is unpushed, created in this session, to the same
logical change. If a hook rejected a commit, create a new commit. Do not skip
hooks. Do not amend commits you did not create.

Examples:

```text
feat(nvim): add helm pack
feat(nvim): add docker pack
fix(zsh): load direnv hook once
docs: document commit convention
```

Bad subjects: `feat(nvim): add helm and docker packs`,
`docs: rewrite readme; document install`.

## Merge to master

Land topic branches with a fast-forward only merge onto `master`. Never
`git merge --no-ff`. Never create a merge commit on `master`. Do not push
`master` unless the user asks.

From a clean topic branch:

```bash
git fetch origin
git merge-base --is-ancestor master HEAD
git switch master
git merge --ff-only <topic-branch>
```

If `master` is not an ancestor of `HEAD`, rebase the topic onto `master`, then
fast-forward. Do not merge `master` into the topic as the landing step.

## Shell scripts

In every shell script, write `set` options and command flags in long form.
Do not use clustered short flags (`set -euo pipefail`, `curl -fsSL`, `rm -rf`).

This repo targets GNU/Linux, so prefer GNU long options (`mkdir --parents`,
`mktemp --directory`). Prefer a program's long CLI names when they exist.

```bash
# BAD
set -euo pipefail
mkdir -p "$HOME/.local/bin"
curl -fsSL --retry 3 -o "$dest" "$url"
rm -rf "$tmpdir"
ln -sfn "$src" "$dst"

# GOOD
set -o errexit -o nounset -o pipefail
mkdir --parents "$HOME/.local/bin"
curl --fail --silent --show-error --location --retry 3 --output "$dest" "$url"
rm --recursive --force "$tmpdir"
ln --symbolic --force --no-dereference "$src" "$dst"
```

Redirections (`>/dev/null`) and `command -v` are not flags. Leave them as-is.

## Plan persistence

When creating a development plan (multi-step feature, architecture decision,
refactoring strategy):

1. Save the plan to `.cursor/plans/<date>-<short-title>.md`
   (for example `2026-03-11-backfill-ui.md`).
2. Include goal, approach, steps with file paths, key decisions.
3. Update the plan when steps complete (checkboxes).
4. Look at existing plans in `.cursor/plans` before creating a new one for
   the same area.

Do not skip saving the plan even if it seems small.
