# Shell-Utilities

A small collection of single-purpose shell utilities and a shared
function library, for macOS / Linux / WSL.

## Layout

```
.
├── utils/                 # Shared functions, sourced via utils/index.sh
│   ├── cli.sh             # print_usage / require_args helpers
│   ├── display.sh         # info / ok / warn / err coloured output
│   ├── check.sh           # check_exist / check_folder / check_cmd / check_os
│   ├── date.sh            # sync_date (Linux only)
│   ├── ip.sh              # get_public_ip / get_private_ip / get_mac_addr
│   ├── blockchain.sh      # 13-chain RPC helpers (refactor pending)
│   └── index.sh           # Sources all of the above
├── tests/                 # bats test suite
├── .shellcheckrc          # Project-wide shellcheck config
├── run-tests.sh           # Convenience runner: bats tests/
└── *.sh                   # Top-level wrappers (below)
```

## Scripts

### `gitconfig.sh`

Switch the global git `user.name` / `user.email` between preset
identities.

```sh
./gitconfig.sh gmail     # mayone <mayone321@gmail.com>
./gitconfig.sh insyde    # wayne jeng <wayne.jeng@insyde.com>
./gitconfig.sh           # show the current identity
```

### `yt_dlp_wrapper.sh`

Thin wrapper around `yt-dlp`.

```sh
./yt_dlp_wrapper.sh mp4 <YT_URL>
./yt_dlp_wrapper.sh m4a <YT_URL>
./yt_dlp_wrapper.sh playlist <PL_URL>
```

### `ffmpeg_wrapper.sh`

Wrapper around `ffmpeg` for common video / audio operations.

```sh
./ffmpeg_wrapper.sh dl <M3U8> <OUT>             # download via M3U8 link
./ffmpeg_wrapper.sh ext <IN_V> <OUT_A>          # extract audio from video
./ffmpeg_wrapper.sh mrg <IN_V> <IN_A> <OUT_V>   # merge video + audio
./ffmpeg_wrapper.sh rev <IN> <OUT>              # reverse video
./ffmpeg_wrapper.sh con <IN_FOLDER> <OUT_V>     # concat .mp4 files
./ffmpeg_wrapper.sh rot <IN> <OUT>              # rotate 90° clockwise
./ffmpeg_wrapper.sh mpeg <IN> <OUT>             # m4a -> mp3
```

Reference: [protrolium/ffmpeg.md](https://gist.github.com/protrolium/e0dbd4bb0f1a396fcb55)

### `png2icns.sh` (macOS)

Convert a PNG file into a macOS `.icns` icon bundle via `sips` and
`iconutil`.

```sh
./png2icns.sh logo.png   # -> logo.icns
```

Reference: [PNG to ICNS Conversion Script and MacOS Automation](https://dustindavis.me/blog/png-to-icns-conversion-script-and-mac-os-automation)

### `wsl_setup_dns.sh` (WSL, root)

Override the WSL-generated `/etc/resolv.conf` with explicit DNS
servers and `chattr +i` it so WSL won't rewrite it on restart.

```sh
sudo ./wsl_setup_dns.sh 1.1.1.1 9.9.9.9
```

### `file.sh`

Library (sourced, not executed) that exposes `backup <path>` — makes a
`.bak` copy of a file or directory.

```sh
source ./file.sh
backup important.conf      # -> important.conf.bak
```

## Conventions

- Shebang: `#!/usr/bin/env bash` (so the script picks up a newer bash
  from `PATH`, e.g. a Homebrew install on macOS).
- Executable scripts enable `set -euo pipefail` (or `set -eo pipefail`
  where strict unset checking is impractical, e.g. `wsl_setup_dns.sh`).
- Shared logic lives in `utils/`; wrappers `source utils/index.sh`
  rather than duplicating helpers.
- Code comments and commit messages are written in English.
  Conventional-commit prefixes (`feat:`, `fix:`, `refactor:`, `chore:`,
  `test:`, `docs:`) with optional scope.

## Running tests

Requires [`bats-core`](https://github.com/bats-core/bats-core):

```sh
brew install bats-core
./run-tests.sh
```

RPC-dependent `blockchain.bats` cases are skipped by default. To run
them against live mainnet endpoints:

```sh
BATS_RUN_NETWORK_TESTS=1 ./run-tests.sh
```

## Running shellcheck

```sh
brew install shellcheck
shellcheck *.sh utils/*.sh tests/*.sh
```

`.shellcheckrc` sets `shell=bash`, `external-sources=true`, and
`source-path=SCRIPTDIR` so `source` directives resolve correctly.
