#!/bin/bash
# Make all of the test output changes visible to git
. ./targets.sh
git update-index --no-assume-unchanged `echo $TGTS | sed 's/ /\/ /g'`/
