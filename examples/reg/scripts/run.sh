#!/bin/sh -e

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../../ && pwd )"
export EXAMPLE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../ && pwd )"

#the default values of the user controlled options
default_test="amiq_apb_ex_reg_test_random"

export DUT_MODULE_NAME=amiq_apb_ex_reg

${PROJECT_DIR}/examples/common/scripts/run.sh -default_test ${default_test} $@
