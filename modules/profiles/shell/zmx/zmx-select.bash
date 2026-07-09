SHELL=$(command -v fish)
export SHELL

display=$(
  zmx list 2>/dev/null |
    while IFS=$'\t' read -r name pid clients _ dir; do
      printf "%-20s  pid:%-8s  clients:%-2s  %s\n" \
        "${name#*name=}" "${pid#*pid=}" "${clients#*clients=}" "${dir#*start_dir=}"
    done
)

output=$(
  { [[ -n $display ]] && echo "$display"; } | fzf \
    --print-query \
    --expect=ctrl-n \
    --height=80% \
    --reverse \
    --prompt="zmx> " \
    --header="Enter: select | Ctrl-N: create new" \
    --preview='zmx history {1}' \
    --preview-window=right:60%:follow
)
rc=$?

query=$(echo "$output" | sed -n '1p')
key=$(echo "$output" | sed -n '2p')
selected=$(echo "$output" | awk 'NR==3 {print $1}')

if [[ $key == "ctrl-n" && -n $query ]]; then
  session_name=$query
elif [[ $rc -eq 0 && -n $selected ]]; then
  session_name=$selected
elif [[ -n $query ]]; then
  session_name=$query
else
  exit 130
fi

zmx attach "$session_name"
