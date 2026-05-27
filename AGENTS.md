# Repository Structure

This repository (`/home/user/Projects/.dotfiles`) is symlinked as `$HOME/.dotfiles` and is the **source of truth** for the home directory.

## How it works

- The directory layout in this repo maps 1:1 to `$HOME`.
- After editing this repo, run `.local/bin/stowhome` (or its symlink at `~/.local/bin/stowhome`) to apply changes via GNU stow.
- The `stowhome` script syncs this repo's contents to `$HOME`, excluding `.git`, `.dotfiles`, `LICENSE`, `README.md`, and `TODO.md`.
- It also ensures directories like `.config/fontconfig` exist under `$HOME` before stowing.

## Path handling

When the user references paths like `~/some/path`, `.dotfiles/some/path`, or asks to edit files "in the home directory", they almost always mean **this repository** — not the actual `$HOME`. Apply changes here first, then run `stowhome`.

Only ever modify the real `$HOME` directory if the user explicitly and deliberately confirms that's what they want.

## Workflow

1. Edit files in this repository.
2. Run `stowhome` to apply changes to `$HOME`.

## General program configuration

When the user wants to add or modify configurations for a program, always search for the latest information about that program first. Before making changes, determine:

1. **Config location** — Where is the config stored? User-level vs system-level.
2. **Auto-reload** — Does the program auto-reload on file change? Does it need a command (`kill -SIGUSR1`, `hyprctl reload`, etc.) or a full restart?
3. **Config verification** — Is there a command provided by the program to verify/check the config's correctness (e.g. `niri validate`, `fc-cache`, ` hyprctl reload`)?

Document findings for the specific program in the relevant section below.

## Fontconfig

- **Config location:** `~/.config/fontconfig/fonts.conf` (per-user)
- **Auto-reload:** No — restart the application to see changes. `fc-cache` rebuilds font metadata (needed only when adding/removing font files, not when changing rendering settings).
- **Verify config:** No built-in validator. XML syntax errors are silently ignored (fontconfig falls back to defaults). Use `fc-match <pattern>` to test font matching.

## Hyprland

When the user asks for changes to Hyprland config, Hyprland-related tools, or anything in the Hypr ecosystem, always search for the latest information first. Hyprland has recently moved to a `.lua`-based configuration file (instead of the older `.conf` style). Before making any modifications, check [https://wiki.hypr.land/](https://wiki.hypr.land/) to ensure you have the most current data.
