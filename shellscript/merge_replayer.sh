#!/bin/bash

# include our functions
. commit_utils.sh

# We assume this is a path in the CWD
REPO_TO_CLONE=$1

# We assume there's a tool called $2.sh
# that takes the parent commit names and performs the merge
TOOL_FOR_REPLAY=$2

# the merge list can be obtained using the find_merges.sh script
MERGE_LIST=$3

TARGET_REPO="${REPO_TO_CLONE}-${TOOL_FOR_REPLAY}"
MERGE_COMMAND="${TOOL_FOR_REPLAY}.sh" 

# clone with vanilla (this is not a contentious step)
git clone $REPO_TO_CLONE $TARGET_REPO

# we set our namespace to the new repository
export GIT_DIR=${TARGET_REPO}/.git
export GIT_WORK_TREE=${TARGET_REPO}

cp empty-config ${TARGET_REPO}/.git/config

# target logfile
TARGET_LOGFILE=${TARGET_REPO}.merges

while read line
do
    echo ${line}
    branch_name=$(echo ${line} | sed "s/ /-/g")
    all_parents=$(echo ${line} | sed "s/^.*\ //")
    first_parent=$(echo ${line} | cut -d ' ' -f 2)
    other_parents=$(echo ${all_parents} | sed "s/^.&\ //")
    git checkout -q -f ${first_parent}
    git checkout -q -b merges/${branch_name}
    ./${MERGE_COMMAND} ${other_parents}
    echo ${branch_name}

    this_tree=$(get_tree)
    this_parents=$(get_parents)
    
    echo ${this_parents}
    echo ${all_parents}

    set -x
    if [ "${all_parents}" != "${this_parents}" ]
    then
        echo "Parents are not equal! ${all_parents} != ${this_parents}"
    fi
    set +x

    echo $this_tree ${all_parents} >> $TARGET_LOGFILE

done < ${MERGE_LIST}
