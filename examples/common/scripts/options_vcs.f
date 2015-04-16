-sverilog

+incdir+${PROJECT_DIR}/sv/

+incdir+${EXAMPLE_DIR}/rtl/
+incdir+${EXAMPLE_DIR}/sv/
+incdir+${EXAMPLE_DIR}/tests/

-F ${EXAMPLE_DIR}/rtl/files.list
${TOP_FILE_PATH}
-top ${TOP_MODULE_NAME}
-timescale=1ns/1ps