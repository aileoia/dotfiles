# Regolith configuration modernization

## Goal

Keep the Regolith configuration portable and focused on user preferences so
packaged defaults can evolve safely during future upgrades.

## Approach

Move the one intentional window-style override to the current `wm.*`
Xresources namespace, use portable wallpaper paths, and replace the copied
packaged style partial with a small app-to-workspace partial.

## Key decisions

- Rely on Regolith's packaged border, popup, and edge-border defaults.
- Use workspace variables in assignments so renamed workspaces stay aligned.
- Use Regolith's default screen-lock integration instead of overriding it with
  a direct `i3lock` command.
- Keep the application class matches exact to preserve current behavior.

## Steps

- [x] Modernize `config/regolith3/Xresources`
- [x] Replace `config/regolith3/i3/config.d/40_default-style` with
      `config/regolith3/i3/config.d/90_app-workspaces`
- [x] Update the Regolith partial link in `install.conf.yaml`
- [x] Validate the complete Regolith i3 configuration
