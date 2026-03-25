#!/bin/bash
# Convert LaTeX sources to Markdown.
# Usage: tex-to-md.sh <tex-dir> <output-file> [version] [date] [hash]
#
# This script preprocesses LaTeX files (expanding macros, fixing encoding)
# and runs pandoc to produce markdown with numbered sections and front matter.

set -e

TEX_DIR="$1"
OUTPUT="$2"
GP_VERSION="${3:-unknown}"
GP_DATE="${4:-unknown}"
GP_HASH="${5:-unknown}"

if [ -z "$TEX_DIR" ] || [ -z "$OUTPUT" ]; then
  echo "Usage: $0 <tex-dir> <output-file> [version] [date] [hash]" >&2
  exit 1
fi

MDTMP=$(mktemp -d)
trap 'rm -rf "$MDTMP"' EXIT

cp -r "$TEX_DIR"/* "$MDTMP/"

# Preprocess: replace ¬ with N (used as letter in macro names via \catcode)
find "$MDTMP" -name '*.tex' -exec sed -i 's/¬/N/g' {} +

# Preprocess: expand text-mode macros that pandoc silently drops
find "$MDTMP" -name '*.tex' -exec sed -i \
  -e 's/\\Jam\([^a-zA-Z]\)/JAM\1/g' \
  -e 's/\\Jam$/JAM/g' \
  -e 's/\\eg\([^a-zA-Z]\)/e.g.\1/g' \
  -e 's/\\Eg\([^a-zA-Z]\)/E.g.\1/g' \
  -e 's/\\ie\([^a-zA-Z]\)/i.e.\1/g' \
  -e 's/\\Ie\([^a-zA-Z]\)/I.e.\1/g' \
  -e 's/\\etc\([^a-zA-Z]\)/\&c.\1/g' \
  -e 's/\\nb\([^a-zA-Z]\)/n.b.\1/g' \
  {} +

# Preprocess: convert abstract to a regular section so pandoc keeps it
find "$MDTMP" -name '*.tex' -exec sed -i \
  -e 's/\\begin{abstract}//' \
  -e 's/\\end{abstract}//' \
  {} +

# Preprocess: insert appendix marker for the Lua filter
sed -i 's/^\\appendix$/\\section{APPENDIX_MARKER}/' "$MDTMP/graypaper.tex"

# Extract document body and convert
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
{
  cat <<FRONTMATTER
---
title: "JAM: Join-Accumulate Machine"
subtitle: "A Mostly-Coherent Trustless Supercomputer"
author: "Dr. Gavin Wood"
version: "${GP_VERSION}"
date: "${GP_DATE}"
hash: "${GP_HASH}"
---

FRONTMATTER
  cd "$MDTMP"
  sed -n '/\\begin{document}/,/\\end{document}/p' graypaper.tex \
    | pandoc -f latex -t markdown --wrap=none \
      --lua-filter="$SCRIPT_DIR/number-sections.lua"
} > "$OUTPUT"
