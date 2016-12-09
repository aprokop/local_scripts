#!/bin/bash
grep -L --null 'annotation' * | xargs -0 rm
echo "Removed files without annotations"
