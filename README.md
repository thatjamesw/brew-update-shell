brew-refresh

Small, safe Homebrew maintenance script for macOS.
It updates Homebrew, upgrades formulae and casks, removes unused dependencies, cleans cached/old versions, and runs a quick health check.

Features

Updates Homebrew taps

Upgrades formulae (and casks, optionally with --greedy)

Removes orphaned dependencies (brew autoremove)

Cleans caches and old versions (brew cleanup)

Runs brew doctor (non-fatal)

Prerequisites

macOS with Homebrew installed

Bash or Zsh

Install
# Make the script executable
chmod +x brew-refresh.sh


Optional: add to your PATH for easy reuse.

mkdir -p ~/bin
cp brew-refresh.sh ~/bin/
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
exec zsh -l


If you see “command not found: brew”, add Homebrew to your shell:

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"

Usage
./brew-refresh.sh [--dry-run] [--no-cask] [--prune-all] [--greedy]

Options

--dry-run
Show what would be cleaned; do not delete anything.

--no-cask
Skip upgrading casks (apps).

--prune-all
Aggressive clean: remove all old downloads/versions and prune caches.

--greedy
Upgrade casks that normally auto-update themselves.

Examples
# Standard update, upgrade, clean
./brew-refresh.sh

# Preview cleanup without deleting anything
./brew-refresh.sh --dry-run

# Aggressive clean and include auto-updating apps
./brew-refresh.sh --prune-all --greedy

# Only update & upgrade formulae (no apps)
./brew-refresh.sh --no-cask

Troubleshooting

“Unknown option:” with a blank value
Ensure you’re using the latest script (argument parsing fixed). Also confirm Unix line endings:

sed -i '' $'s/\r$//' brew-refresh.sh


“Homebrew not found”
Install Homebrew or ensure it’s on your PATH (Apple Silicon example):

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"

Uninstall
rm -f brew-refresh.sh

Licence

MIT Licence. Contributions welcome via pull request.
