# yt_dlp_wrapper.sh `-c` Cookies Flag Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `-c` flag to all three `yt_dlp_wrapper.sh` sub-commands that appends `--cookies-from-browser chrome` to the underlying `yt-dlp` call, so YouTube bot checks can be bypassed with the Chrome login.

**Architecture:** A single `parse_args` helper inside `yt_dlp_wrapper.sh` replaces the `require_args` count check for the three sub-commands. It accepts `-c` in any position, requires exactly one URL, and exposes results via two globals (`PARSED_URL`, `PARSED_COOKIES`). Sub-commands append the cookies array using the bash-3.2-safe `${arr[@]+"${arr[@]}"}` expansion.

**Tech Stack:** bash (must stay 3.2-compatible), bats-core 1.13 (`./run-tests.sh`), shellcheck 0.11.

**Spec:** `docs/superpowers/specs/2026-07-10-yt-dlp-cookies-design.md`

## Global Constraints

- Must run on macOS system bash 3.2.57 (`#!/usr/bin/env bash` resolves to it on the dev machine — no Homebrew bash). Empty-array expansion under `set -u` MUST use `${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}`; this exact idiom was verified OK on bash 3.2.57 on 2026-07-10.
- Keep `set -euo pipefail` and `IFS=$'\n\t'` exactly as they are.
- `shellcheck yt_dlp_wrapper.sh` must be clean (repo `.shellcheckrc`: `shell=bash`, `external-sources=true`, `source-path=SCRIPTDIR`).
- Code comments and commit messages in English; conventional-commit prefixes; **no AI attribution or session links in commit messages**.
- `require_args` in `utils/cli.sh` must NOT be modified or removed (other scripts and `tests/cli.bats` use it).
- Run tests from the repo root: `projects/shell-utils/`.

---

### Task 1: `-c` flag in yt_dlp_wrapper.sh (parse_args + all three sub-commands)

**Files:**
- Create: `tests/yt_dlp_wrapper.bats`
- Modify: `yt_dlp_wrapper.sh` (whole file — final content shown in Step 3)

**Interfaces:**
- Consumes: `print_usage` from `utils/cli.sh` (unchanged, via `utils/index.sh`).
- Produces: `parse_args USAGE_LINE ARG...` → returns 0 and sets globals `PARSED_URL` (string) and `PARSED_COOKIES` (array; `()` or `(--cookies-from-browser chrome)`); returns 1 after printing `USAGE_LINE` to stderr on: no URL, a second URL, or any `-*` token other than `-c`. Task 2 depends only on the user-facing behaviour, not on these names.

- [ ] **Step 1: Write the failing tests**

Create `tests/yt_dlp_wrapper.bats` with exactly:

```bash
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
```

Notes for the implementer:
- The stub `yt-dlp` echoes its argv, so assertions compare the exact
  command line the wrapper builds. The stub runs as a separate process
  with default IFS, so `$*` joins with single spaces.
- bats `run` captures stdout+stderr combined into `$output` — the usage
  line printed to stderr is asserted via `$output`.

- [ ] **Step 2: Run the new suite to verify it fails**

Run: `bats tests/yt_dlp_wrapper.bats`
Expected: **7 of 8 tests FAIL**. Only "mp4 without -c invokes yt-dlp with original arguments" passes (current behaviour already matches — this pins the no-regression case). The two usage-error tests fail because the current usage text lacks `[-c]`; the rest fail because `-c` is rejected by `require_args`.

- [ ] **Step 3: Implement `parse_args` and rewrite the three sub-commands**

Replace the entire content of `yt_dlp_wrapper.sh` with:

