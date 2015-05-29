duplicity full --tempdir /mnt/backup/tmp -v5  \
	--exclude "/mnt/" \
	--exclude "/usr/portage/distfiles" \
	--exclude "/root/.ccache/" \
	--exclude "/var/tmp" \
	--exclude "/media" \
	--exclude "/sys" \
	--exclude "/dev" \
	--exclude "/proc" \
	--exclude "/tmp/" \
	--exclude "/home/prok" \
	/ file:///mnt/backup/root/
