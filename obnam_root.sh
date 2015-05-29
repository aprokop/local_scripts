#!/bin/bash
#obnam force-lock \
obnam backup \
        --one-file-system \
	--log-level=warning \
	--exclude "/dev" \
	--exclude "/home" \
	--exclude "/media" \
	--exclude "/mnt" \
	--exclude "/proc" \
	--exclude "/root/.ccache" \
	--exclude "/usr/portage/distfiles" \
	--exclude "/sys" \
	--exclude "/tmp" \
	--exclude "/var/log" \
	--exclude "/var/tmp" \
	\
	/
