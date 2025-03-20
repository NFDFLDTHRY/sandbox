#!/usr/bin/fish

# scratch.fish: Sets up a project and syncs it with GitHub, ensuring changes are committed

set project_dir (pwd)

# Check for optional repo URL and target directory
if test (count $argv) -eq 2
    set repo_url $argv[1]
    set target_dir $argv[2]
    ./clone_repo.fish $repo_url $target_dir
    if test $status -ne 0
        echo "Error: Cloning failed."
        exit 1
    end
    set project_dir $target_dir
end

# Check if we're in a Git repository
if not test -d "$project_dir/.git"
    echo "Error: No Git repository found in $project_dir. Run with repo URL to clone one."
    exit 1
end

# Apply tools to the project_dir
echo "Setting up tools for $project_dir..."

# Create or update setup_env.fish
echo "#!/usr/bin/fish
if test (count \$argv) -lt 1
    echo 'Usage: ./setup_env.fish <target_dir>'
    exit 1
end
set target_dir \$argv[1]
cd \$target_dir
echo \"Setting up development environment in \$target_dir...\"
echo 'Environment setup complete.'" > "$project_dir/setup_env.fish"
chmod +x "$project_dir/setup_env.fish"

# Create or update update_source.fish
echo "#!/usr/bin/fish
if test (count \$argv) -lt 1
    echo 'Usage: ./update_source.fish <target_dir>'
    exit 1
end
set target_dir \$argv[1]
cd \$target_dir
echo \"Updating source code in \$target_dir...\"
# Placeholder for future updates
echo 'Source code updated.'" > "$project_dir/update_source.fish"
chmod +x "$project_dir/update_source.fish"

# Create or update github_sync.fish
echo "#!/usr/bin/fish
if test (count \$argv) -lt 1
    echo 'Usage: ./github_sync.fish <target_dir>'
    exit 1
end
set target_dir \$argv[1]
cd \$target_dir
echo 'Syncing with GitHub...'
echo 'Enter your GitHub username:'
read -P 'Username: ' github_user
echo 'Enter your GitHub PAT:'
read -s -P 'PAT: ' github_pat
set github_user (string trim \$github_user)
set github_pat (string trim \$github_pat)
set repo_url \"https://\$github_user:\$github_pat@github.com/NFDFLDTHRY/sandbox.git\"
git remote set-url origin \$repo_url 2>/dev/null; or git remote add origin \$repo_url
git push -u origin master
if test \$status -ne 0
    echo 'Error: Failed to push to GitHub. Check credentials or network.'
    exit 1
end
echo 'GitHub sync complete.'" > "$project_dir/github_sync.fish"
chmod +x "$project_dir/github_sync.fish"

# Run setup scripts
echo "Running setup scripts..."
"$project_dir/setup_env.fish" "$project_dir"
if test $status -ne 0
    echo "Error: setup_env.fish failed."
    exit 1
end

"$project_dir/update_source.fish" "$project_dir"
if test $status -ne 0
    echo "Error: update_source.fish failed."
    exit 1
end

# Set Git identity if not configured
if not git config --global user.email
    echo "Setting Git user identity..."
    git config --global user.email "nfdfldthry@example.com"
    git config --global user.name "NFDFLDTHRY"
end

# Stage and commit all changes (including github_sync.fish)
echo "Staging and committing changes..."
cd $project_dir
git add .
if git status | grep -q "Changes to be committed"
    git commit -m "Update project files"
else
    echo "No changes to commit."
end

# Sync with GitHub
"$project_dir/github_sync.fish" "$project_dir"
if test $status -ne 0
    echo "Error: github_sync.fish failed."
    exit 1
end

echo "Setup complete for $project_dir."