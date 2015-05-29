#!/bin/bash
echo "Started sleep for " $@
sleep $@

pkill smplayer
pkill mplayer
amixer -c0 sset Master,0 100%,100%
# mplayer -shuffle ~/Music/Billie_Holliday/**/*
mplayer -loop 0 ~/misc/music/Christofer_Tin/Calling_All_Dawns/01\ Baba\ Yetu\ \(feat.\ Soweto\ Gospel\ Choir\).flac
