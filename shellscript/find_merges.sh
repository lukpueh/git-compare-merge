#!/bin/bash
. commit_utils.sh
repo=$1
export GIT_DIR=${repo}/.git
# Lists merge commit id and parents in reverse chronological order
# MERGE-COMMIT-ID PARENT PARENT ...
git rev-list --parents --merges HEAD

