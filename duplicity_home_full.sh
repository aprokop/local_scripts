duplicity full --tempdir /mnt/backup/tmp --archive-dir /mnt/backup/cache -v5 \
        --allow-source-mismatch \
	--exclude "/home/prok/.rtorrents/downloads" \
	--exclude "/home/prok/.downloads" \
	--exclude "/home/prok/.opera/cache4" \
	--exclude "/home/prok/.opera/cache" \
	--exclude "/home/prok/.cache" \
	--exclude "/home/prok/.trash" \
	--exclude "/home/prok/.local/share/Trash" \
	--exclude "/home/prok/Manga" \
	--exclude "/home/prok/Music" \
	--exclude "/home/prok/Video" \
	--exclude "/home/prok/Media" \
	--exclude "/home/prok/Games" \
	/home/ file:///mnt/backup/home/
