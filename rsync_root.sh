#!/bin/bash
rsync -aAv \
        --one-file-system \
	--delete \
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
	/ rsync_root
