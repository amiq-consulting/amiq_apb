/******************************************************************************
 * (C) Copyright 2014 AMIQ Consulting
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * MODULE:      amiq_apb_pkg.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB package for uVCs
 *******************************************************************************/

`ifndef AMIQ_APB_PKG_SV
	//protection against multiple includes
	`define AMIQ_APB_PKG_SV

	`include "amiq_apb_if.sv"

	//AMBA APB environment package
	package amiq_apb_pkg;

		import uvm_pkg::*;

		`include "uvm_macros.svh"

		`include "amiq_apb_macros.sv"
		`include "amiq_apb_defines.sv"
		`include "amiq_apb_types.sv"
		`include "amiq_apb_base_item.sv"
		`include "amiq_apb_item.sv"
		`include "amiq_apb_mon_item.sv"
		`include "amiq_apb_agent_config.sv"
		`include "amiq_apb_coverage.sv"
		`include "amiq_apb_monitor.sv"
		`include "amiq_apb_sequencer.sv"
		`include "amiq_apb_driver.sv"
		`include "amiq_apb_agent.sv"

		`include "amiq_apb_master_drv_item.sv"
		`include "amiq_apb_master_agent_config.sv"
		`include "amiq_apb_master_sequencer.sv"
		`include "amiq_apb_master_driver.sv"
		`include "amiq_apb_master_seq_lib.sv"
		`include "amiq_apb_master_agent.sv"

		`include "amiq_apb_slave_drv_item.sv"
		`include "amiq_apb_slave_agent_config.sv"
		`include "amiq_apb_slave_sequencer.sv"
		`include "amiq_apb_slave_driver.sv"
		`include "amiq_apb_slave_seq_lib.sv"
		`include "amiq_apb_slave_agent.sv"

		`include "amiq_apb_env_config.sv"
		`include "amiq_apb_env.sv"

	endpackage

`endif
