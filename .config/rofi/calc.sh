#!/usr/bin/env bash

if [ ! -z "$@" ]; then
	# To strip spaces
	input=$(echo "$@" | sed 's/[[:space:]]*//g')
	# If input has numbers and symbols, process it
	if grep -q '+\|-[[:digit:]]\|\*\|\/\|\^' <<<"$input"; then
		if [ ! -z "$(command -v bc)" ]; then # has bc package on system
			# If there is an equal sign (=) at the end, get rid of it.
			input=$(echo "$input" | sed 's/\=//g')
			# Show the result in a notification.
			echo "$input = "$( echo $input | bc )
		elif [ ! -z "$(command -v python)" ]; then # has python package on system
			# If there is an equal sign (=) at the end, get rid of it.
			# Replace "^" with "**" so that it can calculate powers.
			input=$(echo "$input" | sed 's/\=//g;s/\^/**/g')
			# Show the result in a notification.
			# The "float(1)*" part is so that Python 2 returns decimal places.
			echo "$input = "$( python -c "print( float(1)*$input )" )
		elif [ -f "$(dirname $0)/bcalc" ]; then # has bcalc
			# If there is an equal sign (=) at the end, get rid of it.
			input=$(echo "$input" | sed 's/\=//g')
			echo "$input = "$($(dirname $0)/bcalc "$input")
		else
			echo 'Error: No calculation utility found.'
			echo 'Please install bc, python or bcalc.'
		fi
	fi
    exit 0
fi

# Change prompt
echo -en "\0prompt\x1fcalc\n"
