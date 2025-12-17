#!/bin/bash

set -e

PSK_PREFIX="^\s+psk="

PSK=$(wpa_passphrase cap17 "$1" | grep -P ${PSK_PREFIX} | sed -E "s/(${PSK_PREFIX})(.+)/\2/1")

echo 'ff:ff:ff:ff:ff:ff '${PSK} > hostapd.wpa_psk
