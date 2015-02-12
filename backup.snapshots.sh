#!/bin/bash -x
# ----------------------------------------------------------------------
# Jak's handy rotating-filesystem-snapshot utility
# Copied and modified from:
# http://www.mikerubel.org/computers/rsync_snapshots/
# ----------------------------------------------------------------------
# rotating backup-snapshots whenever called
# ----------------------------------------------------------------------

unset PATH	# avoid accidental use of $PATH

n=4

# ------------- system commands used by this script --------------------
CP=/bin/cp
ECHO=/bin/echo
ID=/usr/bin/id
MV=/bin/mv
RM=/bin/rm
RSYNC=/usr/bin/rsync
SEQ=/usr/bin/seq
TOUCH=/bin/touch

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
#   $NAME
#   $NAME.1
#   $NAME.2
#   $NAME.3
#   $NAME.4
#   $NAME.5

# step 1
# shift middle snapshots by one increment, recycle oldest
if [ -d $SNAPSHOT_RW/$NAME.$((n+1)) ]; then
    $MV $SNAPSHOT_RW/$NAME.$((n+1)) $SNAPSHOT_RW/$NAME.tmp
fi
for i in `$SEQ $n -1 0`; do
    SRC=$NAME.$i
    DEST=$NAME.$((i+1))
    if [ -d $SNAPSHOT_RW/$SRC ] ; then
        $MV $SNAPSHOT_RW/$SRC $SNAPSHOT_RW/$DEST
    fi
done
if [ -d $SNAPSHOT_RW/$NAME.tmp ]; then
    $MV $SNAPSHOT_RW/$NAME.tmp $SNAPSHOT_RW/$NAME.0
fi

# step 2
# make a hard-link-only (except for dirs) copy of the latest snapshot, if that
# exists
if [ -d $SNAPSHOT_RW/$NAME.1 ] ; then
    $CP -alf $SNAPSHOT_RW/$NAME.1/. $SNAPSHOT_RW/$NAME.0
fi

# step 3
# rsync from the system into the latest snapshot (notice that rsync behaves
# like cp --remove-destination by default, so the destination is unlinked
# first.  If it were not so, this would copy over the other snapshot(s) too!
# --ignore-erros allows to delete even when encountering IO errors
$RSYNC                              \
    --ignore-errors                 \
    -va --delete --delete-excluded  \
    --exclude-from="$EXCLUDES"      \
    $HOME_DIR $SNAPSHOT_RW/$NAME.0

# step 4: update the mtime to reflect the snapshot time
$TOUCH $SNAPSHOT_RW/$NAME.0
