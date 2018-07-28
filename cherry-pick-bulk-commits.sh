#!/bin/bash

function file_exists() {
	if [ ! -f $1 ]; then 
		echo "File does not exists"
		exit
	fi
}

function show_help() {
    echo "Usage: cherry-pick-bulk-commits.sh [OPTIONS] <filename>"
    echo "filename: file having all commits generated using $(tput bold && tput setaf 2)git log -n <number of commits> --oneline --reverse > <filename>$(tput sgr0)"
    echo -e "\t An example of git log could be $(tput bold && tput setaf 2)git log -n 100 --oneline --reverse > master_new_commits $(tput sgr0)"
    echo -e "Options: \n\t --help: display help instructions"
    echo -e "\t --branch: branch on which to apply the commits"
    echo "Examples:"
    echo -e "\t $(tput bold && tput setaf 2)./cherry-pick-bulk-commits.sh --branch master master_new_commits$(tput sgr0)"
    echo -e "\t $(tput bold && tput setaf 2)./cherry-pick-bulk-commits.sh master_new_commits$(tput sgr0)"
}

function cherry-pick(){
    while read l; do
    	COMMIT=$(echo $l | cut -d " " -f 1)
        echo $l
        response="y"
        read -p "Commit? y/n (default:y) " response < /dev/tty
        if [[ $response == "n" ]]; then
            exit
        else
            git cherry-pick $COMMIT
#            if [ ! $? -eq 0 ]; then # in case of NZEC
#                MARKER="<<<<<<<<<<<<<<<<<<<<<<<<<<<---cherry-picking paused here--->>>>>>>>>>>>>>>>>>>>>>>>>>>"
#                cat $1 | sed -e "/$l/a$MARKER" > /tmp/bulk-cherry-pick.tmp
#                FILEPATH=$(pwd)/file.txt
#                rm -rf $FILEPATH
#                mv /tmp/bulk-cherry-pick.tmp $FILEPATH
#                exit
#            fi
        fi
	done < $1
}

NUM_ARGS=$#
if [ $NUM_ARGS == 0 ]; then
    show_help
    exit
fi
if [ $NUM_ARGS -eq 1 ]; then
    if [ $1 == "--help" ]; then
        show_help
    else
        FILENAME=$1
        file_exists $FILENAME
        cherry-pick $FILENAME
    fi
elif [ $NUM_ARGS -eq 3 ]; then
    echo "hello"
    BRANCH=$2
    FILENAME=$3
    file_exists $FILENAME
    echo "Checking out to branch "$BRANCH
    git checkout $BRANCH
    cherry-pick $FILENAME
else
    show_help
fi
