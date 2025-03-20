#!/usr/bin/fish

# scratch.fish: Sets up a project and syncs it with GitHub, ensuring all tools are committed

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
echo "#!/usr/bin/fish" > "$project_dir/setup_env.fish"
echo "if test (count \$argv) -lt 1" >> "$project_dir/setup_env.fish"
echo "    echo 'Usage: ./setup_env.fish <target_dir>'" >> "$project_dir/setup_env.fish"
echo "    exit 1" >> "$project_dir/setup_env.fish"
echo "end" >> "$project_dir/setup_env.fish"
echo "set target_dir \$argv[1]" >> "$project_dir/setup_env.fish"
echo "cd \$target_dir" >> "$project_dir/setup_env.fish"
echo "echo \"Setting up development environment in \$target_dir...\"" >> "$project_dir/setup_env.fish"
echo "echo 'Environment setup complete.'" >> "$project_dir/setup_env.fish"
chmod +x "$project_dir/setup_env.fish"

# Create or update update_source.fish
echo "#!/usr/bin/fish" > "$project_dir/update_source.fish"
echo "if test (count \$argv) -lt 1" >> "$project_dir/update_source.fish"
echo "    echo 'Usage: ./update_source.fish <target_dir>'" >> "$project_dir/update_source.fish"
echo "    exit 1" >> "$project_dir/update_source.fish"
echo "end" >> "$project_dir/update_source.fish"
echo "set target_dir \$argv[1]" >> "$project_dir/update_source.fish"
echo "cd \$target_dir" >> "$project_dir/update_source.fish"
echo "echo \"Updating source code in \$target_dir...\"" >> "$project_dir/update_source.fish"
echo "# Placeholder for future updates" >> "$project_dir/update_source.fish"
echo "echo 'Source code updated.'" >> "$project_dir/update_source.fish"
chmod +x "$project_dir/update_source.fish"

# Create or update github_sync.fish
echo "#!/usr/bin/fish" > "$project_dir/github_sync.fish"
echo "if test (count \$argv) -lt 1" >> "$project_dir/github_sync.fish"
echo "    echo 'Usage: ./github_sync.fish <target_dir>'" >> "$project_dir/github_sync.fish"
echo "    exit 1" >> "$project_dir/github_sync.fish"
echo "end" >> "$project_dir/github_sync.fish"
echo "set target_dir \$argv[1]" >> "$project_dir/github_sync.fish"
echo "cd \$target_dir" >> "$project_dir/github_sync.fish"
echo "echo 'Syncing with GitHub...'" >> "$project_dir/github_sync.fish"
echo "echo 'Enter your GitHub username:'" >> "$project_dir/github_sync.fish"
echo "read -P 'Username: ' github_user" >> "$project_dir/github_sync.fish"
echo "echo 'Enter your GitHub PAT:'" >> "$project_dir/github_sync.fish"
echo "read -s -P 'PAT: ' github_pat" >> "$project_dir/github_sync.fish"
echo "set github_user (string trim \$github_user)" >> "$project_dir/github_sync.fish"
echo "set github_pat (string trim \$github_pat)" >> "$project_dir/github_sync.fish"
echo "set repo_url \"https://\$github_user:\$github_pat@github.com/NFDFLDTHRY/sandbox.git\"" >> "$project_dir/github_sync.fish"
echo "git remote set-url origin \$repo_url 2>/dev/null; or git remote add origin \$repo_url" >> "$project_dir/github_sync.fish"
echo "git push -u origin master" >> "$project_dir/github_sync.fish"
echo "if test \$status -ne 0" >> "$project_dir/github_sync.fish"
echo "    echo 'Error: Failed to push to GitHub. Check credentials or network.'" >> "$project_dir/github_sync.fish"
echo "    exit 1" >> "$project_dir/github_sync.fish"
echo "end" >> "$project_dir/github_sync.fish"
echo "echo 'GitHub sync complete.'" >> "$project_dir/github_sync.fish"
chmod +x "$project_dir/github_sync.fish"

# Verify tools exist
for tool in setup_env.fish update_source.fish github_sync.fish
    if not test -f "$project_dir/$tool"
        echo "Error: $tool was not created successfully."
        exit 1
    end
end

# Remove .gitignore to ensure github_sync.fish is not ignored
if test -f "$project_dir/.gitignore"
    echo "Removing .gitignore to include github_sync.fish..."
    git rm "$project_dir/.gitignore"
    git commit -m "Remove .gitignore to include github_sync.fish"
end

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

# Stage and commit all changes explicitly
echo "Staging and committing changes..."
cd $project_dir
git add scratch.fish setup_env.fish update_source.fish github_sync.fish
if git status | grep -q "Changes to be committed"
    git commit -m "Update project files with all tools"
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