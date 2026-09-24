#!/usr/bin/env bash
# Fast-forward master to the current topic branch. Does not push.
#
# Usage (from a clean topic branch):
#   bash merge-to-master.sh

set -o errexit -o nounset -o pipefail

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

topic=$(git branch --show-current)
if [ -z "${topic}" ]; then
  die "detached HEAD"
fi
if [ "${topic}" = "master" ]; then
  die "already on master"
fi

if [ -n "$(git status --porcelain)" ]; then
  die "working tree not clean"
fi

git fetch origin

if ! git merge-base --is-ancestor master "${topic}"; then
  die "master is not an ancestor of ${topic}; rebase onto master first"
fi

if git rev-parse --verify --quiet origin/master >/dev/null; then
  if ! git merge-base --is-ancestor origin/master "${topic}"; then
    die "origin/master is not an ancestor of ${topic}; rebase onto origin/master first"
  fi
fi

git switch master
git merge --ff-only "${topic}"

printf 'fast-forwarded master to %s\n' "${topic}"
printf 'push when ready: git push origin master\n'
