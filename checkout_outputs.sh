#!/bin/bash
# checkout (update) all of the outputs to revert to what is on github

git checkout docs
ls linkml_model | grep -v model | xargs git checkout
