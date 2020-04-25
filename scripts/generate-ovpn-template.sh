#!/bin/sh -

root=$(git rev-parse --show-toplevel)

if [ ! -e "$1" ]; then
  echo "'$1' not found" >&2
  exit 1
fi

cat $1 | awk -f $root/scripts/ovpn-template.awk > $root/skip #$root/template.ovpn
