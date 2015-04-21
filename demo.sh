#!/bin/sh -e

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

default_example=multi
example=${default_example}

function help() {
    echo ""
	echo "Possible options for this script:"
	echo "	-example <multi|reg> <EXAMPLE_OPTIONS> --> specify what example to run (default: ${default_example})."
	echo "	                                       --> Run \"demo.sh -example <EXAMPLE_NAME> -help\" for a full list of EXAMPLE_OPTIONS"
	echo "	-help_demo                             --> print this message"
	echo ""
}

while [ $# -gt 0 ]; do
	case `echo $1 | tr "[A-Z]" "[a-z]"` in
		-example)
			example=$2
			break;
      	;;
      	-help_demo)
      	    help;
      	    exit 0;
      	;;
      	*)
			break;
      	;;
    esac
done


${PROJECT_DIR}/examples/${example}/scripts/run.sh $@