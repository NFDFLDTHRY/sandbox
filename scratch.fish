#!/usr/bin/fish

# Updated scratch.fish to initialize a project-specific repository

echo "Setting up project tools"

set parent_dir (pwd)  # Should be /home/cd/p/SB

# Initialize a new Git repository if one doesn’t exist in /home/cd/p/SB
if not test -d "$parent_dir/.git"
    echo "Initializing Git repository in $parent_dir..."
    git init
end

# Create setup_env.fish
echo "#!/usr/bin/fish
echo 'Setting up development environment...'
# Simulated package checks
if not type -q git
    echo 'Git is not installed. In a real setup, this would install it.'
end
if not type -q fish
    echo 'Fish shell is not installed. In a real setup, this would install it.'
end
echo 'Environment setup complete (simulated).'" > "$parent_dir/setup_env.fish"
chmod +x "$parent_dir/setup_env.fish"

# Create update_source.fish
echo "#!/usr/bin/fish
echo 'Updating source code...'
# Placeholder for future updates" > "$parent_dir/update_source.fish"
chmod +x "$parent_dir/update_source.fish"

# Create github_sync.fish
echo "#!/usr/bin/fish
echo 'Syncing with GitHub...'
echo 'Enter your GitHub username:'
read -P 'Username: ' github_user
echo 'Enter your GitHub Personal Access Token (PAT):'
read -s -P 'PAT: ' github_pat
# Trim any trailing newline from inputs
set github_user (string trim \$github_user)
set github_pat (string trim \$github_pat)
set repo_url \"https://\$github_user:\$github_pat@github.com/NFDFLDTHRY/sandbox.git\"
git remote set-url origin \$repo_url 2>/dev/null; or git remote add origin \$repo_url
git push -u origin master
if test \$status -ne 0
    echo 'Error: Failed to push to GitHub. Check username and PAT.'
    exit 1
end
echo 'GitHub sync complete.'" > "$parent_dir/github_sync.fish"
chmod +x "$parent_dir/github_sync.fish"

# Create or update .gitignore to exclude github_sync.fish
if not test -f "$parent_dir/.gitignore"
    echo "github_sync.fish" > "$parent_dir/.gitignore"
else if not grep -q "github_sync.fish" "$parent_dir/.gitignore"
    echo "github_sync.fish" >> "$parent_dir/.gitignore"
end

# Create README.md if it doesn’t exist
if not test -f "$parent_dir/README.md"
    echo "# Sandbox Repository" > "$parent_dir/README.md"
end

# Run setup scripts
"$parent_dir/setup_env.fish"
if test $status -ne 0
    echo "Error: setup_env.fish failed."
    exit 1
end

"$parent_dir/update_source.fish"
if test $status -ne 0
    echo "Error: update_source.fish failed."
    exit 1
end

# Configure Git identity if not set globally
if not git config --global user.email
    echo "Setting Git user identity..."
    git config --global user.email "nfdfldthry@example.com"
    git config --global user.name "NFDFLDTHRY"
end

# Add and commit project files
echo "Adding and committing project files..."
git add README.md update_source.fish scratch.fish setup_env.fish .gitignore
git commit -m "Initial commit"

# Sync with GitHub
"$parent_dir/github_sync.fish"
if test $status -ne 0
    echo "Error: github_sync.fish failed."
    exit 1
end

echo "Setup complete. Project tools initialized and repository synced."