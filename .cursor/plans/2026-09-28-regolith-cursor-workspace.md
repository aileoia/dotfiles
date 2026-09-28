# Cursor workspace setup

## Goal

Start Cursor when Regolith logs in, place its window on workspace 2, and label
that workspace `2: Cursor`.

## Approach

Use Regolith's existing workspace Xresource and i3 app-workspace partial so the
workspace name, assignment, and startup behavior remain declarative and
portable.

## Key decisions

- Keep the numeric `2:` prefix so Regolith's numbered workspace navigation
  continues to work.
- Match Cursor's X11 window class case-insensitively.
- Use i3 `exec` so Cursor starts once per login, not on every config reload.

## Steps

- [x] Name workspace 2 in `config/regolith3/Xresources`
- [x] Assign and launch Cursor in
      `config/regolith3/i3/config.d/90_app-workspaces`
- [x] Validate the Regolith configuration
