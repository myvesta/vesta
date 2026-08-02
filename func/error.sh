#!/usr/bin/env bash

check_error() {
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "*** Error returned: $ret"
   		while true; do
			read -p "======= Press 'i' to continue, 'x/q' to exit, 'b' for temporary escape to Bash, 't' for top, 's' for v-commander status, 'c' for v-commander: " answer
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

myvesta_error_sh_loaded=1
export myvesta_error_sh_loaded
