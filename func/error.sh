#!/usr/bin/env bash

check_error() {
    ret=$?
	msg=""
	prompt="=== Press 'i' to continue, 'x/q' to exit, 'b' for temporary escape to Bash, 't' for top, 's' for v-commander status, 'c' for v-commander: "
	if [ $# -eq 1 ]; then
	    if [ ! -z "$1" ]; then
	        ret=$1
	    fi
	fi
	if [ $# -eq 2 ]; then
		if [ ! -z "$2" ]; then
		    msg=$2
		fi
	fi
    if [ $ret -ne 0 ]; then
		if [ ! -z "$msg" ]; then
			echo "*** Error msg : $msg"
		fi
		echo "*** Error code: $ret"

        if [[ ! -t 0 ]]; then
            echo "*** stdin is not a terminal"
            return $ret
        fi
        if [[ ! -t 1 ]]; then
            echo "*** stdout is not a terminal"
            return $ret
        fi
        # if [[ ! -t 2 ]]; then
        #     echo "*** stderr is not a terminal" >&2
        #     return $ret
        # fi

   		while true; do
		    if [[ ! -t 2 ]]; then
                echo "$prompt"
            fi
			read -p "$prompt" answer
			if [ "$answer" = 'i' ] || [ "$answer" = 'I' ]; then
				return;
			fi
			if [ "$answer" = 'b' ] || [ "$answer" = 'B' ]; then
                echo "======= Temporary escape to Bash"
				/usr/bin/bash
			fi
			if [ "$answer" = 's' ] || [ "$answer" = 'S' ]; then
				/usr/local/vesta/bin/v-commander 'c'
			fi
			if [ "$answer" = 'c' ] || [ "$answer" = 'C' ]; then
				/usr/local/vesta/bin/v-commander
			fi
			if [ "$answer" = 't' ] || [ "$answer" = 'T' ]; then
				top
			fi
            if [ "$answer" = 'x' ] || [ "$answer" = 'X' ] || [ "$answer" = 'q' ] || [ "$answer" = 'Q' ]; then
                exit $ret
            fi
		done
    fi
}

check_continue() {
	if [[ ! -t 0 ]]; then
		echo "*** stdin is not a terminal"
		return $ret
	fi
	if [[ ! -t 1 ]]; then
		echo "*** stdout is not a terminal"
		return $ret
	fi
	read -p '>> Are you sure you want to continue? (Y/n): ' answer
	if [ "$answer" != "y" ] || if [ "$answer" != "Y" ] || [ -z "$answer" ] ; then
		echo "== Continuing..."
		return 0;
	fi
	echo "== Exiting..."
	exit 1;
}

myvesta_error_sh_loaded=1
export myvesta_error_sh_loaded
