#!/usr/bin/fish
if test (count $argv) -lt 1
    echo 'Usage: ./create_project.fish <project_name>'
    exit 1
end
set project_name $argv[1]
set projs_dir "/home/cd/projs/SB/projs"
set target_dir "$projs_dir/$project_name"
if test -d "$target_dir"
    echo "Error: Project $project_name already exists at $target_dir."
    exit 1
end
echo "Creating new project $project_name at $target_dir..."
mkdir -p "$target_dir"
echo "# Project $project_name" > "$target_dir/README.md"
cd $projs_dir
git add "$project_name"
echo "Project $project_name created and staged for commit."
