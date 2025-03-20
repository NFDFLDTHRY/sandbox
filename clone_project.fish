#!/usr/bin/fish
if test (count $argv) -lt 2
    echo 'Usage: ./clone_project.fish <repo_url> <project_name>'
    exit 1
end
set repo_url $argv[1]
set project_name $argv[2]
set projs_dir "/home/cd/projs/SB/projs"
set target_dir "$projs_dir/$project_name"
if test -d "$target_dir"
    echo "Error: Project $project_name already exists at $target_dir."
    exit 1
end
echo "Cloning repository into $target_dir..."
git clone $repo_url "$target_dir"
if test $status -ne 0
    echo 'Error: Failed to clone repository.'
    exit 1
end
# Remove the .git directory to avoid nested repositories
rm -rf "$target_dir/.git"
cd $projs_dir
git add "$project_name"
echo "Project $project_name cloned and staged for commit."