```bash
#!/usr/bin/env bash
#
# Wrapper for yt-dlp.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

# parse_args USAGE_LINE ARG...
#
# Parses sub-command arguments: `-c` enables Chrome cookies, the single
# bare token is the URL. Sets globals:
#   PARSED_URL     - the URL
#   PARSED_COOKIES - () or (--cookies-from-browser chrome); expand it as
#                    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"} so that
#                    `set -u` on bash 3.2 tolerates the empty case.
# On a missing/duplicate URL or an unknown option, prints USAGE_LINE to
# stderr and returns 1.
parse_args() {
  local usage="$1"
  shift
  PARSED_URL=""
  PARSED_COOKIES=()
  local arg
  for arg in "$@"; do
    case "$arg" in
      -c)
        PARSED_COOKIES=(--cookies-from-browser chrome)
        ;;
      -*)
        echo "$usage" >&2
        return 1
        ;;
      *)
        if [[ -n "$PARSED_URL" ]]; then
          echo "$usage" >&2
          return 1
        fi
        PARSED_URL="$arg"
        ;;
    esac
  done
  if [[ -z "$PARSED_URL" ]]; then
    echo "$usage" >&2
    return 1
  fi
}

mp4() {
  parse_args "mp4 [-c] <YT_URL>       Download video as mp4." "$@" || return 1
  yt-dlp -i "$PARSED_URL" -S 'vcodec:h264,res,acodec:m4a' \
    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}
}

m4a() {
  parse_args "m4a [-c] <YT_URL>       Download audio as m4a." "$@" || return 1
  yt-dlp -i "$PARSED_URL" -f 'ba[ext=m4a]' \
    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}
}

playlist() {
  parse_args "playlist [-c] <PL_URL>  Download playlist as mp4." "$@" || return 1
  yt-dlp -i "$PARSED_URL" -S 'vcodec:h264,res,acodec:m4a' -o '%(playlist)s/%(title)s.%(ext)s' \
    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}
}

show_usage() {
  print_usage "$0" \
    "mp4 [-c] <YT_URL>       Download video as mp4." \
    "m4a [-c] <YT_URL>       Download audio as m4a." \
    "playlist [-c] <PL_URL>  Download playlist as mp4."
  echo "  -c: use Chrome cookies (--cookies-from-browser chrome)."
  echo ""
}

main() {
  case "${1:-}" in
    mp4)      shift; mp4 "$@" ;;
    m4a)      shift; m4a "$@" ;;
    playlist) shift; playlist "$@" ;;
    *)        show_usage; exit 1 ;;
  esac
}

main "$@"
```

Implementation notes:
- The usage string passed to each `parse_args` call is byte-identical to
  the corresponding `show_usage` line (descriptions column-aligned at
  column 25, matching the pre-change format).
- Do NOT rewrite `[[ -n ... ]] && { ...; }` as a bare `&&` list at
  function end — under `set -e` a false left-hand side would abort the
  script. The `if` blocks above are deliberate.
- `require_args` is intentionally no longer imported/used here; it stays
  in `utils/cli.sh` untouched.

- [ ] **Step 4: Run the new suite to verify it passes**

Run: `bats tests/yt_dlp_wrapper.bats`
Expected: `8 tests, 0 failures`

- [ ] **Step 5: Run the full suite and shellcheck**

Run: `./run-tests.sh`
Expected: all bats files pass (`blockchain.bats` network cases skip by default).

Run: `shellcheck yt_dlp_wrapper.sh`
Expected: no output (clean). (`.bats` files are outside the repo's
documented shellcheck scope — `shellcheck *.sh utils/*.sh tests/*.sh`.)

- [ ] **Step 6: Commit**

```bash
git add yt_dlp_wrapper.sh tests/yt_dlp_wrapper.bats
git commit -m "feat(yt-dlp): add -c flag for Chrome browser cookies"
```

---

### Task 2: Document `-c` in README

**Files:**
- Modify: `README.md` (the `### \`yt_dlp_wrapper.sh\`` section, currently lines 36-44)

**Interfaces:**
- Consumes: the user-facing CLI from Task 1 (`[-c]` accepted by all three sub-commands).
- Produces: nothing consumed by other tasks.

- [ ] **Step 1: Update the section**

Replace:

````markdown
### `yt_dlp_wrapper.sh`

Thin wrapper around `yt-dlp`.

```sh
./yt_dlp_wrapper.sh mp4 <YT_URL>
./yt_dlp_wrapper.sh m4a <YT_URL>
./yt_dlp_wrapper.sh playlist <PL_URL>
```
````

with:

````markdown
### `yt_dlp_wrapper.sh`

Thin wrapper around `yt-dlp`.

```sh
./yt_dlp_wrapper.sh mp4      [-c] <YT_URL>
./yt_dlp_wrapper.sh m4a      [-c] <YT_URL>
./yt_dlp_wrapper.sh playlist [-c] <PL_URL>
```

`-c` reuses Chrome's logged-in YouTube session
(`--cookies-from-browser chrome`) to get past "confirm you're not a
bot" checks. On macOS the first run asks for Keychain access to
"Chrome Safe Storage" — allow it.
````

- [ ] **Step 2: Verify rendering and consistency**

Run: `sed -n '36,52p' README.md`
Expected: the new block exactly as above; flag spelling `-c` matches the
script's usage output (`./yt_dlp_wrapper.sh` with no args to compare).

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: document yt_dlp_wrapper -c cookies flag"
```
