#!/bin/sh
# Status line: model | context bar | 5h session bar | 7d weekly bar + days until reset
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ANSI color codes
cyan=$(printf '\033[36m')
green=$(printf '\033[32m')
yellow=$(printf '\033[33m')
red=$(printf '\033[31m')
reset=$(printf '\033[0m')
bold=$(printf '\033[1m')

# Build a progress bar: usage_pct, width, filled_char, empty_char
# Usage: make_bar <pct_int> <width>
make_bar() {
  pct=$1
  width=$2
  filled=$(( pct * width / 100 ))
  empty=$(( width - filled ))
  bar=""
  i=0
  while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
  while [ $i -lt $width ];  do bar="${bar}░"; i=$(( i + 1 )); done
  printf "%s" "$bar"
}

# Color based on percentage
pct_color() {
  pct=$1
  if [ "$pct" -ge 80 ]; then
    printf '%s' "$red"
  elif [ "$pct" -ge 50 ]; then
    printf '%s' "$yellow"
  else
    printf '%s' "$green"
  fi
}

# --- Model ---
model_part=""
if [ -n "$model" ]; then
  model_part="${bold}${model}${reset}"
  [ -n "$effort" ] && model_part="${model_part} ${cyan}[${effort}]${reset}"
fi

# --- Context window bar ---
ctx_part=""
if [ -n "$ctx_used" ]; then
  ctx_int=$(printf '%.0f' "$ctx_used")
  color=$(pct_color "$ctx_int")
  bar=$(make_bar "$ctx_int" 10)
  ctx_part="${color}ctx [${bar}] ${ctx_int}%${reset}"
fi

# --- 5-hour session bar ---
five_part=""
if [ -n "$five_pct" ]; then
  five_int=$(printf '%.0f' "$five_pct")
  color=$(pct_color "$five_int")
  bar=$(make_bar "$five_int" 10)
  five_part="${color}5h [${bar}] ${five_int}%${reset}"
fi

# --- 7-day weekly bar + days until reset ---
week_part=""
if [ -n "$week_pct" ]; then
  week_int=$(printf '%.0f' "$week_pct")
  color=$(pct_color "$week_int")
  bar=$(make_bar "$week_int" 10)
  days_str=""
  if [ -n "$week_resets" ]; then
    now=$(date +%s)
    secs_left=$(( week_resets - now ))
    if [ "$secs_left" -gt 0 ]; then
      days_left=$(( secs_left / 86400 ))
      hours_left=$(( (secs_left % 86400) / 3600 ))
      if [ "$days_left" -gt 0 ]; then
        days_str=" (resets ${days_left}d ${hours_left}h)"
      else
        days_str=" (resets ${hours_left}h)"
      fi
    fi
  fi
  week_part="${color}7d [${bar}] ${week_int}%${days_str}${reset}"
fi

# --- Compose ---
out=""
[ -n "$model_part" ] && out="${model_part}"
[ -n "$ctx_part"   ] && out="${out} | ${ctx_part}"
[ -n "$five_part"  ] && out="${out} | ${five_part}"
[ -n "$week_part"  ] && out="${out} | ${week_part}"

printf '%s\n' "$out"
