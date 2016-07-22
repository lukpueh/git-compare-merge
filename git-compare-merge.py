import os, argparse

def main():
  """ Parse arguments and start program """

  parser = argparse.ArgumentParser(
      description="Clones repo and merges commits using different git implementations",
      usage="python %s <repository-to-clone> <commit-id> <commit-id> ..." %
      (os.path.basename(__file__), ))

  parser.add_argument("repo", type=str, nargs=1,
      help="Git cloneable url")
  parser.add_argument("commits", type=str, nargs="*", 
      help="Two or more git commit ids")

  args = parser.parse_args()




if __name__ == '__main__':
  main()