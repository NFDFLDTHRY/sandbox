#!/usr/bin/fish

# scratch.fish: Sets up a project and syncs it with GitHub

echo "Setting up project tools"

set project_dir (pwd)

# Check if we're in the project root
if not test -f "$project_dir/scratch.fish"
    echo "Error: Please run this script from the project root directory."
    exit 1
end

# Initialize Git repository if it doesn’t exist
if not test -d "$project_dir/.git"
    echo "Initializing Git repository in $project_dir..."
    git init
end

# Create or update tools
echo "Creating or updating tools..."

# setup_env.fish: Environment setup
echo "#!/usr/bin/fish
echo 'Setting up development environment...'
if not type -q git
    echo 'Error: Git is not installed. Please install it and try again.'
    exit 1
end
echo 'Environment setup complete.'" > "$project_dir/setup_env.fish"
chmod +x "$project_dir/setup_env.fish"

# update_source.fish: Source code updates (placeholder)
echo "#!/usr/bin/fish
echo 'Updating source code...'
# Add update logic here" > "$project_dir/update_source.fish"
chmod +x "$project_dir/update_source.fish"

# github_sync.fish: GitHub synchronization
echo "#!/usr/bin/fish
echo 'Syncing with GitHub...'
if set -q GITHUB_USER && set -q GITHUB_PAT
    set github_user \$GITHUB_USER
    set github_pat \$GITHUB_PAT
else
    echo 'Enter your GitHub username:'
    read -P 'Username: ' github_user
    echo 'Enter your GitHub PAT:'
    read -s -P 'PAT: ' github_pat
end
set repo_url \"https://\$github_user:\$github_pat@github.com/\$github_user/sandbox.git\"
git remote set-url origin \$repo_url 2>/dev/null; or git remote add origin \$repo_url
git push -u origin master
if test \$status -ne 0
    echo 'Error: Push failed. Check your credentials or network connection.'
    exit 1
end
echo 'GitHub sync complete.'" > "$project_dir/github_sync.fish"
chmod +x "$project_dir/github_sync.fish"

# Manage .gitignore
if not test -f "$project_dir/.gitignore"
    echo "github_sync.fish" > "$project_dir/.gitignore"
else if not grep -q "github_sync.fish" "$project_dir/.gitignore"
    echo "github_sync.fish" >> "$project_dir/.gitignore"
end

# Create or update README.md
if not test -f "$project_dir/README.md"
    echo "# Sandbox Project
A workflow for managing development tools.
## Setup
Run `./scratch.fish` to initialize the project and sync with GitHub." > "$project_dir/README.md"
end

# Run setup scripts
echo "Running setup scripts..."
"$project_dir/setup_env.fish" || begin
    echo "Error: Environment setup failed."
    exit 1
end

"$project_dir/update_source.fish" || begin
    echo "Error: Source update failed."
    exit 1
end

# Set Git identity if not configured
if not git config --global user.email
    echo "Setting Git user identity..."
    git config --global user.email "your-email@example.com"
    git config --global user.name "YourName"
end

# Commit files
echo "Adding and committing project files..."
git add README.md scratch.fish setup_env.fish update_source.fish .gitignore
git commit -m "Initialize project tools" || echo "Warning: Nothing to commit."

# Sync with GitHub
"$project_dir/github_sync.fish" || begin
    echo "Error: GitHub sync failed."
    exit 1
end

echo "Setup complete! Your project is ready and synced."