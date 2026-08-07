# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/). Covers zsh,
git, vim/Neovim, Ghostty, herdr, Karabiner, lazygit, and yazi across a Mac (the
primary machine) and a headless Linux server you SSH into.

## Contents

- [Philosophy](#philosophy)
- [Bootstrapping a new machine](#bootstrapping-a-new-machine)
- [Repo layout](#repo-layout)
- [Day-to-day workflow](#day-to-day-workflow)
- [Tools](#tools)
- [Changing the colorscheme](#changing-the-colorscheme)
- [Dependencies](#dependencies)
- [macOS defaults](#macos-defaults)

## Philosophy

**Stay as close to each program's default, out-of-the-box behavior as
possible.** Any deviation needs a real, concrete justification - a cost it
avoids or a capability it adds that the defaults don't.  This matters because
there are many situations where having the defaults is highly beneficial, such
as SSH'd into a bare server, pair-programming on a colleague's laptop, or
someone driving my machine to show me something. Every piece of
default-breaking customization is a tax paid in exactly those moments.

Concretely, this rules out:

- Config that changes a program's fundamental behavior without a specific,
  stated reason tied to real friction the default causes.
- Aliases that make an existing command behave differently than everywhere else
  (shadowing `rm`, `cp`, `mv`, etc.). An alias that adds a genuinely new
  command is fine; one that changes what a familiar command does when typed
  normally is not.

**Keybindings** get a slightly different bar. A remap is fine if it clears
*all* of the following:

1. It fixes a genuine inconsistency in the tool's own defaults - not just a
   preference (e.g. vim's `Y` acting on the whole line while `D`/`C` act to
   end-of-line).
2. It's a widely-known convention among experienced users of that tool - the
   kind of thing that shows up unprompted across independent "essential config"
   write-ups, not something invented here.
3. The tool's real default is still learnable if this config disappears.

Anything that doesn't clear all three is a personal, idiosyncratic remap -
still allowed, but held to a stricter "real, stated justification" bar,
expected to stay rare, and kept visibly separate (a `PERSONAL REMAPS` section
of its own). Such cases should be explicitly labeled throughout this repo.

What's always fine, regardless of the above:

- **Pure visual/cosmetic config** - color schemes, prompt themes, syntax
  highlighting - since it doesn't change how anything behaves.
- **Genuinely additive tooling** - new commands or keybindings under names that
  don't already mean something (`lg` for lazygit, `:W` as a sudo-save command),
  opt-in enhancements that don't fire unless explicitly invoked.
- **Config with a specific, real, non-keybinding justification** - a
  compatibility fix for a genuinely broken default, a documented performance
  reason.

**The test**, applied to everything in this repo:

1. If I SSH into a bare server with none of this applied, can I still be
   productive using each tool's stock behavior?
2. If someone else sits down at my machine, do they hit something that makes
   sense once they see it (or nothing at all), rather than something that
   actively confuses them?

If either answer is no, the config needs to get cut.

## Bootstrapping a new machine

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` installs chezmoi itself if it isn't already on `$PATH`, then runs
`chezmoi init --apply` against this directory. Chezmoi is installed through
Homebrew (installed first if missing) rather than its own standalone
installer, so it's covered by the same `brew upgrade` that covers everything
else. On Linux, installing Homebrew needs `sudo` once, so `install.sh` asks
for confirmation first, same as the package installer below - decline it and
chezmoi falls back to its own self-contained installer (`~/.local/bin`,
no `sudo`) instead. You'll be prompted once for your git name/email. Answers
are written to `~/.config/chezmoi/chezmoi.toml`, outside this repo, so
nothing personal ends up tracked in git.

On the Linux server, chezmoi's built-in `.chezmoi.os` detection handles the
profile split automatically (see [Repo layout](#repo-layout)) - no extra flag
or prompt needed.

If `~/.zshrc` already exists on the machine, `create_dot_zshrc`'s create-once
semantics leave it alone rather than overwrite it - but a separate script
(`run_onchange_after_ensure-zshrc-source.sh`) appends `source
~/.zsh/base.zsh` to it automatically if that line isn't already there, so the
curated config still loads either way.

The tools each config assumes are present install automatically as part of
`chezmoi apply` - see [Dependencies](#dependencies) (on Linux, this prompts
before installing anything). On darwin, a separate script also offers to
apply a handful of system defaults - see [macOS defaults](#macos-defaults).

## Repo layout

This repo is a **chezmoi source directory**. chezmoi mirrors it onto `$HOME` as
one tree; a file's name encodes where it ends up:

| Prefix/suffix           | Meaning                                                      |
| ------------------------ | ------------------------------------------------------------ |
| `dot_`                   | becomes a leading `.` in the target path (`dot_vimrc` → `~/.vimrc`) |
| `create_`                | only written if the target doesn't already exist             |
| `run_onchange_`          | a script, re-run only when its rendered content changes      |
| `run_once_`               | a script, run once ever per machine                          |
| `.tmpl`                  | rendered as a Go template before being written                |
| (root file, no prefix)   | placed literally at `$HOME/<name>` (rare, a few loose files)  |

```
~/dotfiles/
├── .chezmoiignore              # profile split logic (darwin vs linux), see below
├── .chezmoi.toml.tmpl          # prompts that seed local, uncommitted machine data
├── .chezmoidata/
│   ├── packages.yaml           # declared external tools, see Dependencies below
│   └── macos-defaults.yaml     # declared `defaults write` settings, see macOS defaults below
├── .chezmoiscripts/
│   ├── run_onchange_install-packages.sh.tmpl        # installs packages.yaml's list
│   ├── run_once_configure-macos-defaults.sh.tmpl    # applies macos-defaults.yaml, darwin only
│   └── run_onchange_after_ensure-zshrc-source.sh    # wires up a pre-existing ~/.zshrc
├── install.sh                  # bootstrap wrapper, see above
├── create_dot_zshrc            → ~/.zshrc   (create-once; sources dot_zsh/base.zsh)
├── dot_zshenv.tmpl             → ~/.zshenv
├── dot_gitconfig.tmpl          → ~/.gitconfig   (templated: name/email)
├── dot_vimrc                   → ~/.vimrc
├── dot_zsh/                    → ~/.zsh/     (base.zsh + prompt/completion/options/plugins/commands.zsh)
└── dot_config/                  → ~/.config/
    ├── karabiner.edn            # darwin-only
    ├── ghostty/                 # darwin-only
    ├── herdr/
    ├── lazygit/
    ├── yazi/
    └── nvim/                    # LazyVim distro config
```

Anything listed in `.chezmoiignore` (`*.md` docs, `install.sh`) is inert -
chezmoi never writes it anywhere.

**Machine profiles.** There's no custom "machine type" prompt; chezmoi's
built-in `.chezmoi.os` variable (`"darwin"` on the Mac, `"linux"` on the
server) drives `.chezmoiignore` directly, currently gating `karabiner.edn` and
the Ghostty config to darwin only. Everything else applies to both profiles.

## Day-to-day workflow

Editing a file under `~/dotfiles/` isn't instantly live - chezmoi needs to
apply it:

```sh
chezmoi edit ~/.zshrc      # opens the SOURCE file in $EDITOR
chezmoi diff               # preview what would change on disk
chezmoi apply              # write it for real
```

Or edit the deployed file directly and pull the change back into source state
with `chezmoi re-add ~/.zshrc`. Either way, commit/push from `~/dotfiles` like
a normal repo once you're happy.

**Adding a new dotfile:**

```sh
chezmoi add ~/.config/some-new-tool/config.toml
```

This copies it into the source dir with the right naming convention applied;
move it under `dot_config/` by hand if you want it grouped with everything
else.

## Tools

### zsh

Tab-completion opens an arrow-key-navigable, colorized menu (`menu-select`) and
is case-insensitive. History is shared across all open sessions and
deduplicated.

A couple of extra commands live in `dot_zsh/commands.zsh`:

- `lg` - alias for `lazygit`.
- `y` - wraps `yazi`; quitting it `cd`s your shell to wherever you navigated
  (unlike running `yazi` directly). Also bound to `Ctrl-o`.

`$LS_COLORS` is generated at shell startup with `vivid generate dracula`, and
on macOS, GNU coreutils take priority over the BSD ones on `$PATH`.

### git

`~/.gitconfig` is templated (`dot_gitconfig.tmpl`) from the name/email given at
`chezmoi init`. `core.excludesfile` points at `~/.gitignore_global`, which you
bring yourself; it isn't tracked in this repo. Diffs (`git diff`/`log -p`/`add
-p`) render through `delta`.

### vim (`dot_vimrc`)

Deliberately minimal and plugin-free - this is for a quick edit or an
unfamiliar machine you've SSH'd into, not full-time editing (that's Neovim's
job, below).

Standard, convention-backed remaps: `Y` acts like `y$`; `j`/`k` respect wrapped
lines; `Ctrl-h/j/k/l` move between splits; `n`/`N`/`Ctrl-d`/`Ctrl-u` keep the
match centered; `<`/`>` reselect the block afterward; `Esc` clears search
highlighting; `:W` saves a root-owned file via `sudo tee` without leaving vim.

Personal remaps: `Tab` jumps to the matching bracket (`%`); `Ctrl-\` switches
to the last buffer.

### Neovim (LazyVim)

Runs the stock [LazyVim](https://www.lazyvim.org/) distribution with the
Dracula colorscheme - manage it the same way you would any LazyVim install
(`:Lazy`, `:LazyExtras`, `:checkhealth`). No language servers are
pre-installed; add extras (`clangd`, `pyright`, etc.) via the `spec` table in
`lua/config/lazy.lua` as needed.

**Adding language support:** `mason.nvim` (bundled with LazyVim) is the
mechanism that installs LSP servers/formatters/linters, but it doesn't
decide what to install for which filetype on its own - that's what a
LazyVim extra does. Enable one per language with a line in
`lua/config/lazy.lua`'s `spec` table:
```lua
{ import = "lazyvim.plugins.extras.lang.clangd" },
{ import = "lazyvim.plugins.extras.lang.python" },
```
Confirm the exact extra name via `:LazyExtras` rather than assuming.
Each extra usually bundles more than bare LSP (e.g. the Python one adds
`nvim-dap-python` and a virtualenv picker, the Rust one swaps in
`rustaceanvim`). Mason then auto-installs the actual server the first
time you open a matching file - nothing to provision ahead of time.
This only covers editor tooling (diagnostics/completion/formatting);
actually running or debugging code still needs that language's own
runtime on `$PATH` (a version manager, if you want one, is out of scope
for this repo).

On top of LazyVim's own defaults, `lua/config/keymaps.lua` adds only what
LazyVim doesn't already provide: the same centered-search/`Ctrl-\`/`Tab`/`:W`
remaps as `dot_vimrc`, kept in sync so muscle memory transfers between the two.

### Ghostty (darwin only)

Dracula theme, Hack Nerd Font, hidden titlebar. `Cmd`+key sends herdr's prefix
(`Ctrl-b`) followed by that key, so herdr can be driven without pressing the
prefix first:

- `Cmd-h/j/k/l` - move between panes
- `Cmd-d` / `Cmd-shift-d` - split
- `Cmd-t` / `Cmd-w` - new tab / close tab
- `Cmd-[1-9]` - jump to tab N
- `Cmd-\` - jump to last pane

### herdr

Replaces tmux. `dot_config/herdr/config.toml` adds a handful of
tmux-compatible keybindings alongside herdr's own defaults, rather than
replacing them - both work:

- `prefix+d` - detach (herdr's own default is `prefix+q`)
- `prefix+;` - jump to last pane (herdr's own default is unbound; `prefix+\`
  also still works, mirrored by Ghostty's `Cmd-\` above)
- `prefix+%` / `prefix+"` - split vertical/horizontal (herdr's own defaults,
  `prefix+v` / `prefix+minus`, still work too)

Everything else is herdr's own defaults, driven with its `Ctrl-b` prefix
directly or the Ghostty shortcuts above. Theme is herdr's built-in `dracula`.

### Karabiner (`dot_config/karabiner.edn`, darwin only)

Written in [goku](https://github.com/yqrashawn/GokuRakuJoudo)'s edn DSL, not
raw Karabiner JSON. `goku` needs to be running to watch the file and recompile
`karabiner.json`; `goku -d` dry-runs a compile without writing anything, useful
for checking a change before it takes effect.

- **Caps Lock** - tap: Escape, hold: Control.
- **Left/Right Shift** - tap: `(` / `)`.
- **Left Command** - tap: `_`.
- **Right Command** - tap: Delete Forward, hold: Meh (Ctrl+Option+Shift).
- **Mouse side buttons** - hold: Meh.
- **Holding Tab** activates a nav layer: `h`/`j`/`k`/`l` for arrows, `y`/`o`
  for Home/End, `u`/`i` for Option+arrow (word jump), `m`/`,` for Page Down/Up,
  and `e` acts as Shift *within the layer* - e.g. `e`+`u` selects a word to the
  left.
- **Holding backtick** activates a numpad layer: `u`/`i`/`o` / `j`/`k`/`l` /
  `m`/`,`/`.` for 7-9/4-6/1-3, spacebar for `0`, and `3` acts as Shift *within
  the layer* - e.g. `3`+`u` sends `&` (Shift+7).

### lazygit

Launch with the `lg` alias. Diffs render through `delta` instead of lazygit's
plain built-in pager.

### yazi

Launch with the `y` shell function (or `Ctrl-o`) rather than the bare `yazi`
binary, so quitting it changes your shell's directory to wherever you
navigated.

## Changing the colorscheme

Everything here is themed to Dracula, but there's no single source of truth for
it - each tool has its own config and its own way of naming or approximating
the theme. Switching to a different colorscheme means editing all of these:

- **Ghostty** - `dot_config/ghostty/config`: `theme = Dracula` (any
  Ghostty-bundled theme name works; `ghostty +list-themes` lists them).
- **zsh `$LS_COLORS`** - `dot_zsh/base.zsh`: change the theme name passed to
  `vivid generate <theme>` (any name from `vivid themes`) - generated fresh
  at every shell startup, nothing to paste back in.
- **Neovim** - `dot_config/nvim/lua/plugins/colorscheme.lua`: swap the
  `Mofiqul/dracula.nvim` plugin spec for a different colorscheme plugin, and
  update LazyVim's `opts.colorscheme` to match.
- **herdr** - `dot_config/herdr/config.toml`: `theme.name` (one of herdr's
  built-in themes - `catppuccin`, `terminal`, `tokyo-night`, `dracula`,
  `nord`, `gruvbox`, `one-dark`, `solarized`, `kanagawa`, `rose-pine`,
  `vesper`; run `herdr --default-config` to see the current list).
- **lazygit** - `dot_config/lazygit/config.yml`: the `gui.theme` block
  (official values from draculatheme.com/lazygit).

One thing that doesn't need touching: **plain vim** has no Dracula-specific
config of its own - it just inherits whatever ANSI palette the terminal
(Ghostty) is currently providing, so it follows automatically whenever
Ghostty's `theme` changes.

## Dependencies

External tools are declared in `.chezmoidata/packages.yaml` and actually
installed by `.chezmoiscripts/run_onchange_install-packages.sh.tmpl` as part of
`chezmoi apply` - it only re-runs when the package list itself changes, not on
every apply. It prompts once per package (`git add -p`-style: enter/y, n,
a=accept the rest, q=skip the rest).

Both platforms install everything through Homebrew:

- **darwin** - Homebrew is the norm here; installed automatically (along with
  Xcode Command Line Tools) with no prompting.
- **linux** - Homebrew (Linuxbrew) is genuinely the only mechanism here that
  reliably covers every tool on the list (some, like `herdr`, aren't packaged
  by any mainstream distro at all), but installing it means creating
  `/home/linuxbrew/.linuxbrew` with `sudo`, which isn't something to do
  silently - especially on a server you use but don't own. So the script
  **asks for confirmation first**. If declined, it installs nothing and
  instead prints a found/missing report of what's already on `$PATH`, leaving
  it to you to handle the rest however makes sense for that machine. (If you
  went through `install.sh`, this is the same question it already asked to
  install chezmoi itself - answering it there covers this script too.)

## macOS defaults

`.chezmoidata/macos-defaults.yaml` declares a short list of `defaults write`
system settings, applied once per machine by
`.chezmoiscripts/run_once_configure-macos-defaults.sh.tmpl` (darwin only, no-op
on linux) - same per-item interactive prompt as the package installer above.

- Natural trackpad scroll direction off
- No auto-rearranging Spaces
- Fast key repeat with no press-and-hold accent popup
- Finder hidden files/extensions/path+status bar
- Dock autohide
- Screenshots saved to `~/Screenshots`
- Hidden desktop icons.
