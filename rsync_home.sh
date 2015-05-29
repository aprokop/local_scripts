#!/bin/bash
rsync -aAv \
        --one-file-system \
	--exclude "/home/prok/.downloads" \
	--exclude "/home/prok/.opera/cache4" \
	--exclude "/home/prok/.opera/cache" \
	--exclude "/home/prok/.mozilla/firefox/gc77gfyi.default/Cache/" \
	--exclude "/home/prok/.cache" \
	--exclude "/home/prok/.trash" \
	--exclude "/home/prok/.local/share/Trash" \
	\
	/home/ rsync_home
