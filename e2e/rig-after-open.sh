#!/bin/sh
# Open the settings surface after the live panel is up so a Buzz render
# (and any owner-runnable capture) shows the new UI, not only the game panel.
# Invoked by scripts/rig-render.sh when this file is present and executable.
set -eu
: "${MOD:?}"
qs -p /root/omarchy/shell ipc call "$MOD" settings
