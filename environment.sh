#!/bin/sh
export PIPENV_VENV_IN_PROJECT=1
export PATH=.venv/bin:$PATH
export PYTHONPATH=.venv:$PYTHONPATH
if [ "x" != x ] ; then
    PS1="${PS1-}"
else
    PS1="(environment: .venv) ${PS1-}"
fi
export PS1
