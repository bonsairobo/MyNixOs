#!/bin/sh

SSID=$(iw dev wlp4s0 link | awk '/SSID/{print $2}')

echo $SSID # full text
echo $SSID # short text
echo "#00FF00" # color
