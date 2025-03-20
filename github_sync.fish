#!/usr/bin/fish
if test (count $argv) -lt 1
    echo 'Usage: ./github_sync.fish <target_dir>'
    exit 1
end
set target_dir $argv[1]
cd $target_dir
echo 'Syncing with GitHub...'
echo 'Enter your GitHub username:'
read -P 'Username: ' github_user
echo 'Enter your GitHub PAT:'
read -s -P 'PAT: ' github_pat
set github_user (string trim $github_user)
set github_pat (string trim $github_pat)
set repo_url "https://$github_user:$github_pat@github.com/NFDFLDTHRY/sandbox.git"
git remote set-url origin $repo_url 2>/dev/null; or git remote add origin $repo_url
git push -u origin master
if test $status -ne 0
    echo 'Error: Failed to push to GitHub. Check credentials or network.'
    exit 1
end
echo 'GitHub sync complete.'
