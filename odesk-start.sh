#!/bin/bash

echo Starting ODesk time tracking... >&2

if xwininfo -name "oDesk Team" > /dev/null; then
  xdotool search --name "oDesk Team" key Ctrl+Alt+Page_Up
else
  nohup odeskteam-qt4 > /dev/null &
fi
