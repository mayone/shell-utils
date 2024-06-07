#!/bin/sh
#
# Wrapper for yt-dlp.

# Commands
MP4="mp4"

CMDS="\
${MP4} \
"

main() {
  CMD="$1"
  if [ "$CMD" == "$MP4" ]; then
    mp4 "${@:2}"
  else
    show_usage "$@"
  fi
}

show_usage() {
  echo "Usage:"
  for CMD in ${CMDS}; do
    echo "  $0 ${CMD}"
  done
  echo ""
}

#######################################
# Download YouTube video in mp4 format.
# Arguments:
#   Link to the YouTube video.
# Returns:
#######################################
mp4() {
  if [[ "$#" != 1 ]]; then
    echo "$MP4 <YT_URL>        Download video by the YouTube link."
    return
  fi

  YT_URL="$1"

  yt-dlp -i "$YT_URL" -S vcodec:h264,res,acodec:m4a
}

main "$@"