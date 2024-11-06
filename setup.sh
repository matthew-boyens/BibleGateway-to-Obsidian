#!/bin/bash
# setup.sh

# Update package lists
sudo apt update

# Install Ruby and build dependencies
sudo apt install -y ruby-full build-essential

# Install clipboard support
sudo apt install -y xsel

# Install Ruby gems
gem install bundler
bundle install
