#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 [repository-path] [options]

Performs the same steps as the GitHub Actions "Create version tag" workflow locally.

Arguments:
  [repository-path]   Path to the local git repository
                      (default: current directory)

Options:
  -r, --repo PATH           Explicitly set repository path
                            (overrides positional argument)
  -b, --branch BRANCH       Branch to use for tag generation (default: master)
  -d, --description TEXT    Description / message for the annotated tag (default: empty)
  -s, --suffix SUFFIX       Suffix applied to the version tag (default: empty)
  -n, --dry-run             Compute and show the tag, but do not create or push it
  -h, --help                Show this help

Examples:
  # Use current directory
  $0
  $0 .
  $0 --repo .

  # Use another path
  $0 /path/to/libbitcoin-server
  $0 -r /path/to/libbitcoin-server -b master -d "Release notes"
EOF
}

# Defaults matching the workflow
BRANCH="master"
DESCRIPTION=""
SUFFIX=""
DRY_RUN=0
REPO=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--repo)
      REPO="${2:-}"
      shift 2
      ;;
    -b|--branch)
      BRANCH="${2:-}"
      shift 2
      ;;
    -d|--description)
      DESCRIPTION="${2:-}"
      shift 2
      ;;
    -s|--suffix)
      SUFFIX="${2:-}"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -z "$REPO" ]]; then
        REPO="$1"
      else
        echo "Unexpected argument: $1" >&2
        usage >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# Default to current directory if nothing was provided
if [[ -z "$REPO" ]]; then
  REPO="."
fi

# Resolve to absolute path for clearer messages
REPO="$(cd "$REPO" && pwd)"

if [[ ! -d "$REPO" ]]; then
  echo "Error: directory does not exist: $REPO" >&2
  exit 1
fi

cd "$REPO"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not a git repository: $REPO" >&2
  exit 1
fi

echo "Using repository: $REPO"

# ------------------------------------------------------------------
# Step 1: Checkout equivalent (switch to the requested branch)
# ------------------------------------------------------------------
echo "=== Checking out branch: $BRANCH ==="
git fetch --all --tags 2>/dev/null || true
git checkout "$BRANCH"
# Ensure we have full history (equivalent to fetch-depth: 0)
git pull --ff-only origin "$BRANCH" 2>/dev/null || true

# ------------------------------------------------------------------
# Step 2: Configure git identity
# ------------------------------------------------------------------
echo "=== Configuring git identity ==="
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

# ------------------------------------------------------------------
# Step 3: Compute version
# ------------------------------------------------------------------
echo "=== Computing version ==="

CMAKE_FILE="builds/cmake/CMakeLists.txt"
if [[ ! -f "$CMAKE_FILE" ]]; then
  echo "Error: $CMAKE_FILE not found." >&2
  exit 1
fi

MAJOR=$(grep -oP 'set\(\s*LIBBITCOIN_VERSION_MAJOR\s+\K[0-9]+' "$CMAKE_FILE")
MINOR=$(grep -oP 'set\(\s*LIBBITCOIN_VERSION_MINOR\s+\K[0-9]+' "$CMAKE_FILE")
PATCH=$(git rev-list --count HEAD)

if [[ -z "$MAJOR" || -z "$MINOR" ]]; then
  echo "Error: could not extract MAJOR/MINOR from $CMAKE_FILE" >&2
  exit 1
fi

TAG="v${MAJOR}.${MINOR}.${PATCH}${SUFFIX}"

echo "major=$MAJOR"
echo "minor=$MINOR"
echo "patch=$PATCH"
echo "tag=$TAG"
echo "Computed tag: $TAG"

# ------------------------------------------------------------------
# Step 4: Create tag
# ------------------------------------------------------------------
echo "=== Creating tag ==="

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Error: Tag $TAG already exists." >&2
  exit 1
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] Would create annotated tag: $TAG"
  echo "[dry-run] Message: $DESCRIPTION"
  echo "[dry-run] Would push: git push origin $TAG"
  exit 0
fi

git tag -a "$TAG" -m "$DESCRIPTION"
git push origin "$TAG"
echo "Created tag '$TAG'."
