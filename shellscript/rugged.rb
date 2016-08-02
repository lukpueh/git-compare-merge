require "rugged"

begin
  # The commit id we want to merge to this branch
  commit = ARGV[0]

  # The git dir is exported as env variable in the calling shell script
  git_dir = ENV["GIT_DIR"]

  # Create a new Rugged Repository object from the repo
  repo = Rugged::Repository.new(git_dir)

  # HEAD id of current branch
  head = repo.head.target_id

  # Merge current 
  index = repo.merge_commits(head, commit)

  # Write the tree and commit, only works if there there are no conflicts
  tree = index.write_tree(repo)
  commit_author = { email: "example@example.com", name: "ms. example", time: Time.now }
  Rugged::Commit.create(repo,
    committer: commit_author,
    message: "commit",
    parents: [head, commit], 
    tree: tree,
    update_ref: "HEAD")


rescue Exception => e
  puts e.message
  exit(1)
end
