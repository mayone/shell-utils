#!/bin/sh
#
# Setup DNS config on WSL (superuser access required).

# Variables
WSL_CONFIG="/etc/wsl.conf"
DNS_CONFIG="/etc/resolv.conf"

FALLBACK_DNS=""
GOOGLE_PUBLIC_DNS_A="8.8.8.8"
GOOGLE_PUBLIC_DNS_B="8.8.4.4"

main() {
  update_wsl_config
  update_dns_config $@
}

update_wsl_config() {
  echo "[network]" > $WSL_CONFIG
  echo "generateResolvConf = false" >> $WSL_CONFIG
}

update_dns_config() {
  if check_exist $DNS_CONFIG; then
    chattr -i $DNS_CONFIG
    rm $DNS_CONFIG
  fi

  for dns in "$@"; do
    add_dns "$dns"
  done

  if [ "$FALLBACK_DNS" != "" ]; then
    add_dns $FALLBACK_DNS
  fi

  printf "\n" >> $DNS_CONFIG

  echo "# Google Public DNS" >> $DNS_CONFIG
  add_dns $GOOGLE_PUBLIC_DNS_A
  add_dns $GOOGLE_PUBLIC_DNS_B

  if check_exist $DNS_CONFIG; then
    # Make the file immutable (-i to make it mutable)
    chattr +i $DNS_CONFIG
  fi
}

add_dns() {
  if [ "$#" != 1 ]; then
    return
  fi
  echo "nameserver $1" >> $DNS_CONFIG
}

#
# Utils
#

check_exist() {
  test -e "$1" >/dev/null 2>&1
}

main "$@"