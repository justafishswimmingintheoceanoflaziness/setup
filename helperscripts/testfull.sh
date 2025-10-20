#!/usr/bin/env bash

set -o errexit  # Exit on any error
set -o pipefail # Return failure if any part of a pipeline fails
set -o nounset  # Treat unset variables as errors (optional)

#########################
usage() {
  echo "Usage: $0 [-m] [-t <arg>] [-u] [-d] [-p <arg>] [-s <arg>]"
  echo "Options:"
  echo "  -m           move videos"
  echo "  -t <arg>     Play media of given type (jpg, png, mp3, mp4 etc.)"
  echo "  -u           unzip archives"
  echo "  -d           remove duplicates"
  echo "  -p <arg>     play recent (give # in days 0-9|^0-9)"
  echo "  -s <arg>     search for something (give pattern)"
  exit 1
}

#########################
cleanup() {
  find "${WORKDIR}" -type f -iregex '.*\.html$' -print0 -exec rm -fv {} +
  find "${WORKDIR}" -type d -iregex '.*[a-z]+\.\(com\|net\).*' -print0 -exec rm -rfv {} +
  find "${WORKDIR}" -type f -iregex '.*([1-9]+)\.png$' -print0 -exec rm -fv {} +
  echo "thank you for your attention to this matter"
}

trap cleanup EXIT
trap cleanup SIGINT

#########################
movefiles() {
  counter=$(date -u +%s)
  counter=$(echo "${counter}"+1000 | bc -l) 
  while IFS= read -r -d '' dir; do
    while IFS= read -r -d '' file; do
      extension="${file##*.}"
      newname=$(printf "file_%08d.%s" "$counter" "$extension")
      echo "Moving and renaming '$file' to '$newname'"
      mv --backup "$file" "$newname"
      touch "$newname"
      ((counter++))
    done < <(find "$dir" -type f -iregex '.*\.mp4$\|.*\.gif$\|.*\.webp$' -print0)
    echo -e "\n\n\n"
  done < <(find "${WORKDIR}" -type d -iregex ".*[a-z]+\.\(com\|net\).*" -print0)
  echo "moved all files"
}

#########################
unzipfiles() {
  while IFS= read -r -d '' zipfile; do
    echo "unzipping $zipfile "
    unzip -Z1 "$zipfile" | while read -r file; do
      unzip -ovu "$zipfile" "$file"
      touch "$file"
    done || 7z x "$zipfile" -aot
    echo "removing file $zipfile"
    rm -fv "$zipfile"
    echo -e "\n\n\n"
  done < <(find "${WORKDIR}" -type f -iregex '.*\.zip$' -print0)
  echo -e "processed all zip files "
}

#########################
find_duplicate_files() {
  declare -A hash_map=()
  declare -A duplicates=()

  COUNT=$(find "${WORKDIR}" -type f | wc -l)
  DELAY=1

  set +u
  while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
      file_hash=$(sha256sum "$file" | awk '{print $1}')
      if [[ -v "${hash_map[${file_hash}]}" ]]; then
        if [[ -n "${hash_map[${file_hash}]}" ]]; then
          echo "DUPLICATE : $file_hash $file $DELAY"
          echo "Original : $file_hash ${hash_map[${file_hash}]}"
          duplicates["${file_hash}"]+="|$file"
          if cmp -s "${hash_map[${file_hash}]}" "$file"; then
            echo "byte level comparison succeeded..."
            rm -fv -- "${file}"
          else
            echo "WARNING: Hash collision suspected! Files differ despite same hash:" >&2
            echo "  ${hash_map[${file_hash}]}" >&2
            echo "  $file" >&2
          fi
        fi
      else
        hash_map["${file_hash}"]="$file"
        echo "OK : $file_hash $DELAY"
      fi
      ((DELAY++))
      if (( DELAY == 1000 )); then echo "cooling down..."; sleep 25 ; fi;
      if (( DELAY % 25 == 0)); then sleep 1; fi;
    fi
  done < <(find "${WORKDIR}" -type f -print0)
  set -u

  echo "----------------------------------------"
  echo "----------------------------------------"

  echo "Duplicate file :" "${duplicates[@]}"
  echo "Total duplicates found: $((COUNT - ${#hash_map[@]}))"
  echo "Total unique files: ${#hash_map[@]}"
}

#########################
asktoplay() {
  while true; do
    read -r -p "Do you want to play all this ??? (y/n) " yn
    case $yn in
    [Yy]*)
      echo "Proceeding..."
      playmedia
      break
      ;;
    [Nn]*)
      echo "Exiting..."
      exit 0
      ;;
    *) echo "Invalid response, please enter y or n." ;;
    esac
  done
}

