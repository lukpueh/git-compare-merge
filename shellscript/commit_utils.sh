#!/usr/bin/env bash

function blobs_in_commit() {
    res=$(git ls-tree -r $1 | cut -d " " -f 3 | sed 's/\t.*/\n/g' | sort -u)
    echo $res | sed 's/ /\n/g'
}

function commits_in_parents() {
    parent1=$1
    parent2=$2
    commits_in_parent1=$(blobs_in_commit $parent1)
    commits_in_parent2=$(blobs_in_commit $parent2)
    echo $commits_in_parent1 $commits_in_parent2 | sed 's/ /\n/g' | sort -u
}

check_merge_commit() { 
    commits_in_parents $1 $2 >  parent.tmp
    blobs_in_commit $3 > child.tmp
    diff -y child.tmp parent.tmp
}

get_parents(){
    commit=$1
    git show --format=%P $commit
}

function try_merges() {
    for commit in $(git log --first-parent --merges --oneline | cut -d ' ' -f 1)
    do
        parents=$(get_parents $commit)
        res=$(check_merge_commit $parents $commit | grep "<" | wc -w) 
        if [ $res -ne 0 ]
        then
            git cat-file -p $commit
        fi
    done
}

get_tree() {
    git log --pretty=%T -1 $1
}

get_parents() {
    git log --pretty=%P -1 $1
}
