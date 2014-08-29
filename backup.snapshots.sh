#!/bin/bash -x
# ----------------------------------------------------------------------
# Jak's handy rotating-filesystem-snapshot utility
# Copied and modified from:
# http://www.mikerubel.org/computers/rsync_snapshots/
# ----------------------------------------------------------------------
# rotating backup-snapshots whenever called
# ----------------------------------------------------------------------

unset PATH	# avoid accidental use of $PATH

# ------------- system commands used by this script --------------------
ID=/usr/bin/id;
ECHO=/bin/echo;
RM=/bin/rm;
MV=/bin/mv;
CP=/bin/cp;
TOUCH=/bin/touch;
RSYNC=/usr/bin/rsync;

# ------directory names and labels associated with snapshot frequency
USERNAME=aprokop
HOME_DIR=/home/$USERNAME
FREQ=$1
NAME=$USERNAME.$FREQ

# ------------- file locations -----------------------------------------
SNAPSHOT_RW=$HOME_DIR/.backup
EXCLUDES=$HOME_DIR/.backup.exclude;

# ------------- the script itself --------------------------------------

# make sure we're running as root
if (( `$ID -u` != 0 )); then { $ECHO "Sorry, must be root.  Exiting..."; exit; } fi

# rotating snapshots
# Script creates 6 incremental back-ups
# From newest to oldest backups names:
# 	$NAME
# 	$NAME.1
# 	$NAME.2
# 	$NAME.3
# 	$NAME.4
# 	$NAME.5

# step 0
# Delete oldest snapshot
if [ -d $SNAPSHOT_RW/$NAME.5 ]; then
    $RM -rf $SNAPSHOT_RW/$NAME.5
fi;

# step 1
# shift middle snapshots by one increment
n=4
for i in 4 3 2 1; do
    DEST=$NAME.$((n+1))
    SRC=$NAME.$n
    if [ -d $SNAPSHOT_RW/$SRC ] ; then			\
        $MV $SNAPSHOT_RW/$SRC $SNAPSHOT_RW/$DEST ;	\
    fi;
    (( n -= 1))
done

# step 2: make a hard-link-only (except for dirs) copy of the latest snapshot,
# if that exists
if [ -d $SNAPSHOT_RW/$NAME ] ; then
    $CP -al $SNAPSHOT_RW/$NAME $SNAPSHOT_RW/$NAME.1 ;
fi;

# step 3: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!
$RSYNC					\
    -va --delete --delete-excluded	\
    --exclude-from="$EXCLUDES"		\
    $HOME_DIR $SNAPSHOT_RW/$NAME ;

# step 4: update the mtime to reflect the snapshot time
$TOUCH $SNAPSHOT_RW/$NAME ;
