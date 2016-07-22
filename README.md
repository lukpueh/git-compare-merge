# Compare git merges using different git implementation

 - Creates a new directory with timestamp
 - For every git implementation 
    - clones repo (passed as argument) in subdirectory
    - merges commits (passed as argument)
    - commits merges
 - Compares git clones of timestamp directory
 
## Used git implementations
   - [libgit2](http://www.pygit2.org/)
   - [gitkit-js](https://github.com/SamyPesse/gitkit-js)

## Usage
  - python git-compare-merge <repository-to-clone> <commit-id>{2..*}
  


  