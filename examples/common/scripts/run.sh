#!/bin/sh -e

#the default values of the user controlled options
default_run_mode="batch"
default_tool=ius
default_seed=1;
default_test="NONE"
default_arch_bits=64

while [ $# -gt 0 ]; do
	case `echo $1 | tr "[A-Z]" "[a-z]"` in
		-default_test)
			default_test=$2
			break;
      	;;
    esac
done

run_mode=${default_run_mode}
tool=${default_tool}
seed=${default_seed}
test=${default_test}
ARCH_BITS=${default_arch_bits}

export TOP_MODULE_NAME=${DUT_MODULE_NAME}_top
export TOP_FILE_NAME=${TOP_MODULE_NAME}.sv
export TOP_FILE_PATH=${EXAMPLE_DIR}/sv/${TOP_FILE_NAME}

help() {
	echo ""
	echo "Possible options for this script:"
	echo "	-i                     --> run in interactive mode"
	echo "	-seed <SEED>           --> specify a particular seed for the simulation (default: ${default_seed})"
	echo "	-test <TEST_NAME>      --> specify a particular test to run (default: ${default_test})"
	echo "	-tool [ius|questa|vcs] --> specify what simulator to use (default: ${default_tool})"
	echo "	-bit[32|64]            --> specify what architecture to use: 32 or 64 bits (default: ${default_arch_bits} bits)"
	echo "	-help                  --> print this message"
	echo ""
}

run_with_ius_test() {
	EXTRA_OPTIONS=" ${EXTRA_OPTIONS} "

	if [ "$run_mode" = "interactive" ]; then
		rm -rf ncsim_cmds.tcl
		touch ncsim_cmds.tcl

		echo "database -open waves -into waves.shm -default"     >> ncsim_cmds.tcl
		echo "probe -create ${TOP_MODULE_NAME}  -depth all -tasks -functions -uvm -packed 4k -unpacked 16k -all" >> ncsim_cmds.tcl

		EXTRA_OPTIONS=" ${EXTRA_OPTIONS} -gui -input ncsim_cmds.tcl "
	else
		EXTRA_OPTIONS=" ${EXTRA_OPTIONS} -exit "
	fi

	irun -f ${PROJECT_DIR}/examples/common/scripts/options_ius.f -svseed ${seed} +UVM_TESTNAME=${test} ${EXTRA_OPTIONS}
}

run_with_vcs_test() {
	EXTRA_OPTIONS=" ${EXTRA_OPTIONS} "

	if [ "$run_mode" = "interactive" ]; then
		EXTRA_OPTIONS=" ${EXTRA_OPTIONS}  -gui "
	fi

	vcs -ntb_opts uvm -f ${PROJECT_DIR}/examples/common/scripts/options_vcs.f +ntb_random_seed=${seed} +UVM_TESTNAME=${test} -R ${EXTRA_OPTIONS}

}

run_with_questa_test() {
	vlib work
	vlog -f ${PROJECT_DIR}/examples/common/scripts/options_vlog.f

	EXTRA_OPTIONS=" ${EXTRA_OPTIONS} "

	if [ "$run_mode" = "interactive" ]; then
		rm -rf vsim_cmds.do
		touch vsim_cmds.do

		echo "add wave -position insertpoint sim:/${TOP_MODULE_NAME}/dut_vif/*"     >> vsim_cmds.do

		EXTRA_OPTIONS=" ${EXTRA_OPTIONS}  -do vsim_cmds.do -i "
	else
		rm -rf vsim_cmds.do
		touch vsim_cmds.do

		echo "run -all; exit"     >> vsim_cmds.do

		EXTRA_OPTIONS=" ${EXTRA_OPTIONS}  -do vsim_cmds.do -c "
	fi

	vsim -${ARCH_BITS} ${TOP_MODULE_NAME} -sv_seed ${seed} +UVM_TESTNAME=${test} ${EXTRA_OPTIONS}
}

while [ $# -gt 0 ]; do
	case `echo $1 | tr "[A-Z]" "[a-z]"` in
		-seed)
			seed=$2
      	;;
      	-tool)
      		tool=$2
      	;;
      	-test)
      		test=$2
      	;;
        -i)
            run_mode=interactive
        ;;
      	-help)
      		help
      		exit 0
      	;;
    esac
    shift
done

export ARCH_BITS=${ARCH_BITS}

case $tool in
	ius)
		echo "Selected tool: IUS..."
	;;
	vcs)
		echo "Selected tool: VCS..."
	;;
	questa)
		echo "Selected tool: Questa..."
	;;
	*)
		echo "Illegal option for tool: $tool"
		exit 1;
	;;
esac

sim_dir=`pwd`/sim_${test}
echo "Start running ${test} test in ${sim_dir}";
rm -rf ${sim_dir};
mkdir ${sim_dir};
cd ${sim_dir};
run_with_${tool}_test
