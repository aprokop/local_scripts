#!/bin/bash
#obnam force-lock \
obnam backup \
        --one-file-system \
	--log-level=warning \
	--exclude "/home/prok/.downloads" \
	--exclude "/home/prok/.opera/cache4" \
	--exclude "/home/prok/.opera/cache" \
	--exclude "/home/prok/.mozilla/firefox/gc77gfyi.default/Cache/" \
	--exclude "/home/prok/.cache" \
	--exclude "/home/prok/.trash" \
	--exclude "/home/prok/.local/share/Trash" \
	--exclude "/home/prok/code/misc/h.dat" \
	\
	/home/
