#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -latrh --color'
alias vim='nvim'
alias vi='nvim'
alias btop='btop --utf-force'
alias du='du -h --max-depth=1'
alias tmux='tmux -u'
alias ll='eza -arR1T -L 3 --color' 
alias grep='grep --color=auto'
alias yay='yay --answerclean All --answerdiff All '

eval "$(starship init bash)"

export PATH="$HOME/.cargo/bin:$PATH"
export CDPATH=.:~
export EDITOR=nvim


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Source fzf key bindings and fuzzy completion
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
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
    IFS=: read -r hour minute <<< "$1";
    echo $((hour * 60 + minute))
}

yaycleanup() { 
    sudo /usr/bin/pacman -Svcc --noconfirm
    sudo rm -rvf  .cache/yay/*
}

yt-dl() { 
    while [ $# -gt 0 ]; do
        if [[ $1 =~ ^https?://.*\..*\/.* ]]; then
            echo "Downloading now";
            yt-dlp -o "%(upload_date)s - %(uploader_id)s.%(title)s.%(id)s.%(ext)s" -f "bv*[vcodec^=avc1][height<=720]+ba/b[ext=mp4]" "$1";
        else
            echo "Invalid url:  $1";
	    exit 1
        fi;
        shift;
        echo "$# remaining";
        sleep 30;
    done
}

yt-dlp-a() { 
    yt-dlp -x --audio-format mp3 --get-filename -o "%(upload_date)s - %(uploader_id)s.%(title)s.%(id)s.%(ext)s" $1
}

# autocomplete for kubecolor
complete -o default -F __start_kubectl kubecolor

