#!/bin/bash

########
# Usage:
# ./merge_replayer.sh <clonable-repo-path> pygit | vanilla | rugged [<start-commit-id>]
#
# Replays the last 100 merge commits of <cloneable-repo-path>
#
# If <start-commit-id> is specified, than it replays the last 100 merge commits
# before that commit
#
# Example:
# ./merge_replayer.sh git@github.com:git/git.git vanilla f8f7adce9fc50a11a764d57815602dcb818d1816 
#
# Note: Requires git, libgit2, pygit2 and rugged installed and on the path
########

# include our functions
. commit_utils.sh

usage() {
    echo "USAGE: $0 <clonable-repo-path> vanilla | pygit | rugged [start-commit]"
    exit $1
}




if [ $# -lt 2  ]
then
    usage 1
fi

# Local or remote (ssh or https) clonable repo URL
REPO_TO_CLONE=$1

# One of vanilla, rugged or pygit
TOOL_FOR_REPLAY=$2

if [ $# -eq 3  ]
then
    START_COMMIT=$3
else
    START_COMMIT="HEAD"
fi

# Extract the basename from a git cloneable URL and create local repo name
REPO_BASENAME="$(basename -s .git $REPO_TO_CLONE)"
TARGET_REPO="${REPO_BASENAME}-${TOOL_FOR_REPLAY}"

if [ "${TOOL_FOR_REPLAY}" == "vanilla" ]
then
    MERGE_COMMAND="git merge --no-ff -m 'commit'"
elif [ "${TOOL_FOR_REPLAY}" == "pygit" ]
then
    MERGE_COMMAND="python pygit.py"
elif [ "${TOOL_FOR_REPLAY}" == "rugged" ]
then
    MERGE_COMMAND="ruby rugged.rb"
else
    usage 2
fi 

# clone with vanilla (this is not a contentious step)
git clone $REPO_TO_CLONE $TARGET_REPO

# we set our namespace to the new repository
export GIT_DIR=${TARGET_REPO}/.git
export GIT_WORK_TREE=${TARGET_REPO}

cp empty-config ${TARGET_REPO}/.git/config

# target logfile
TARGET_LOGFILE=${TARGET_REPO}.merges

counter=0
while read line
do
    counter=$((counter+1))
    if [[ "$counter" -gt 100 ]]; 
    then
        exit 0
    fi
    # Line is of fomat:
    # MERGE-COMMIT-ID PARENT PARENT ...
    # echo "LINE   $line"

    branch_name=$(echo ${line} | sed "s/ /-/g")
    first_parent=$(echo ${line} | cut -d ' ' -f 2)
    second_parent=$(echo ${line} | cut -d ' ' -f 3)
    parents=$(echo ${line} | cut -d ' ' -f 2,3)

    # Checkout first parent of merge-to-replay
    git checkout -f ${first_parent}

    # Create new branch there
    git checkout -f -b merges/${branch_name}

    # Merge other parents of merge-to-replay into that branch
    ${MERGE_COMMAND} ${second_parent}

    if [ $? -ne 0 ]
    then
        echo "SKIPPED ${branch_name}" >> $TARGET_LOGFILE
        git reset --merge
        continue
    fi

    # echo ${branch_name}

    this_tree=$(get_tree)
    this_parents=$(get_parents)
    
    # echo ${this_parents}
    # echo ${parents}

    # set -x
    if [ "${parents}" != "${this_parents}" ]
    then
        echo "Parents are not equal!"
        # echo "${parents} != ${this_parents}"
    else
        echo "Parents are equal!"
    fi
    # set +x

    echo ${this_tree} ${branch_name} >> $TARGET_LOGFILE

# Read in merge commits we want to replay
done < <(./find_merges.sh $TARGET_REPO $START_COMMIT)
