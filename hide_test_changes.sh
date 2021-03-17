#!/bin/bash
. ./targets.sh

# Make all of the test output files invisible to git
git update-index --assume-unchanged `git status -s $TGTS | sed 's/^[[:space:]]*[^[:space:]]*[[:space:]]*//'`
