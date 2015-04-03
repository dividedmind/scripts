#!/bin/bash

# Executes hooks on KDE plasma activity changes
#
# Hooks go into ~/.local/share/activity-watch/<activity uuid>/{in,out}

SCRIPTS=~/.local/share/activity-watch

get_uuid() {
  grep 'string.*-' | sed -e 's/.*"\(.*\)"/\1/'
}

current_activity=`dbus-send --print-reply --dest=org.kde.ActivityManager \
  /ActivityManager/Activities org.kde.ActivityManager.Activities.CurrentActivity | get_uuid`

dbus-monitor --session "type=signal,interface='org.kde.ActivityManager.Activities',member='CurrentActivityChanged'" |
while read line; do
  uuid=`echo $line | get_uuid`
  [ -z "$uuid" ] && continue

  echo Leaving activity $current_activity >&2
  for f in "$SCRIPTS/$current_activity/out"/*; do
    [ -x "$f" ] && "$f" || :
  done

  echo Entering activity $uuid >&2
  for f in "$SCRIPTS/$uuid/in"/*; do
    [ -x "$f" ] && "$f" || :
  done

  current_activity=$uuid
done
