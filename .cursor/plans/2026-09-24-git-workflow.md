# Git commit cadence plus ff-only master merge

## Goal

Agents commit after every logical change with small subjects. Topic branches
land on master by fast-forward only.

## Approach

All of this lives in `AGENTS.md`. No Cursor `.mdc` files. No merge script.

## Steps

- [x] Put commit, merge, shell, plan rules in `AGENTS.md`
- [x] Remove `.cursor/rules/*.mdc`
- [x] Remove `merge-to-master.sh`

## Key decisions

- Amend unpushed HEAD for the same change only.
- No `;` or the word `and` in commit subjects or bodies.
- Rebase the topic onto master when fast-forward is not possible.
- Fast-forward is a documented git sequence, not a bash wrapper.
