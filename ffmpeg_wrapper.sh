#!/bin/sh
#
# Wrapper for ffmpeg.

# Commands
DOWNLOAD="dl"
EXTRACT="ext"
MERGE="mrg"
REVERSE="rev"
MPEG="mpeg"

CMDS="\
${DOWNLOAD} \
${EXTRACT} \
${MERGE} \
${REVERSE} \
${MPEG} \
"

main() {
  CMD="$1"
  if [ "$CMD" == "$DOWNLOAD" ]; then
    download "${@:2}"
  elif [ "$CMD" == "$EXTRACT" ]; then
    extract_audio "${@:2}"
  elif [ "$CMD" == "$MERGE" ]; then
    merge "${@:2}"
  elif [ "$CMD" == "$REVERSE" ]; then
    reverse "${@:2}"
  elif [ "$CMD" == "$MPEG" ]; then
    mpeg_audio_convert "${@:2}"
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
# Download video by the M3U8 file link.
# Arguments:
#   Link to the M3U8 file.
#   Output video file path.
# Returns:
#######################################
download() {
  if [[ "$#" != 2 ]]; then
    echo "$DOWNLOAD <M3U8_LINK> <OUT>        Download video by the M3U8 file link."
    return
  fi

  M3U8_LINK="$1"
  OUT_V="$2"

  ffmpeg -i "$M3U8_LINK" -c copy "$OUT_V"
}

#######################################
# Extract audio from video.
# Arguments:
#   Input video file path.
#   Output audio file path.
# Returns:
#######################################
extract_audio() {
  if [[ "$#" != 2 ]]; then
    echo "$EXTRACT <IN_V> <OUT_A>        Extract audio from video."
    return
  fi

  IN_V="$1"
  OUT_A="$2"

  # vn: no video
  # acodec: use the same audio stream that's already in the video
  ffmpeg -i "$IN_V" -vn -acodec copy "$OUT_A"
}

#######################################
# Merge video and audio.
# Arguments:
#   Input video file path.
#   Input audio file path.
#   Output video file path.
# Returns:
#######################################
merge() {
  if [[ "$#" != 3 ]]; then
    echo "$MERGE <IN_V> <IN_A> <OUT_V>        Merge video and audio."
    return
  fi

  IN_V="$1"
  IN_A="$2"
  OUT_V="$3"

  ffmpeg -i "$IN_V" -i "$IN_A" \
    -c:v copy -c:a aac -strict experimental \
    -map 0:v:0 -map 1:a:0 "$OUT_V"
}

#######################################
# Reverse video.
# Arguments:
#   Input video file path.
#   Output video file path.
# Returns:
#######################################
reverse() {
  if [[ "$#" != 2 ]]; then
    echo "$REVERSE <IN> <OUT>        Reverse video."
    return
  fi

  IN_V="$1"
  OUT_V="$2"

  ffmpeg -i "$IN_V" -vf reverse "$OUT_V"
}

#######################################
# m4a to mp3.
# Arguments:
#   Input audio file path.
#   Output audio file path.
# Returns:
#######################################
mpeg_audio_convert() {
  if [[ "$#" != 2 ]]; then
    echo "$MPEG <IN> <OUT>        m4a to mp3."
    return
  fi

  IN_A="$1"
  OUT_A="$2"

  ffmpeg -i "$IN_A" -c:v copy -c:a libmp3lame -q:a 4 "$OUT_A"
}

main "$@"