require read_confirm

function devdiff
	set -l target_remote origin
  set -l target_branch develop
  git fetch --prune --tags $target_remote
  sleep 3
  git log --pretty=oneline $target_branch..$target_remote/$target_branch
  git diff $target_branch..$target_remote/$target_branch

  if read_confirm
    git pull --rebase $target_remote $target_branch
  end
end
