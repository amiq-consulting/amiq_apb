
+incdir+${PROJECT_DIR}/sv/

+incdir+${EXAMPLE_DIR}/rtl/
+incdir+${EXAMPLE_DIR}/sv/
+incdir+${EXAMPLE_DIR}/tests/
-${ARCH_BITS}bit
+uvm_set_action="*,_ALL_,UVM_ERROR,UVM_DISPLAY|UVM_STOP"
-uvm
-access rw
-sv
-covoverwrite
-coverage all
+UVM_NO_RELNOTES
-DSC_INCLUDE_DYNAMIC_PROCESSES
+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
+UVM_VERBOSITY=UVM_LOW
-timescale 1ns/1ps
-F ${EXAMPLE_DIR}/rtl/files.list
${TOP_FILE_PATH}
