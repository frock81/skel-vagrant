#!/bin/bash

DEFAULT_PROJECT_SLUG=my-new-project
[[ -n $DEBUG ]] && echo -e "\$DEBUG has value $DEBUG\n"


cd_to_project ()
{
    [[ $DEBUG -eq 1 ]] && echo -e "CDing to $DEFAULT_PROJECT_SLUG dir...\n"
    cd "$DEFAULT_PROJECT_SLUG" || exit 1
    [[ $DEBUG -eq 1 ]] && echo -e "In dir $(pwd)\n"
}


# ======================================================================
# Test defaults
# ======================================================================

# First, I thought of checking the vm existence
# for deletion before a test execution. But there
# could be another machine with the same name from
# another environment that could not be detected
# in this environment (not created output). In
# this case, that machine should be manually
# deleted from the Virtualbox GUI.
#
# I believe it is better to remove any existing directory before
# cookiecutting the project but I'm not sure. This could change in the
# future.
if [[ -d "$DEFAULT_PROJECT_SLUG" ]]; then

    cd_to_project
    # Check prior vm existence for deletion.
    [[ $DEBUG -eq 1 ]] && echo -e "Entering the vm_name for loop\n"
    for vm_name in "vm-1" "vm-2" "vm-ctrl"; do
        # They could be running or poweroff. I believe (for now)
        # that the "not created" vm status may be a special case
        # which requires manual removal from the Virtualbox GUI,
        # but I'm not entirely sure. This state could mean the
        # machine exists from another Virtualbox environment.
        [[ $DEBUG -eq 1 ]] && echo -e "Checking status of vm $vm_name\n"
        vm_line=$(vagrant status "$vm_name" 2> /dev/null | grep $vm_name)
        [[ $DEBUG -eq 1 ]] && echo -e "\$vm_line var is '$vm_line'\n"

        if [[ -z "$vm_line" ]]; then
            if [[ $DEBUG -eq 1 ]]; then
                echo "    The virtual machine $vm_name does not exist."
                echo "    Nothing to be done."
                echo "    Continuing..."
            fi
            continue
        fi

        if echo "$vm_line" | grep "not created"; then
            echo "    The machine $vm_name may exist from another environment ('not created')."
            echo "    If errors persist, it may require manual deletion from the Virtualbox GUI."
            echo "    For more details see the source code comments."
            echo "    Continuing"
            continue
        fi

        if [[ $DEBUG -eq 1 ]]; then
            echo "    The virtual machine $vm_name may be running or poweroff"
            echo "    It will be removed"
            vagrant destroy -f "$vm_name"
        fi
    done
    cd ..
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
    --no-input \
    gh:frock81/skel-vagrant

cd_to_project
if ! vagrant up; then
    echo Error
    exit 1
fi
echo Success
