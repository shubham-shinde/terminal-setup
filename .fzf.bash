# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lenovo/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/lenovo/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/lenovo/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/lenovo/.fzf/shell/key-bindings.bash"
