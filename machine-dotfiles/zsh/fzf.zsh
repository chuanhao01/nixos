# ######  ####  #    #    ###### ###### ######
#     #  #      #    #    #          #  #
#    #    ####  ######    #####     #   #####
#   #         # #    #    #        #    #
#  #     #    # #    #    #       #     #
# ######  ####  #    #    #      ###### #
#
# chuanhao01's zsh fzf configs
#

# This is my configs for fzf use with zsh
# You can find the fzf repo here: https://github.com/junegunn/fzf
# These configs are seperated because fzf has a lot of configs that need to work together
# Also contains the setup for fzf completion, key-bindings

# --- fzf git setup ---
# zsh fzf configs needed for git integeration
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

_gs() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

# Need to double check logic, and make the output correct
_gb() {
  is_in_git_repo || return
  CURRENT_BRANCH=$(git branch -a -vv --color=always | grep '*')
  OTHER_BRANCHES=$(git branch -a -vv --color=always | grep -v '/HEAD\s' | grep -v '*' | sort)
  ALL_BRANCHES="$OTHER_BRANCHES\n$CURRENT_BRANCH"
  echo "$ALL_BRANCHES" |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --format="%C(auto)%h - %C(bold yellow)%cn %C(bold green)(%cs) %C(auto)%s%d" --graph --color=always $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

_gl() {
  is_in_git_repo || return
  git log --format="%C(auto)%h - %C(bold yellow)%cn %C(bold green)(%cs) %C(auto)%s%d" --graph --color=always --all |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --name-only --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

_gt() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  # Big headache, cause idk where this keybind is set, need to remove for ^g keybinds to work
  # Look at the bottom comment: https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
  eval "bindkey -r '^G'"
  eval "bindkey -r '^g'"
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}


export FZF_DEFAULT_COMMAND="rg . --files --hidden --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi
# Setup fzf git
bind-git-helper s b t l r t
unset -f bind-git-helper
