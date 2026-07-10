#!/usr/bin/env bats

setup() {
  WRAPPER="$BATS_TEST_DIRNAME/../yt_dlp_wrapper.sh"
  STUB_DIR="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB_DIR"
  printf '#!/usr/bin/env bash\necho "yt-dlp $*"\n' > "$STUB_DIR/yt-dlp"
  chmod +x "$STUB_DIR/yt-dlp"
  PATH="$STUB_DIR:$PATH"
}

@test "mp4 without -c invokes yt-dlp with original arguments" {
  run "$WRAPPER" mp4 "https://youtu.be/x"
  [ "$status" -eq 0 ]
  [ "$output" = "yt-dlp -i https://youtu.be/x -S vcodec:h264,res,acodec:m4a" ]
}

@test "mp4 with -c before URL appends Chrome cookies option" {
  run "$WRAPPER" mp4 -c "https://youtu.be/x"
  [ "$status" -eq 0 ]
  [ "$output" = "yt-dlp -i https://youtu.be/x -S vcodec:h264,res,acodec:m4a --cookies-from-browser chrome" ]
}

@test "mp4 with -c after URL behaves the same" {
  run "$WRAPPER" mp4 "https://youtu.be/x" -c
  [ "$status" -eq 0 ]
  [ "$output" = "yt-dlp -i https://youtu.be/x -S vcodec:h264,res,acodec:m4a --cookies-from-browser chrome" ]
}

@test "m4a with -c appends Chrome cookies option" {
  run "$WRAPPER" m4a -c "https://youtu.be/x"
  [ "$status" -eq 0 ]
  [ "$output" = "yt-dlp -i https://youtu.be/x -f ba[ext=m4a] --cookies-from-browser chrome" ]
}

@test "playlist with -c appends Chrome cookies option" {
  run "$WRAPPER" playlist -c "https://youtube.com/playlist?list=PL1"
  [ "$status" -eq 0 ]
  [ "$output" = "yt-dlp -i https://youtube.com/playlist?list=PL1 -S vcodec:h264,res,acodec:m4a -o %(playlist)s/%(title)s.%(ext)s --cookies-from-browser chrome" ]
}

@test "mp4 without URL fails with usage" {
  run "$WRAPPER" mp4
  [ "$status" -eq 1 ]
  [[ "$output" == *"mp4 [-c] <YT_URL>"* ]]
}

@test "mp4 with two URLs fails with usage" {
  run "$WRAPPER" mp4 "https://a" "https://b"
  [ "$status" -eq 1 ]
  [[ "$output" == *"mp4 [-c] <YT_URL>"* ]]
}

@test "mp4 with unknown option fails with usage" {
  run "$WRAPPER" mp4 -x "https://youtu.be/x"
  [ "$status" -eq 1 ]
  [[ "$output" == *"mp4 [-c] <YT_URL>"* ]]
}
