#!/usr/bin/env bash
set -Eeuo pipefail

# Locate brew (Apple Silicon & Intel) and load its env
ensure_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    else
      echo "Homebrew not found. Install it first: https://brew.sh" >&2
      exit 1
    fi
  fi
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [--dry-run] [--no-cask] [--prune-all] [--greedy]

  --dry-run    : Show what would be cleaned, don't perform cleanup.
  --no-cask    : Skip cask upgrades.
  --prune-all  : Aggressive cleanup (remove all old downloads/versions).
  --greedy     : For casks, upgrade even apps that auto-update themselves.
EOF
}

DRY_RUN=false
NO_CASK=false
PRUNE_ALL=false
GREEDY=false

# FIXED: iterate over actual args only
for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=true ;;
    --no-cask)   NO_CASK=true ;;
    --prune-all) PRUNE_ALL=true ;;
    --greedy)    GREEDY=true ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage; exit 2 ;;
  esac
done

ensure_brew

echo "==> brew update"
brew update

echo "==> Outdated formulae:"
brew outdated || true

if ! $NO_CASK; then
  echo "==> Outdated casks:"
  brew outdated --cask || true
fi

echo "==> Upgrading formulae"
brew upgrade

if ! $NO_CASK; then
  echo "==> Upgrading casks"
  if $GREEDY; then
    brew upgrade --cask --greedy
  else
    brew upgrade --cask
  fi
fi

echo "==> Removing unused dependencies"
brew autoremove

echo "==> Cleaning up old versions and caches"
if $DRY_RUN; then
  brew cleanup -n
else
  if $PRUNE_ALL; then
    brew cleanup --prune=all -s
  else
    brew cleanup -s
  fi
fi

echo "==> Health check (non-fatal)"
brew doctor || true

echo "✓ All done."
