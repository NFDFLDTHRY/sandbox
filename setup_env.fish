#!/usr/bin/fish
echo 'Setting up development environment...'
if not type -q git
    echo 'Error: Git is not installed. Please install it and try again.'
    exit 1
end
echo 'Environment setup complete.'
