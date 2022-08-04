#!/bin/bash


[[ -n $DEBUG ]] && echo -e "\$DEBUG has value $DEBUG\n"


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
# BLUE='\033[0;34m'
# PURPLE='\033[0;35m'
CYAN='\033[0;36m'
# WHITE='\033[0;37m'
NC='\033[0m' # No Color


cd_to_project()
{
    local project_slug="$1"
    [[ $DEBUG -eq 1 ]] && echo -e "CDing to $project_slug dir...\n"
    cd "$project_slug" || exit 1
    [[ $DEBUG -eq 1 ]] && echo -e "In dir $(pwd)\n"
}


# ----------------------------------------------------------------------
# Tries to remove existing virtual machines
#
# There may be existing virtual machines from other environments
# that require a manual removal.
# ----------------------------------------------------------------------
clean_up()
{
    local project_slug="$1"
    if [[ -d "$project_slug" ]]; then
        cd_to_project "$project_slug"
        # Check prior vm existence for deletion.
        [[ $DEBUG -eq 1 ]] && echo -e "Entering the vm_name for loop\n"
        for vm_name in "vm-1" "vm-2" "vm-ctrl"; do
            # They could be running or poweroff. I believe
            # the "not created" vm status may be a special case sometimes
            # which may require a manual removal from the Virtualbox GUI.
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
                if [[ $DEBUG -eq 1 ]]; then
                    echo "    The machine $vm_name may exist from another environment ('not created')."
                    echo "    If errors persist, it may require manual deletion from the Virtualbox GUI."
                    echo "    For more details see the source code comments."
                    echo "    Continuing"
                fi
                continue
            fi
            if [[ $DEBUG -eq 1 ]]; then
                echo "    The virtual machine $vm_name may be running or poweroff"
                echo "    It will be removed"
            fi
            vagrant destroy -f "$vm_name"
        done
        cd ..
        rm -rf "$project_slug"
    fi
}


# ----------------------------------------------------------------------
# Test defaults
#
# Three virtual machines: one controller (vm-ctrl) and two
# instances (vm-1 and vm-2)
# ----------------------------------------------------------------------
test_defaults()
{
    local DEFAULT_PROJECT_SLUG="my-new-project"
    clean_up "$DEFAULT_PROJECT_SLUG"
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
    cd_to_project "$DEFAULT_PROJECT_SLUG"
    if ! vagrant up; then
        printf "The %bDEFAULT%b test was %bNOT%b successful.\n" \
            "$YELLOW" "%NC" "$RED" "$NC"
        printf "Cleaning up...\n"
        cd ..
        clean_up "$DEFAULT_PROJECT_SLUG"
        exit 1
    fi
    for suffix in 1 2 ctrl; do
        vagrant destroy -f "vm-$suffix"
    done
    cd ..
    rm -rf "$DEFAULT_PROJECT_SLUG"
    printf "The %bdefault%b test was %bSUCCESS$%bful.\n" \
        "$YELLOW" "$NC" "$GREEN" "$NC"
}


# ----------------------------------------------------------------------
# Test Single
#
# Aiming at one virtual machine which is a controller/instance
# (I must thing of how to deal with provisioning via host or via
# a dedicated virtual machine or self-provisioning for single
# scenario). Perhaps the easiest way is to simplify for now and 
# make a self-provisioning for the single scenario.
# ----------------------------------------------------------------------
test_single()
{
    local SINGLE_PROJECT_SLUG=my-single-project
    clean_up "$SINGLE_PROJECT_SLUG"
    cookiecutter \
        --default-config \
        --no-input \
        gh:frock81/skel-vagrant \
        project_name="My Single Project" \
        instance_index_end=1
    cd_to_project "$SINGLE_PROJECT_SLUG"
    if ! vagrant up; then
        printf "The %bSINGLE%b test was %bNOT%b successful.\n" \
            "$CYAN" "$NC" "$RED" "$NC"
        printf "Cleaning up...\n"
        cd ..
        clean_up "$SINGLE_PROJECT_SLUG"
        exit 1
    fi
    for suffix in 1 ctrl; do
        vagrant destroy -f "vm-$suffix"
    done
    cd ..
    rm -rf "$SINGLE_PROJECT_SLUG"
    printf "The %bSINGLE%b test was %bSUCCESS$%bful.\n" \
            "$CYAN" "$NC" "$GREEN" "$NC"
}


main()
{
    test_defaults
    test_single
}


main
