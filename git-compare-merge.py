import os
import argparse
import time
import pygit2

# Constants
# Commit message should be the same in every commit
COMMIT_MESSAGE = "This is a commit message"

# Local git repo dirs are timestamped to support multiple runs
REPO_LIBGIT = "repo_libgit" + str(time.time()).replace(".", "")


def main():

  # Parse arguments
  parser = argparse.ArgumentParser(
      description="Clones repo and merges commits using different " +\
      "git implementations", usage="python %s <repository-to-clone> " +\
      "<commit-id> <commit-id> " % (os.path.basename(__file__), ))

  parser.add_argument("repo", type=str, nargs=1,
      help="Git cloneable url")
  parser.add_argument("commits", type=str, nargs="*", 
      help="Two or more git commit ids")

  args = parser.parse_args()

  if len(args.commits) != 2:
    parser.error("You need to pass two commit id's")
  
  # More descriptive names for repo
  repo_url = args.repo[0]  
  commit_a = args.commits[0]
  commit_b = args.commits[1]

  
  #################################################

  ##### Libgit2 (using pygit2)
  # Create a timestamped target dir to clone into
  os.makedirs(REPO_LIBGIT)
  # Clone
  repo = pygit2.clone_repository(repo_url, REPO_LIBGIT)
  # Merge
  index = repo.merge_commits(commit_a, commit_b)
  # Write tree and commit
  tree = repo.index.write_tree()
  user = repo.default_signature
  new_commit = repo.create_commit("refs/heads/master", user, user, 
    COMMIT_MESSAGE, tree, [commit_a, commit_b])


  ##### Vanilla git
  # Do do do, probably with subprocess.popen

  ##### gitkit-js
  # Do do do

  
  # Compare all the repos
  


if __name__ == '__main__':
  main()