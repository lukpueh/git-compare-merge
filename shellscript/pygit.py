import sys
import os
import pygit2

COMMIT_MESSAGE = "commit"


def main(argv):

  if (len(argv) < 2):
    return

  # The git dir is exported as env variable in the calling shell script
  git_dir = os.environ["GIT_DIR"]

  # Pygit2 only accepts two separate commits
  commit_a = argv[0]
  commit_b = argv[1]

  repo = pygit2.Repository(git_dir)

  # Merge returns an index
  index = repo.merge_commits(commit_a, commit_b)

  # Write tree and commit
  # Only works if there aren't any conflicts
  tree = repo.index.write_tree()
  user = repo.default_signature

  new_commit = repo.create_commit("HEAD", user, user, 
    COMMIT_MESSAGE, tree, [commit_a, commit_b])

 
if __name__ == "__main__":
  main(sys.argv[1:])