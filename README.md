# Compare git merges in different git implementations

Used to test if different git implementations using the same 
merge strategy on the same commits produce different results

 
 - For every git implementation 
    - creates a new directory with timestamp
    - clones repo (passed as argument) 
    - merges commits (passed as argument)
    - commits merges
 - Compares git clones of timestamped directories
 
## Used git implementations
   - [libgit2](http://www.pygit2.org/)
   - [gitkit-js](https://github.com/SamyPesse/gitkit-js)
   - Vanilla git

## Usage
  ```shell
  python git-compare-merge.py <repository-to-clone> <commit-id-a> <commit-id-b>
  ```
  
## Todo
 - implement clone + merge + commit for gitkit-js
 - implement clone + merge + commit for vanilla git
 - implement comparing

 - support different merge stratagies




  
