#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

# Diverges from the plain `chezmoi generate install.sh` output on purpose:
# that version curl-installs chezmoi straight to ~/.local/bin. Installing
# it through Homebrew instead means it's covered by the same `brew
# upgrade` that covers everything else in this repo, rather than needing
# its own separate update path. Regenerating this file would lose that.
if ! command -v brew >/dev/null 2>&1; then
	if [ "$(uname -s)" = "Darwin" ]; then
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	elif [ ! -d /home/linuxbrew/.linuxbrew ]; then
		echo "This will install Homebrew (Linuxbrew) to /home/linuxbrew/.linuxbrew,"
		echo "using sudo once, so chezmoi and this repo's other tools can be"
		echo "installed through it."
		printf "Proceed? [y/N] "
		read -r reply
		case "$reply" in
			[Yy]*)
				if command -v apt-get >/dev/null 2>&1; then
					sudo apt-get update
					sudo apt-get install -y build-essential procps curl file git
				elif command -v dnf >/dev/null 2>&1; then
					sudo dnf group install -y development-tools
					sudo dnf install -y procps-ng curl file git
				elif command -v pacman >/dev/null 2>&1; then
					sudo pacman -Sy --needed --noconfirm base-devel procps-ng curl file git
				else
					echo "Could not detect apt-get/dnf/pacman -- install Homebrew's" >&2
					echo "build prerequisites manually (see docs.brew.sh/Homebrew-on-Linux)" >&2
					echo "and re-run." >&2
					exit 1
				fi
				NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
				;;
		esac
	fi
fi

# Same prefix-detection dot_zsh/plugins.zsh uses -- Apple Silicon,
# Intel, then Linuxbrew's own standard prefix.
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
	eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v brew >/dev/null 2>&1; then
	command -v chezmoi >/dev/null 2>&1 || brew install chezmoi
	chezmoi="$(command -v chezmoi)"
else
	# Declined Linuxbrew (or brew genuinely unavailable) -- fall back to
	# chezmoi's own self-contained installer so this still works without
	# it.
	if ! chezmoi="$(command -v chezmoi)"; then
		bin_dir="${HOME}/.local/bin"
		chezmoi="${bin_dir}/chezmoi"
		echo "Installing chezmoi to '${chezmoi}'" >&2
		if command -v curl >/dev/null; then
			chezmoi_install_script="$(curl -fsSL https://get.chezmoi.io)"
		elif command -v wget >/dev/null; then
			chezmoi_install_script="$(wget -qO- https://get.chezmoi.io)"
		else
			echo "To install chezmoi, you must have curl or wget installed." >&2
			exit 1
		fi
		sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
		unset chezmoi_install_script bin_dir
	fi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

set -- init --apply --source="${script_dir}"

echo "Running 'chezmoi $*'" >&2
# exec: replace current process with chezmoi
exec "$chezmoi" "$@"
