#!/usr/bin/env bash
set -eu

path="$HOME/.local/share/skk"
mkdir -p "$path"

url="https://skk-dev.github.io/dict"

jisyos=("SKK-JISYO.L.gz" "SKK-JISYO.geo.gz" "SKK-JISYO.jinmei.gz" "SKK-JISYO.propernoun.gz" "SKK-JISYO.station.gz")

for jisyo in ${jisyos[@]}; do
  curl -Lo "${path}/${jisyo}" "${url}/${jisyo}"
done

cd "$path"
gunzip ./*.gz
cd -
