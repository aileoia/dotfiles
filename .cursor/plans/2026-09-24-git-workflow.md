# Git commit cadence plus ff-only master merge

## Goal

Agents commit after every logical change with small subjects. Topic branches
land on master by fast-forward only.

## Approach

Always-on Cursor rules, AGENTS.md, plus `merge-to-master.sh`.

## Steps

- [x] Add `.cursor/rules/git-commits.mdc`
- [x] Add `.cursor/rules/git-merge-master.mdc`
- [x] Add `merge-to-master.sh`
- [x] Update `AGENTS.md`

## Key decisions

- Amend unpushed HEAD for the same change only.
- No `;` or the word `and` in commit subjects or bodies.
- Rebase the topic onto master when fast-forward is not possible.
