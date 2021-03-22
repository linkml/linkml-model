#!/bin/bash
# Make all of the test output changes visible to git
. ./targets.sh
git ls-files -z $TGTS | tr '\n' ' ' | xargs git update-index --no-assume-unchanged