#########################
playmedia() {
  for file in "${files[@]}"; do
    sleep 1
    extension="${file##*.}"
    if [[ "$extension" == "png" ||
      "$extension" == "jpg" ||
      "$extension" == "jpeg" ||
      "$extension" == "webp" ]]; then
      echo "displaying $file"
      ristretto -f -s "$file" 2>/dev/null
      #mpv --fullscreen --fs-screen=1 --length=5 "$file"
    elif [[ "$extension" == "mp3" ]]; then
      echo "playing $file"
      mpv "$file"
    elif [[ "$extension" == "pdf" ]]; then
      echo "showing $file"
      atril "$file"
    else
      echo "playing $file"
      if ! mpv --no-config --hwdec=no --vo=x11 --fullscreen --fs-screen=1 "${file}" ; then
        echo "mpv failed on file $file"
      fi
    fi
  done
}


#########################
WORKDIR=~/Software/tor-browser/Browser/Downloads
#########################
flag_m=false
flag_t_arg=""
flag_s_arg=""
flag_u=false
flag_p_arg=""
flag_d=false

expression_parts=()

while getopts ":mt:s:up:d" opt; do
  case $opt in
  m) flag_m=true
    echo "Moving files"
    movefiles
    ;;
  u) flag_u=true 
    echo "unzipping files"
    unzipfiles
    ;;
  d) flag_d=true 
    echo "finding duplicate files"
    find_duplicate_files
    ;;
  t) flag_t_arg=$OPTARG 
    IFS=',' read -ra types <<< "$flag_t_arg"
    expression_parts+=("(")
    for ((i=0 ; i<${#types[@]} ; i++)); do
      if [ $i -gt 0 ]; then
        expression_parts+=("-o")
      fi
      expression_parts+=("-iregex")
      expression_parts+=(".*\.${types[$i]}$")
    done  
    expression_parts+=(")")
    echo "finding files of type ${types[*]} :"
    ;;
  s) flag_s_arg=$OPTARG
    IFS=',' read -ra matches <<< "$flag_s_arg"
    expression_parts+=("(")
    for ((i=0 ; i<${#matches[@]} ; i++)); do
      if [ $i -gt 0 ]; then
        expression_parts+=("-a")
      fi
      expression_parts+=("-iname")
      expression_parts+=("*${matches[$i]}*")
    done  
    expression_parts+=(")")
    echo "searching files with name like ${matches[*]} :"
    ;;
  p) flag_p_arg=$OPTARG 
    expression_parts+=("(")
    if [[ $flag_p_arg =~ ^([0-9]+)\-([0-9]+)$ ]]; then
      IFS='-' read -r start end <<< "$flag_p_arg"
      expression_parts+=("-ctime")
      expression_parts+=("+${start}")
      expression_parts+=("-ctime")
      expression_parts+=("-${end}")
    elif [[ $flag_p_arg =~ ^\^([0-9]+)\-([0-9]+)$ ]]; then
      expression_parts+=("-not")
      expression_parts+=("(")
      expression_parts+=("-ctime")
      expression_parts+=("+${BASH_REMATCH[1]}")
      expression_parts+=("-ctime")
      expression_parts+=("-${BASH_REMATCH[2]}")
      expression_parts+=(")")
    else
      expression_parts+=("-ctime")
      expression_parts+=("-${flag_p_arg}")
    fi
    expression_parts+=(")")
    echo "looking for $flag_p_arg day(s) old files :"
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    usage
    ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    usage
    ;;
  esac
done

#########################
if ! $flag_m && [ -z "$flag_s_arg" ] && [ -z "$flag_t_arg" ] && ! $flag_u && [ -z "$flag_p_arg" ] && ! $flag_d; then
  echo "ERROR: At least one flag should be provided"
  usage
fi

#########################
processandtrigger() {

  if [[ ${#expression_parts[@]} -ne 0 ]] ; then

    mapfile -d $'\0' -t allfiles < <(find "${WORKDIR}" -type f "${expression_parts[@]}" -print0 2>/dev/null)

    if [ ${#allfiles[@]} -eq 0 ]; then
      echo "no files found for given criteria"
      exit 1
    else
      printf "%s\n" "${allfiles[@]}"
      echo "found ${#allfiles[@]} files"
    fi

    mapfile -t files < <(printf '%s\n' "${allfiles[@]}" |shuf |shuf |shuf)

    asktoplay

  else
    exit 1
  fi

}

processandtrigger
#######################
