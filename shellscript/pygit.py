import sys
import os
import pygit2

COMMIT_MESSAGE = "commit"


def main(argv):
  try:
    if (len(argv) != 1):
      print "Wrong amount of args."
      sys.exit(1)

    # The git dir is exported as env variable in the calling shell script
    git_dir = os.environ["GIT_DIR"]

    # Pygit2 only accepts two separate commits
    commit = argv[0]
    repo = pygit2.Repository(git_dir)
    # Merge returns an index
    index = repo.merge(commit)    
    # Write tree and commit
    # Only works if there aren't any conflicts
    tree = repo.index.write_tree()
    user = repo.default_signature     
    new_commit = repo.create_commit("HEAD", user, user, 
      COMMIT_MESSAGE, tree, [repo.head.target, commit])     

  except Exception, e:
    print e
    sys.exit(1)



 
if __name__ == "__main__":
  main(sys.argv[1:])