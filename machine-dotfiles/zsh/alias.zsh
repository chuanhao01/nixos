# ######  ####  #    #      ##   #      #   ##    ####
#     #  #      #    #     #  #  #      #  #  #  #
#    #    ####  ######    #    # #      # #    #  ####
#   #         # #    #    ###### #      # ######      #
#  #     #    # #    #    #    # #      # #    # #    #
# ######  ####  #    #    #    # ###### # #    #  ####
#
# chuanhao01'szsh alias
#

# docker
alias dc='docker-compose'

# BBSwitch and GPU related alias
alias gpu_on='sudo tee /proc/acpi/bbswitch <<< ON'
alias gpu_off='sudo tee /proc/acpi/bbswitch <<< OFF'

# --- Git aliases ---
alias gs='git status'
alias ga='git add'
alias gl='git log --format="%C(auto)%h - %C(bold yellow)%cn %C(bold green)(%cd) %C(auto)%s%d" --graph --color=always --date=format:"%d %b(%m) %Y, %H:%M:%S"'
alias gc='git commit'
alias gf='git fetch'
alias gb='git branch'
alias gp='git push'
alias gr='git reset'
alias gd='git diff'
alias gm='git merge'

alias gch='git checkout'
alias gpu='git pull'
alias grm='git remote'
alias gst='git stash'
alias gdt='git difftool'
alias gds='git diff --staged'
alias grb='git rebase'
alias gsh='git show'
alias gsm='git submodule'

alias gdts='git difftool --staged'
alias gchp='git cherry-pick'
alias gsbt='git subtree'

# --- Audio output ---
aoutput (){
	pacmd list-sinks | grep -e 'name:' -e 'index:'
}

# --- Common commands ---
alias bd='cd $OLDPWD'
alias ta='tmux attach'
