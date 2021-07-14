#!/bin/bash
# Make all of the test output changes visible to git
git ls-files -z docs linkml_model | tr '\n' ' ' | xargs git update-index --no-assume-unchanged

