#!/bin/bash

# Read JSON input once
input=$(cat)

# Extract current directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Extract active model display name
model=$(echo "$input" | jq -r '.model.display_name // .model.id // empty')

# Extract context percentage (integer)
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Extract token counts (cumulative session totals)
tokens_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
tokens_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Format a number as K with one decimal if >= 1000 (e.g. 14823 -> 14.8K, 523 -> 523)
fmt_k() {
  local n=$1
  if [ "$n" -ge 1000 ]; then
    printf "%.1fK" "$(echo "scale=4; $n / 1000" | bc)"
  else
    printf "%s" "$n"
  fi
}

tokens_in_fmt=$(fmt_k "$tokens_in")
tokens_out_fmt=$(fmt_k "$tokens_out")

# Color the context bar based on usage
if [ "$ctx_pct" -ge 80 ]; then
  ctx_color='\033[01;31m'   # bold red
elif [ "$ctx_pct" -ge 60 ]; then
  ctx_color='\033[01;33m'   # bold yellow
elif [ "$ctx_pct" -ge 40 ]; then
  ctx_color='\033[01;32m'   # bold green
else
  ctx_color='\033[00;32m'   # dim green
fi

# Dim separator and label colors
SEP='\033[02;37m · \033[00m'
LBL='\033[02;37m'
RST='\033[00m'

# Resolve display name: repo name if in a git repo, otherwise basename of cwd
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  display=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || echo "$cwd")")
else
  display=$(basename "$cwd")
fi

printf "\033[01;36m%s${RST}${SEP}\033[01;35m%s${RST}${SEP}${LBL}in${RST} \033[01;36m%s${RST} ${LBL}out${RST} \033[01;33m%s${RST}${SEP}${LBL}ctx${RST} %b%s%%${RST}" \
  "$display" "$model" "$tokens_in_fmt" "$tokens_out_fmt" "$ctx_color" "$ctx_pct"