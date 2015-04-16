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
 * NAME:        amiq_apb_ex_multi_pkg.sv
 * PROJECT:     amiq_apb
 * Description: This file contains includes of all the files part of amiq_apb_ex_multi_pkg
 *              package.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_MULTI_PKG_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_MULTI_PKG_SV

	`include "amiq_apb_pkg.sv"

	package amiq_apb_ex_multi_pkg;
		import uvm_pkg::*;
		import amiq_apb_pkg::*;

		`include "amiq_apb_ex_multi_virtual_sequencer.sv"
		`include "amiq_apb_ex_multi_scoreboard.sv"
		`include "amiq_apb_ex_multi_env.sv"
		`include "amiq_apb_ex_multi_virtual_seq_lib.sv"

	endpackage

`endif

