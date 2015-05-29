duplicity --full-if-older-than 2M  --tempdir /mnt/backup/tmp --archive-dir /mnt/backup/cache -v5  \
        --allow-source-mismatch \
	--exclude "/mnt/" \
	--exclude "/usr/portage/distfiles" \
	--exclude "/root/.ccache/" \
	--exclude "/var/log" \
	--exclude "/var/tmp" \
	--exclude "/media" \
	--exclude "/sys" \
	--exclude "/dev" \
	--exclude "/proc" \
	--exclude "/tmp/" \
	--exclude "/home/prok" \
	/ file:///mnt/backup/root/
