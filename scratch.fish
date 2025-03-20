#!/usr/bin/fish

# scratch.fish: Sets up a project workspace, creates/clones projects, and syncs with GitHub

set project_dir (pwd)  # Should be /home/cd/projs/SB
set projs_dir "$project_dir/projs"

# Check if we're in a Git repository
if not test -d "$project_dir/.git"
    echo "Error: No Git repository found in $project_dir. Initialize one first."
    exit 1
end

# Create projs directory if it doesn't exist
if not test -d "$projs_dir"
    echo "Creating projs directory at $projs_dir..."
    mkdir -p "$projs_dir"
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

# Create or update create_project.fish
echo "#!/usr/bin/fish" > "$project_dir/create_project.fish"
echo "if test (count \$argv) -lt 1" >> "$project_dir/create_project.fish"
echo "    echo 'Usage: ./create_project.fish <project_name>'" >> "$project_dir/create_project.fish"
echo "    exit 1" >> "$project_dir/create_project.fish"
echo "end" >> "$project_dir/create_project.fish"
echo "set project_name \$argv[1]" >> "$project_dir/create_project.fish"
echo "set projs_dir \"$project_dir/projs\"" >> "$project_dir/create_project.fish"
echo "set target_dir \"\$projs_dir/\$project_name\"" >> "$project_dir/create_project.fish"
echo "if test -d \"\$target_dir\"" >> "$project_dir/create_project.fish"
echo "    echo \"Error: Project \$project_name already exists at \$target_dir.\"" >> "$project_dir/create_project.fish"
echo "    exit 1" >> "$project_dir/create_project.fish"
echo "end" >> "$project_dir/create_project.fish"
echo "echo \"Creating new project \$project_name at \$target_dir...\"" >> "$project_dir/create_project.fish"
echo "mkdir -p \"\$target_dir\"" >> "$project_dir/create_project.fish"
echo "echo \"# Project \$project_name\" > \"\$target_dir/README.md\"" >> "$project_dir/create_project.fish"
echo "cd \$projs_dir" >> "$project_dir/create_project.fish"
echo "git add \"\$project_name\"" >> "$project_dir/create_project.fish"
echo "echo \"Project \$project_name created and staged for commit.\"" >> "$project_dir/create_project.fish"
chmod +x "$project_dir/create_project.fish"

# Create or update clone_project.fish
echo "#!/usr/bin/fish" > "$project_dir/clone_project.fish"
echo "if test (count \$argv) -lt 2" >> "$project_dir/clone_project.fish"
echo "    echo 'Usage: ./clone_project.fish <repo_url> <project_name>'" >> "$project_dir/clone_project.fish"
echo "    exit 1" >> "$project_dir/clone_project.fish"
echo "end" >> "$project_dir/clone_project.fish"
echo "set repo_url \$argv[1]" >> "$project_dir/clone_project.fish"
echo "set project_name \$argv[2]" >> "$project_dir/clone_project.fish"
echo "set projs_dir \"$project_dir/projs\"" >> "$project_dir/clone_project.fish"
echo "set target_dir \"\$projs_dir/\$project_name\"" >> "$project_dir/clone_project.fish"
echo "if test -d \"\$target_dir\"" >> "$project_dir/clone_project.fish"
echo "    echo \"Error: Project \$project_name already exists at \$target_dir.\"" >> "$project_dir/clone_project.fish"
echo "    exit 1" >> "$project_dir/clone_project.fish"
echo "end" >> "$project_dir/clone_project.fish"
echo "echo \"Cloning repository into \$target_dir...\"" >> "$project_dir/clone_project.fish"
echo "git clone \$repo_url \"\$target_dir\"" >> "$project_dir/clone_project.fish"
echo "if test \$status -ne 0" >> "$project_dir/clone_project.fish"
echo "    echo 'Error: Failed to clone repository.'" >> "$project_dir/clone_project.fish"
echo "    exit 1" >> "$project_dir/clone_project.fish"
echo "end" >> "$project_dir/clone_project.fish"
echo "# Remove the .git directory to avoid nested repositories" >> "$project_dir/clone_project.fish"
echo "rm -rf \"\$target_dir/.git\"" >> "$project_dir/clone_project.fish"
echo "cd \$projs_dir" >> "$project_dir/clone_project.fish"
echo "git add \"\$project_name\"" >> "$project_dir/clone_project.fish"
echo "echo \"Project \$project_name cloned and staged for commit.\"" >> "$project_dir/clone_project.fish"
chmod +x "$project_dir/clone_project.fish"

# Verify tools exist
for tool in setup_env.fish update_source.fish github_sync.fish create_project.fish clone_project.fish
    if not test -f "$project_dir/$tool"
        echo "Error: $tool was not created successfully."
        exit 1
    end
end

# Handle arguments for creating or cloning a project
if test (count $argv) -gt 0
    set command $argv[1]
    switch $command
        case "create"
            if test (count $argv) -lt 2
                echo "Usage: ./scratch.fish create <project_name>"
                exit 1
            end
            set project_name $argv[2]
            "$project_dir/create_project.fish" "$project_name"
        case "clone"
            if test (count $argv) -lt 3
                echo "Usage: ./scratch.fish clone <repo_url> <project_name>"
                exit 1
            end
            set repo_url $argv[2]
            set project_name $argv[3]
            "$project_dir/clone_project.fish" "$repo_url" "$project_name"
        case '*'
            echo "Unknown command: $command"
            echo "Usage: ./scratch.fish [create <project_name> | clone <repo_url> <project_name>]"
            exit 1
    end
end

# Run setup scripts on the main project directory
echo "Running setup scripts on $project_dir..."
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
git add scratch.fish setup_env.fish update_source.fish github_sync.fish create_project.fish clone_project.fish projs
if git status | grep -q "Changes to be committed"
    git commit -m "Update project files with new tools and projects"
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