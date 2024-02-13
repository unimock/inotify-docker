#!/bin/sh

#
# Script options (exit script on command fail).
#
set -e

_EVENTS="create,delete,modify,move"
_OPTIONS='--monitor'
_COMMAND='echo'
#
# Display settings on standard out.
#
echo "inotify settings"
echo "================"
echo
echo "  Volumes:          ${VOLUMES}"
echo "  Inotify_Events:   ${EVENTS:=${_EVENTS}}"
echo "  Inotify_Options:  ${OPTIONS:=${_OPTIONS}}"
echo "  Inotify_Command:  ${COMMAND:=${_COMMAND}}"


#
# Inotify part.
#

echo "[Starting: inotifywait ${EVENTS} ${OPTIONS} ${VOLUMES} ]"

inotifywait -r -e ${EVENTS} ${OPTIONS} ${VOLUMES} | \
while read -r notifies ; do
  #echo "$notifies"
  echo "calling: ${COMMAND} $notifies"
  ${COMMAND} $notifies
done



