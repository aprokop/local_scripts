#!/bin/bash
#
# find_all_modules.sh
#
for i in `find /sys -name modalias -exec cat {} \;`; do
	/sbin/modprobe --config /dev/null --show-depends $i 2>/dev/null;
done | rev | cut -f 1 -d '/' | rev | sort -u
