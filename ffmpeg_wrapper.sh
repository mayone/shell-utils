#!/bin/bash
#
# Wrapper for ffmpeg.

PSEUDO_ORG=https://sudo-flix.lol
WIN7_CHROME_UA="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"
WIN10_EDGE_UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246"

# Commands
DOWNLOAD="dl"
EXTRACT="ext"
MERGE="mrg"
REVERSE="rev"
CONCAT="con"
ROTATE="rot"
MPEG="mpeg"

CMDS="\
${DOWNLOAD} \
${EXTRACT} \
${MERGE} \
${REVERSE} \
${CONCAT} \
${ROTATE} \
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
  elif [ "$CMD" == "$CONCAT" ]; then
    concat "${@:2}"
  elif [ "$CMD" == "$ROTATE" ]; then
    rotate "${@:2}"
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

  ffmpeg \
    -headers "Origin: ${PSEUDO_ORG}" \
    -i "$M3U8_LINK" \
    -c copy "$OUT_V"
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
# Concat videos.
# Arguments:
#   Input video folder.
#   Output video file path.
# Returns:
#######################################
concat() {
  if [[ "$#" != 2 ]]; then
    echo "$CONCAT <IN_FOLDER> <OUT_V>        Concat videos."
    return
  fi

  IN_FOLDER="$1"
  OUT_V="$2"

  # -safe 0: allow the use of special characters in the input file list
  # -i: input file list
  # -c copy: copy the input streams to the output file without re-encoding
  ffmpeg -f concat -safe 0 -i <(for f in "$IN_FOLDER"/*.mp4; do printf "file '$f'\n"; done) -c copy "$OUT_V"
}

#######################################
# Rotate video (counterclockwise 90 degrees).
# Arguments:
#   Input video file path.
#   Output video file path.
# Returns:
#######################################
rotate() {
  if [[ "$#" != 2 ]]; then
    echo "$ROTATE <IN> <OUT>        Rotate video."
    return
  fi

  IN_V="$1"
  OUT_V="$2"

  # -display_rotation 90: rotate the video 90 degrees counterclockwise
  # -display_rotation 270: rotate the video 90 degrees clockwise
  ffmpeg -display_rotation 270 -i "$IN_V" -c copy "$OUT_V"
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