# Compare git merges in different git implementations

Used to test if different git implementations using the same 
merge strategy on the same commits produce different results
 
**For every git implementation**
 - clones repo (using vanilla git)
 - creates a list of all merges in the repo with two parents (using vanilla git)
  - creates a branch for first parent of each existing merge (using vanilla git)
     
     The branch name is `<MERGE-COMMIT-ID>-<FIRST-PARENT-ID>-<SECOND-PARENT-ID>`
  - replays each merge (+ merge commit) by merging second parent into created branch (using one of the available git implementations)
  - generates tree after merge commit (using vanilla git)
  - stores it `<TREE HASH> <BRANCH NAME>` to `*.merges` log file 

  *Note: If a merge commit was aborted (due to e.g. conflicts) the according line in the `.merges` file contains `SKIPPED`*

## Used git implementations

 - [vanilla git](https://git-scm.com/)
 - [pygit2](http://www.pygit2.org/) - Python binding for libkit2
 - [rugged](https://github.com/SamyPesse/gitkit-js) - Ruby binding for libkit2

  *Note: Make sure to have above installed. They are available on apt-get or brew, gem and pip.*

## Usage
  ```shell
  $ ./merge_replayer.sh <clonable-repo-path> [vanilla | pygit | rugged]
  ```

