# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/). Covers zsh,
git, vim/Neovim, Ghostty, herdr, Karabiner, lazygit, and yazi across a Mac (the
primary machine) and a headless Linux server you SSH into. Each app is
individually opt-in, chosen with a yes/no prompt per app at setup time - see
[Bootstrapping a new machine](#bootstrapping-a-new-machine).

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

Opting an app out entirely (see [Machine profiles](#repo-layout)) isn't a
departure from this philosophy - it's the most literal version of it: an
undeployed app is 100% stock, zero deviation. It does sharpen what "the SSH
test" (question 1, above) means in practice - it's no longer guaranteed the
full curated set is even present to fall back from, since a machine can now
deliberately have none of it applied at all.

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
no `sudo`) instead. You'll be prompted once for your git name/email, then once
per app (zsh, fish, git, vim, Neovim, lazygit, yazi, herdr, general CLI
tools, and - on darwin only - Ghostty and Karabiner) for whether to deploy
its config and install its packages. Answers are written to `~/.config/chezmoi/chezmoi.toml`,
outside this repo, so nothing personal ends up tracked in git, and re-running
`chezmoi apply` later never re-prompts.

Declining an app skips both its dotfiles (via `.chezmoiignore`) and its
packages (via `.chezmoidata/packages.yaml`) - see
[Machine profiles](#repo-layout) and [Dependencies](#dependencies).

On the Linux server, chezmoi's built-in `.chezmoi.os` detection still handles
one layer of this automatically: Ghostty and Karabiner are only ever offered
on darwin (Karabiner has no Linux build; Ghostty is darwin-only by policy
here) - no extra flag or prompt needed for that part.

If `~/.zshrc` already exists on the machine, `create_dot_zshrc`'s create-once
semantics leave it alone rather than overwrite it - but a separate script
(`run_onchange_after_ensure-zshrc-source.sh.tmpl`) appends `source
~/.zsh/base.zsh` to it automatically if that line isn't already there, so the
curated config still loads either way. This only runs at all if the `zsh` app
was selected; if you declined it, your existing `~/.zshrc` is left untouched.

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
├── .chezmoiignore              # per-app opt-out, see Machine profiles below
├── .chezmoi.toml.tmpl          # git name/email + per-app yes/no prompts
├── .chezmoidata/
│   ├── packages.yaml           # declared external tools, keyed by app, see Dependencies below
│   └── macos-defaults.yaml     # declared `defaults write` settings, see macOS defaults below
├── .chezmoiscripts/
│   ├── run_onchange_install-packages.sh.tmpl          # installs packages.yaml's list for selected apps
│   ├── run_once_configure-macos-defaults.sh.tmpl      # applies macos-defaults.yaml, darwin only
│   └── run_onchange_after_ensure-zshrc-source.sh.tmpl # wires up a pre-existing ~/.zshrc, if zsh selected
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
    ├── fish/                    # conf.d/ split: env, prompt, commands (secondary shell, not $SHELL)
    └── nvim/                    # LazyVim distro config
```

Anything listed in `.chezmoiignore` (`*.md` docs, `install.sh`) is inert -
chezmoi never writes it anywhere.

**Machine profiles.** Every app (zsh, fish, git, vim, Neovim, lazygit, yazi,
herdr, Ghostty, Karabiner, plus a packages-only `cli_tools` bucket for
`eza`/`bat`/`fzf`) gets its own yes/no prompt at `chezmoi init`,
persisted under `.apps.*` in `~/.config/chezmoi/chezmoi.toml`; declining one
makes `.chezmoiignore` skip its dotfiles and makes the package installer
skip its packages. `.chezmoi.os` (`"darwin"`/`"linux"`, auto-detected) still
sits underneath that as a hard constraint: Ghostty and Karabiner are only
ever *offered* on darwin (Karabiner has no Linux build; Ghostty is
darwin-only by this repo's policy, not a software limitation), so their
prompts don't even fire on Linux. Couplings worth knowing about: the Arc
browser cask rides along with `zsh`'s darwin package list (it has no
independent prompt, since its only use is `dot_zshenv.tmpl`'s `$BROWSER`);
`cli_tools` has no dotfile of its own - it's just a packages-only opt-in;
and `fish` defaults to **false** (every other app defaults true) since it's
a secondary shell you opt into deliberately, not a replacement for zsh.

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

*Only deployed/installed if `zsh` was selected at `chezmoi init`.*

Tab-completion opens an arrow-key-navigable, colorized menu (`menu-select`) and
is case-insensitive. Shift-Tab cycles backward through it, symmetric to Tab
cycling forward - unbound by default in stock zsh, so this is additive, not a
remap.

History is shared across all open sessions and deduplicated - both against
the immediately preceding command (`hist_ignore_dups`) and against any
earlier occurrence anywhere in history (`hist_ignore_all_dups`/
`hist_save_no_dups`), so re-running an old command doesn't leave a stale
duplicate sitting further back. Up/Down are prefix-aware: typing `git ` then
pressing Up only cycles through previous commands starting with `git `,
skipping unrelated ones in between - common in most curated zsh setups
(oh-my-zsh, prezto) but not a stock zsh default, so also additive (both key
variants some terminals send, `^[[A`/`^[OA` etc., are bound).

The prompt is [starship](https://starship.rs) (`dot_config/starship.toml`,
shared with fish below), not hand-coded: starship's own ["Pure
Prompt"](https://starship.rs/presets/pure-preset) preset (blue cwd, a
rebase/merge indicator, git status, venv, a colored arrow that turns red
on a nonzero exit status), with each module's `style` recolored to this
repo's palette instead of Pure's own colors - format strings, symbols, and
module behavior are otherwise unmodified Pure, except `directory`'s
`truncate_to_repo` is turned off so the path always shows its last 3
components instead of collapsing to just the repo name near a repo root.

A couple of extra commands live in `dot_zsh/commands.zsh`:

- `lg` - alias for `lazygit`.
- `h` - alias for `herdr`.
- `y` - wraps `yazi`; quitting it `cd`s your shell to wherever you navigated
  (unlike running `yazi` directly). Also bound to `Ctrl-o`.

These aliases are unconditional - if you keep `zsh` but decline `lazygit`,
`herdr`, or `yazi`, the corresponding alias/function stays defined but points
at a binary that isn't installed. It only breaks when you actually invoke it
(not at shell startup), so it's left as-is rather than templated per app.

`$LS_COLORS` is generated at shell startup with `vivid generate dracula`
(installed as part of the `zsh` app). On macOS, GNU coreutils taking priority
over the BSD ones on `$PATH` is instead gated by the `cli_tools` app - see
[CLI tools](#cli-tools-eza-bat-fzf) below.

`$EDITOR`/`$VISUAL` (set in `dot_zshenv.tmpl`) cascade with what's actually
selected: `nvim` if `neovim` is enabled, else `vim` if `vim` is enabled, else
the system `vi` - so they never point at a binary this repo didn't install.

`dot_zsh/fzf.zsh` (only takes effect if `fzf` is actually installed - the
`cli_tools` app - otherwise zsh's own Ctrl-T/Ctrl-R are untouched):

- **Ctrl-T** is fzf's official ["dedicated completion key
  binding"](https://github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion)
  pattern - the same context-aware fuzzy completion `**<Tab>` normally
  triggers (ssh hosts, PIDs, env vars, generic path completion, etc.),
  invoked directly instead of needing the `**` trigger typed first. Tab
  itself is restored to plain zsh completion right after, so nothing about
  Tab changes. Path/dir completion is backed by `fd` (`cli_tools`'s other
  reason for depending on it) for a faster, full-`.gitignore`-aware walk
  instead of the default `find`-based one. Doesn't shadow anything (zsh's
  own Ctrl-T default is `transpose-chars`), so this is additive, not a
  personal remap.
- **PERSONAL REMAP**: Ctrl-R is fzf's fuzzy, full-history search widget
  instead of zsh's own substring-anchored incremental search. Alt-C (fzf's
  cd widget) is suppressed, since it wasn't asked for.
- **Window styling** (cosmetic, `$FZF_DEFAULT_OPTS`): reverse layout, 80%
  height, inline match counter, multi-select on, a custom `❯` prompt
  glyph, Dracula colors. A preview pane (`bat` for files, `eza --tree` for
  directories) is bound too, hidden by default and toggled with `?`.
  Ctrl-R gets its own bordered `History` label via `$FZF_CTRL_R_OPTS`.

### fish

*Only deployed/installed if `fish` was selected at `chezmoi init` - defaults
to off.*

A secondary shell, not a replacement for zsh: nothing here changes `$SHELL`
or how Ghostty/herdr/SSH launch a shell, so this is purely "available to run
manually when you want it." Config lives under `dot_config/fish/conf.d/`,
auto-sourced by fish itself in alphabetical order (`00-env`, `10-prompt`,
`15-fzf`, `20-commands`) - no orchestrator file needed the way zsh's
`base.zsh` sources its pieces explicitly.

It's a smaller config than zsh's for the same result, since fish natively
does several things zsh needs a plugin or `setopt` for: autosuggestions,
syntax highlighting, a colorized case-insensitive completion menu, and
shared/deduplicated history all come for free. What's actually ported:
Homebrew/coreutils/`~/.local/bin` on `$PATH` (same paths as zsh, same
priority over the BSD system paths - relative order between coreutils and
plain brew binaries can differ slightly since `brew shellenv fish` always
claims the front, but there's no name collision between them so nothing
actually resolves differently), `$LS_COLORS` via `vivid`, the
`$XDG_CONFIG_HOME`/`$EDITOR`/`$VISUAL`/
`$BROWSER` env vars from `dot_zshenv.tmpl`. The prompt is the same starship
config as zsh's, above (`dot_config/starship.toml`). The `lg`/`h`/`y`
aliases from the zsh section above are also ported here and are just as
unconditional - the same "stays defined but points at a missing binary if
you decline its app" caveat applies.

`dot_config/fish/conf.d/15-fzf.fish` (same `cli_tools`-gated fallback to
fish's own Ctrl-T/Ctrl-R if `fzf` isn't installed):

- **Ctrl-T** is the fish equivalent of the same dedicated-completion-key
  idea as the zsh section above - rebound from fzf's plain file-picker
  widget to `fzf_complete`, the same context-aware completion Shift-Tab
  normally triggers (falls back to fish's own native `complete -C`
  completion for anything without a per-command handler). Shift-Tab is
  unbound afterward to consolidate onto the one dedicated key - fish ships
  no default Shift-Tab binding of its own, so nothing is lost. Unlike the
  zsh side, there's no `fd`-backed override here: `fzf_complete`'s main
  path defers entirely to fish's own native completion engine rather than
  shelling out to `find`/`fd`, so there's no equivalent hook to point at
  `fd`. Doesn't shadow anything (fish has no default Ctrl-T binding
  either), so this is additive, not a personal remap.
- **PERSONAL REMAP**: same Ctrl-R fuzzy-history remap as the zsh section
  above. Alt-C is suppressed too.
- **Window styling**: same as the zsh section above, except the preview
  command has to be written in real fish syntax (`if`/`else if`/`end`)
  rather than the zsh side's `[[ ]] && (...) || (...)` one-liner - fzf's
  fish integration runs `--preview` through fish itself, where `(...)`
  means command substitution, not subshell grouping, so the zsh one-liner
  is invalid syntax here.

### git

*Only deployed/installed if `git` was selected at `chezmoi init`.*

`~/.gitconfig` is templated (`dot_gitconfig.tmpl`) from the name/email given at
`chezmoi init`. `core.excludesfile` points at `~/.gitignore_global`, which you
bring yourself; it isn't tracked in this repo. Diffs (`git diff`/`log -p`/`add
-p`) render through `delta`, which is also installed alongside `lazygit` if
you select that app instead (or as well).

### vim (`dot_vimrc`)

*Only deployed if `vim` was selected at `chezmoi init`.*

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

*Only deployed/installed if `neovim` was selected at `chezmoi init`.*

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

*Only deployed/installed if `ghostty` was selected at `chezmoi init` (only
offered on darwin - see [Machine profiles](#repo-layout)).*

Dracula theme, Hack Nerd Font, hidden titlebar. `Cmd`+key sends herdr's prefix
(`Ctrl-b`) followed by that key, so herdr can be driven without pressing the
prefix first:

- `Cmd-h/j/k/l` - move between panes
- `Cmd-d` / `Cmd-shift-d` - split
- `Cmd-t` / `Cmd-w` - new tab / close tab
- `Cmd-[1-9]` - jump to tab N
- `Cmd-\` - jump to last pane

`Cmd-opt-w` is the one exception - a native Ghostty `close_window` action,
not a herdr passthrough, bound in place of Ghostty's own default for that
combo (`close_tab`, redundant with `Cmd-w` above). It closes only the
current Ghostty window, leaving any other open Ghostty windows alone
(unlike `Cmd-q`, which quits the whole app).

### herdr

*Only deployed/installed if `herdr` was selected at `chezmoi init`.*

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

*Only deployed/installed if `karabiner` was selected at `chezmoi init` (only
offered on darwin - Karabiner has no Linux build, see
[Machine profiles](#repo-layout)).*

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

*Only deployed/installed if `lazygit` was selected at `chezmoi init`.*

Launch with the `lg` alias. Diffs render through `delta` instead of lazygit's
plain built-in pager - `git-delta` installs alongside `lazygit` even if the
`git` app itself is declined, since lazygit needs it independently.

### yazi

*Only deployed/installed if `yazi` was selected at `chezmoi init`.*

Launch with the `y` shell function (or `Ctrl-o`) rather than the bare `yazi`
binary, so quitting it changes your shell's directory to wherever you
navigated.

### CLI tools (`eza`, `bat`, `fzf`)

*Installed only if `cli_tools` was selected at `chezmoi init`.*

General-purpose interactive-shell upgrades. `fzf` has no dedicated config
of its own; `bat` (`dot_config/bat/config`) and `eza`
(`dot_config/eza/theme.yml`) are themed to Dracula to match the rest of the
setup. On darwin, GNU `coreutils` installs alongside them so the GNU
versions of standard utilities take priority over BSD's on `$PATH` (see the
zsh section above).

`zoxide` is commented out in `.chezmoidata/packages.yaml` (TODO) - not
currently used, and its shell init was never wired up either way.

## Changing the colorscheme

Everything here is themed to Dracula, but there's no single source of truth for
it - each tool has its own config and its own way of naming or approximating
the theme. Switching to a different colorscheme means editing all of these:

- **Ghostty** - `dot_config/ghostty/config`: `theme = Dracula` (any
  Ghostty-bundled theme name works; `ghostty +list-themes` lists them).
- **`$LS_COLORS`** - `dot_zsh/base.zsh` (zsh) and
  `dot_config/fish/conf.d/00-env.fish.tmpl` (fish): change the theme name
  passed to `vivid generate <theme>` in both (any name from `vivid themes`)
  - generated fresh at every shell startup, nothing to paste back in.
- **Neovim** - `dot_config/nvim/lua/plugins/colorscheme.lua`: swap the
  `Mofiqul/dracula.nvim` plugin spec for a different colorscheme plugin, and
  update LazyVim's `opts.colorscheme` to match.
- **herdr** - `dot_config/herdr/config.toml`: `theme.name` (one of herdr's
  built-in themes - `catppuccin`, `terminal`, `tokyo-night`, `dracula`,
  `nord`, `gruvbox`, `one-dark`, `solarized`, `kanagawa`, `rose-pine`,
  `vesper`; run `herdr --default-config` to see the current list).
- **lazygit** - `dot_config/lazygit/config.yml`: the `gui.theme` block
  (official values from draculatheme.com/lazygit).
- **bat** - `dot_config/bat/config`: the `--theme` line (any theme from
  `bat --list-themes`).
- **eza** - `dot_config/eza/theme.yml`: swap in a different theme's YAML
  (official values from draculatheme.com/eza; more at
  github.com/eza-community/eza-themes).
- **starship** (zsh's and fish's prompt) - `dot_config/starship.toml`: based
  on the "Pure Prompt" preset, but each module's `style`/color is
  overridden individually to match the palette used elsewhere - update
  those to match a different theme by hand.
- **fzf**'s Ctrl-R widget - `$FZF_DEFAULT_OPTS` in `dot_zsh/fzf.zsh` (zsh)
  and `dot_config/fish/conf.d/15-fzf.fish` (fish): the `--color` list
  (official values from draculatheme.com/fzf) - keep both in sync if you
  change it.

One thing that doesn't need touching: **plain vim** has no Dracula-specific
config of its own - it just inherits whatever ANSI palette the terminal
(Ghostty) is currently providing, so it follows automatically whenever
Ghostty's `theme` changes.

## Dependencies

External tools are declared in `.chezmoidata/packages.yaml`, keyed by app, and
actually installed by `.chezmoiscripts/run_onchange_install-packages.sh.tmpl`
as part of `chezmoi apply` - it only re-runs when the package list itself
changes, not on every apply. Consent happens once, per app, at `chezmoi init`
(see [Bootstrapping a new machine](#bootstrapping-a-new-machine)); a selected
app's packages then install without any further per-package prompt. A package
needed by more than one app (`git-delta` for `git`/`lazygit`, `vivid` and
`starship` for `zsh`/`fish`, `fd` for `neovim`/`cli_tools` - the latter also
backs fzf's Ctrl-T path completion) is deduplicated automatically, so
selecting both doesn't install it twice.

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
on linux) - unrelated to the per-app selection above, so it keeps its own
per-item interactive prompt (enter/y, n, a=accept the rest, q=skip the rest).

- Natural trackpad scroll direction off
- No auto-rearranging Spaces
- Fast key repeat with no press-and-hold accent popup
- Finder hidden files/extensions/path+status bar
- Dock autohide
- Screenshots saved to `~/Screenshots`
- Hidden desktop icons.
