#!/bin/bash
. commit_utils.sh
repo=$1
export GIT_DIR=${repo}/.git
git rev-list --parents --merges HEAD

