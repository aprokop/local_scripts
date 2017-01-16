#!/bin/bash
grep -L --null 'annotation' * | xargs -0 rm -f
echo "Removed files without annotations"
