#!/usr/bin/env bash

# Library of functions for error handling and interactive mode prompting

check_if_interactive() {
	verbose=0
	if [ $# -gt 0 ]; then
	    if [ ! -z "$1" ]; then
	        verbose=$1
	    fi
	fi
	if [[ ! -t 0 ]]; then
		if [ $verbose -ne 0 ]; then
			echo "*** stdin is not a terminal"
		fi
		return 1;
	fi
	if [[ ! -t 1 ]]; then
		if [ $verbose -ne 0 ]; then
			echo "*** stdout is not a terminal"
		fi
		return 1;
	fi
	# if [[ ! -t 2 ]]; then
	#     echo "*** stderr is not a terminal" >&2
	#     return $ret
	# fi
	return 0;
}

check_error() {
    ret=$?
	msg=""
	prompt="Press 'i' to continue, 'x/q' to exit, 'b' for temporary escape to Bash, 't' for top, 's' for v-commander status, 'c' for v-commander: "
	if [ $# -gt 0 ]; then
	    if [ ! -z "$1" ]; then
	        ret=$1
	    fi
	fi
	if [ $# -gt 1 ]; then
		if [ ! -z "$2" ]; then
		    msg=$2
		fi
	fi
    if [ $ret -ne 0 ]; then
		if [ ! -z "$msg" ]; then
			echo "*** Error msg : $msg"
		fi
		echo "*** Error code: $ret"

	    check_if_interactive 0
		if [ $? -ne 0 ]; then
            echo ">> $prompt"
			echo "== Non interactive mode, exiting..."
			exit $ret;
		fi

   		while true; do
			read -p ">> $prompt" answer
			if [ "$answer" = 'i' ] || [ "$answer" = 'I' ]; then
				return;
			fi
			if [ "$answer" = 'b' ] || [ "$answer" = 'B' ]; then
                echo "======= Temporary escape to Bash"
				bash
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
				echo "== Exiting..."
                exit $ret
            fi
		done
    fi
}

check_continue() {
	options="Y/n"
	default="y"
	if [ $# -gt 0 ]; then
	    if [ ! -z "$1" ]; then
	        default=$1
	    fi
	fi
	if [ "$default" = "y" ] || [ "$default" = "Y" ] || [ -z "$default" ]; then
		default="y";
		options="Y/n";
	fi
	if [ "$default" = "n" ] || [ "$default" = "N" ]; then
		default="n";
		options="y/N";
	fi

	msg=""
	if [ $# -gt 1 ]; then
		if [ ! -z "$2" ]; then
		    msg=$2
		fi
	fi

	if [ ! -z "$msg" ]; then
		echo "== $msg"
	fi

	check_if_interactive
	if [ $? -ne 0 ]; then
	    echo ">> Are you sure you want to continue? ($options): "
	    if [ "$default" = "y" ]; then
			echo "== Non interactive mode, continuing..."
			return 0;
		else
		    echo "== Exiting..."
			exit 1;
		fi
	fi

	read -p ">> Are you sure you want to continue? ($options): " answer
	if [ "$default" = "y" ]; then
		if [ "$answer" = "y" ] || [ "$answer" = "Y" ] || [ -z "$answer" ]; then
			echo "== Continuing..."
			return 0;
		fi
		echo "== Exiting..."
		exit 1;
	fi
	if [ "$default" = "n" ]; then
		if [ "$answer" = "n" ] || [ "$answer" = "N" ] || [ -z "$answer" ]; then
			echo "== Exiting..."
			exit 1;
		fi
		echo "== Continuing..."
		return 0;
	fi
}

press_enter() {
	msg=""
	if [ $# -gt 0 ]; then
		if [ ! -z "$1" ]; then
		    msg=$1
		fi
	fi

	if [ -z "$msg" ]; then
		msg="Press Enter to continue..."
	fi

	check_if_interactive
	if [ $? -ne 0 ]; then
	    echo ">> $msg"
		echo "== Non interactive mode, continuing..."
		return 0;
	fi

	read -p ">> $msg" answer
	return 0;
}

check_yes_no() {
	options="Y/n"
	default="y"
	if [ $# -gt 0 ]; then
	    if [ ! -z "$1" ]; then
	        default=$1
	    fi
	fi
	if [ "$default" = "y" ] || [ "$default" = "Y" ] || [ -z "$default" ]; then
		default="y";
		options="Y/n";
	fi
	if [ "$default" = "n" ] || [ "$default" = "N" ]; then
		default="n";
		options="y/N";
	fi

	msg="Are you sure you want to continue?"
	if [ $# -gt 1 ]; then
		if [ ! -z "$2" ]; then
		    msg=$2
		fi
	fi

	check_if_interactive
	if [ $? -ne 0 ]; then
	    echo ">> $msg ($options): "
	    if [ "$default" = "y" ]; then
			echo "== Non interactive mode, default is yes, returning 0"
			return 0;
		else
		    echo "== Non interactive mode, default is no, returning 1"
			return 1;
		fi
	fi

	read -p ">> $msg ($options): " answer
	if [ "$default" = "y" ]; then
		if [ "$answer" = "y" ] || [ "$answer" = "Y" ] || [ -z "$answer" ]; then
			echo "== Yes, returning 0"
			return 0;
		fi
		echo "== No, returning 1"
		return 1;
	fi
	if [ "$default" = "n" ]; then
		if [ "$answer" = "n" ] || [ "$answer" = "N" ] || [ -z "$answer" ]; then
			echo "== No, returning 1"
			return 1;
		fi
		echo "== Yes, returning 0"
		return 0;
	fi
}

myvesta_error_sh_loaded=1
export myvesta_error_sh_loaded
