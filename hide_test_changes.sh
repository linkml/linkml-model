#!/bin/bash

# Make all of the test output files invisible to git
echo git update-index --assume-unchanged `git status -s docs | sed 's/^[[:space:]]*[^[:space:]]*[[:space:]]*//'`
echo git update-index --assume-unchanged `git status -s linkml_model | sed 's/^[[:space:]]*[^[:space:]]*[[:space:]]*//' | grep -v \/model\/`
