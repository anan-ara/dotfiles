# Instructions for Claude working in this repo

If `TODO.md` exists in this repo root, read it at the start of the session.
It's a local, untracked scratch list of pending work on this dotfiles setup -
treat it as live context on what the user is likely to ask about or want
help finishing, not as a queue to execute unprompted.

`TODO.md` is gitignored, so it won't exist on freshly cloned copies of this
repo (work Mac, headless server) until recreated locally.

## Documenting changes (README.md and code comments alike)

This applies both to README bullets and to inline code comments - match
the justification length to what the change actually is:

- A personal remap that still leaves the tool's own default learnable
  alongside it (clears criterion 3 of the keybinding bar in Philosophy)
  needs only "what it replaces and why" in one line - not a defense of
  why it's labeled a personal remap.
- Pure cosmetic/visual config (colors, glyphs, window styling) needs only
  "what changed" - no performance measurements or "here's why this is
  safe" reasoning unless something genuinely non-obvious is at stake.
- Save longer justification for remaps that actually give up the tool's
  default, or for genuinely non-obvious technical mechanics (e.g. a
  cross-shell syntax incompatibility).

## `.chezmoidata/packages.yaml`

Don't add comments explaining why a package is listed under a given app
(shared dependencies, what something is used for, etc.) - that dependency
mapping belongs in the README's Dependencies section instead, not inline
in this file. If a package's reason for being there isn't already covered
in the README, add it there rather than commenting the YAML.
