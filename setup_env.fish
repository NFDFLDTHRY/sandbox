#!/usr/bin/fish
if test (count $argv) -lt 1
    echo 'Usage: ./setup_env.fish <target_dir>'
    exit 1
end
set target_dir $argv[1]
cd $target_dir
echo "Setting up development environment in $target_dir..."
echo 'Environment setup complete.'
