alias claude-yolo='cd $HOME/agents && claude --dangerously-skip-permissions'
alias claude-auto='cd $HOME/agents && claude --permission-mode auto'
alias codex-auto='cd $HOME/agents && codex -c approvals_reviewer=auto_review'

# Ghost text suggestions from command history
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Ctrl+F accepts the suggestion
bindkey '^f' autosuggest-accept

eval "$(starship init zsh)"

# Syntax highlighting — keep this last
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
