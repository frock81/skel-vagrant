#!/bin/bash

DEFAULT_PROJECT_SLUG=my-new-project

# I believe it is better to remove any existing
# directory before test but I'm not sure. This
# could change in the future.
if [[ -d "$DEFAULT_PROJECT_SLUG" ]]; then
    rm -rf "$DEFAULT_PROJECT_SLUG"
fi

# Cookiecutter the project.
#
# Command line options taken from 
# https://cookiecutter.readthedocs.io/en/1.7.2/advanced/cli_options.html
#
#   --default-config: Do not load a config file. Use the defaults
#                     instead. There may be some config from a diferent
#                     environment.
#   --overwrite-if-exists: Overwrite the contents of the output
#                          directory if it already exists
#   --no-input: Do not prompt for parameters and only use
#               cookiecutter.json file content
cookiecutter \
    --default-config \
    --overwrite-if-exists \
    --no-input \
    gh:frock81/skel-vagrant

# ================================================
# Test defaults
# ================================================
cd "$DEFAULT_PROJECT_SLUG" || exit 1

# First, I thought of checking the vm existence
# for deletion before a test execution. But there
# could be another machine with the same name from
# another environment that could not be detected
# in this environment (not created output). In
# this case, that machine should be manually
# deleted from the Virtualbox GUI.
vagrant status vm-1
if ! vagrant up; then
    echo Error
    exit 1
fi
echo Success
