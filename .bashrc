# shellcheck shell=bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"

alias ls='ls -latrh --color'
alias vim='nvim'
alias vi='nvim'
alias btop='btop --utf-force'
alias du='du -h --max-depth=1'
alias tmux='tmux -u'
alias ll='eza -arR1T -L 3 --color --git'
alias grep='grep --color=auto'
alias yay='yay --answerclean All --answerdiff All '
alias practice_golang="cd ~/Practice/golang/zerotomastery.io-golang/src/lectures/exercise && ll"

export PATH="$HOME/.cargo/bin:$PATH"
export CDPATH=.:..:~
export EDITOR=nvim

# Source fzf key bindings and fuzzy completion
# shellcheck source=/dev/null
[ -f "${HOME}"/.fzf.bash ] && [ -r "${HOME}"/.fzf.bash ] && source "${HOME}"/.fzf.bash
# shellcheck source=/dev/null
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
# shellcheck source=/dev/null
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
export FZF_COMPLETION_TRIGGER='~~'

rga-fzf() {
  RG_PREFIX="rga --files-with-matches"
  local file
  file="$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
      --phony -q "$1" \
      --bind "change:reload:$RG_PREFIX {q}" \
      --preview-window="70%:wrap"
  )" &&
    echo "opening $file" &&
    xdg-open "$file"
}

reducevideosize() {
  echo "use this only for filesize>1GiB"
  original_filename=$1
  filename="${original_filename%.*}"
  extension="${original_filename##*.}"
  echo ffmpeg -i "${original_filename}" -c:v libx264 -preset ultrafast -crf 25 -c:a aac -b:a 128k -vf scale=1280:720 "${filename}_OUTPUT.${extension}"
  ffmpeg -i "${original_filename}" -c:v libx264 -preset ultrafast -crf 25 -c:a aac -b:a 128k -vf scale=1280:720 "${filename}_OUTPUT.${extension}"
}

time_to_minutes() {
  IFS=: read -r hour minute <<< "$1"
  echo $((hour * 60 + minute))
}

yt-dlp() {
  local filename_options=(-o "%(upload_date)s - %(uploader_id)s.%(title)s.%(id)s.%(ext)s")
  local format_options=(-f "bv*[vcodec^=avc1][height<=720]+ba/b[ext=mp4]")
  local other_options=()
  local match_options="^--[a-z]+((\-[a-z]+)+)?"

  while [[ $1 =~ ${match_options} ]]; do
    if [[ $1 == "--audio" ]]; then
      format_options=(-x --audio-format mp3 -f "ba")
      shift
    elif [[ $1 == "--default-search" ]]; then
      shift
    else
      other_options+=("$1")
      shift
    fi
  done

  while [ $# -gt 0 ]; do
    local input
    local status
    input=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    if [[ "${input}" =~ (https?://)?(www\.)?(youtube\.com/(watch\?v=|shorts/)|youtu\.be/)[a-zA-Z0-9_-]{11} ]]; then
      command yt-dlp "${filename_options[@]}" "${format_options[@]}" "${other_options[@]}" "${input}"
      status=$?
    elif [[ "${input}" =~ ^[^[:space:]]+([[:space:]]+[^[:space:]]+)+$ ]]; then
      command yt-dlp --default-search "ytsearch" "${filename_options[@]}" "${format_options[@]}" "${other_options[@]}" "${input}"
      status=$?
    else
      command yt-dlp "${other_options[@]}" "$1"
      status=$?
    fi
    shift
    echo "$# remaining"
    if [[ $# -ne 0 && $status -eq 0 ]]; then
      echo "cooling down"
      sleep 20
    fi
  done
}

aws() {
  AWS_ACCESS_KEY_ID=test \
    AWS_SECRET_ACCESS_KEY=test \
    AWS_DEFAULT_REGION=us-east-1 \
    command aws --endpoint-url=http://localhost:4566 "$@"
}

gitx() {
  local url
  url=$(git remote -v | grep push | cut -f2 | cut -d' ' -f1)
  if [[ $url =~ ^https://github.com/(.+)/(.+\.git) ]]; then
    git remote set-url origin git@github.com:"${BASH_REMATCH[1]}"/"${BASH_REMATCH[2]}"
    echo "changed remote url to ssh"
    sleep 1
  fi

  local branch
  branch=$(git branch --show-current)
  echo -e "current branch : $branch\n"
  sleep 1

  local untracked
  untracked=$(git ls-files --others --exclude-standard)
  if [ -n "$untracked" ]; then
    echo -e "\n\n"
    echo "Found untracked files:"
    echo "$untracked"
    echo -e "\n\n"
    read -t 5 -r -p "Add these untracked files ? (y/n): " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      echo "$untracked" | while IFS= read -r file; do
        [ -n "$file" ] && git add -N "$file" && echo "✓ Added intent-to-add: $file"
      done
    else
      echo "Skipped untracked files"
    fi
    sleep 2
  fi

  git add -p
  sleep 1
  git status
  sleep 2
  # git diff --staged
  # sleep 2

  read -t 15 -r -p "pls enter your commit msg : " commit_message
  commit_message="${commit_message:-few changes}"
  git commit -m "$commit_message" || {
    echo "Commit failed or nothing to commit"
    return 1
  }
  echo -e "\n\n"

  if git fetch origin "$branch"; then
    if git status | grep -q "behind"; then
      if ! git pull --ff-only --verbose origin "$branch"; then
        git status
        git diff --name-only #--diff-filter=U
        echo "ff pull failed"
        sleep 2
        if ! git pull origin "$branch"; then
          git status
          echo "pull failed, check manually"
          return 1
        fi
      fi
    fi
  fi

  echo -e "\n\npushing now"
  git push origin "$branch"
}

# autocomplete for kubecolor
complete -o default -F __start_kubectl kubecolor
