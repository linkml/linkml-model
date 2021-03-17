#!/bin/bash
# checkout (update) all of the outputs to revert to what is on github
. ./targets.sh
git checkout $TGTS
