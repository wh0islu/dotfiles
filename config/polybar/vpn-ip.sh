#!/usr/bin/env bash

set -euo pipefail

ip -o -4 addr show up scope global 2>/dev/null | awk '
    function is_vpn(name) {
        sub(/@.*/, "", name)
        return name ~ /^(wg[[:alnum:]_.-]*|tun[[:alnum:]_.-]*|tap[[:alnum:]_.-]*|tailscale[[:alnum:]_.-]*|nordlynx|proton[[:alnum:]_.-]*|mullvad[[:alnum:]_.-]*|vpn[[:alnum:]_.-]*|zt[[:alnum:]_.-]*)$/
    }

    is_vpn($2) {
        split($4, address, "/")
        if (address[1] != "") {
            print "󰖂 " address[1]
            found = 1
            exit
        }
    }

    END {
        if (!found) {
            print ""
        }
    }
'
