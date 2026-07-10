# yt_dlp_wrapper.sh — `-c` cookies flag

- **Date:** 2026-07-10
- **Status:** Approved

## Goal

YouTube frequently blocks anonymous downloads with a "confirm you're not
a bot" check. yt-dlp can bypass it by reusing the browser's logged-in
session via `--cookies-from-browser`. Today the wrapper's sub-commands
accept exactly one argument (the URL), so there is no way to pass this
option through. Add a `-c` flag that enables Chrome cookies.

## Interface

```sh
./yt_dlp_wrapper.sh mp4      [-c] <YT_URL>
./yt_dlp_wrapper.sh m4a      [-c] <YT_URL>
./yt_dlp_wrapper.sh playlist [-c] <PL_URL>
```

- `-c` is accepted before or after the URL.
- When present, `--cookies-from-browser chrome` is appended to the
  underlying `yt-dlp` invocation. Without `-c`, behaviour is unchanged.
- The browser is hardcoded to `chrome` (YAGNI — parameterize only if a
  real need appears).
- `show_usage` lines are updated to the `[-c]` form, with a short note
  that `-c` uses Chrome cookies.

## Implementation

- Add a `parse_args` helper **inside `yt_dlp_wrapper.sh`** (it is
  yt-dlp-specific, so it does not belong in `utils/`). It loops over the
  sub-command arguments:
  - `-c` → enable cookies;
  - any other `-*` token → unknown option, print usage to stderr,
    return 1;
  - first bare token → URL; a second bare token → usage error;
  - no URL at all → usage error.
- Results are exposed as two globals set by `parse_args`:
  - `PARSED_URL` — the URL string;
  - `PARSED_COOKIES` — an array, either empty or
    `(--cookies-from-browser chrome)`.
- Each sub-command becomes:
  `parse_args "<usage line>" "$@" || return 1`, then appends
  `${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}` to its `yt-dlp` call.
  The `${arr[@]+...}` idiom keeps `set -u` safe on bash versions where
  expanding an empty array trips `nounset` (macOS system bash 3.2).
- `require_args` is no longer used by this wrapper (parse_args subsumes
  the count check) but stays in `utils/cli.sh` — other scripts and
  `tests/cli.bats` still use it.
- Everything stays shellcheck-clean under the repo's `.shellcheckrc`.

## Testing — `tests/yt_dlp_wrapper.bats` (new)

Stub strategy: `setup()` creates a temp dir containing a fake `yt-dlp`
executable that echoes its arguments (`echo "yt-dlp $*"`), prepends it
to `PATH`, and each test executes the real wrapper script, asserting on
the echoed command line and exit status.

| # | Case | Expectation |
|---|------|-------------|
| 1 | `mp4 <URL>` | `-i <URL> -S vcodec:h264,res,acodec:m4a`, no cookies flag (behaviour unchanged) |
| 2 | `mp4 -c <URL>` | command line contains `--cookies-from-browser chrome` |
| 3 | `mp4 <URL> -c` | same as #2 (flag position free) |
| 4 | `m4a -c <URL>` | cookies flag present, `-f ba[ext=m4a]` intact |
| 5 | `playlist -c <URL>` | cookies flag present, `-o` playlist template intact |
| 6 | `mp4` (no args) | exit 1, usage on stderr |
| 7 | `mp4 <URL1> <URL2>` | exit 1, usage on stderr |
| 8 | `mp4 -x <URL>` | exit 1, usage on stderr (unknown option) |

Existing suites (`cli.bats`, `check.bats`, `blockchain.bats`) must keep
passing via `./run-tests.sh`.

## Documentation

- Update the `yt_dlp_wrapper.sh` section of `README.md`: `[-c]` in the
  usage block plus a one-liner explaining it borrows Chrome's YouTube
  login (on macOS the first run pops a Keychain consent dialog).

## Out of scope

- Browser parameterization (`-c safari` etc.).
- Generic pass-through of arbitrary yt-dlp arguments.
- Changes to other wrappers.

## Commits

English, conventional-commit style, one logical change per commit; no AI
attribution or session links. Exact split is defined in the
implementation plan (tests land with the feature per TDD; README update
may be a separate `docs:` commit).
