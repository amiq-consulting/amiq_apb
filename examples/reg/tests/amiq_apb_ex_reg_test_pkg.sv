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
 * NAME:        amiq_apb_ex_reg_test_pkg.sv
 * PROJECT:     amiq_apb
 * Description: This file contains all imports of the amiq_apb_ex_reg_test_pkg package
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_TEST_PKG_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_TEST_PKG_SV

	`include "amiq_apb_ex_reg_pkg.sv"

	package amiq_apb_ex_reg_test_pkg;
		import uvm_pkg::*;
		import amiq_apb_pkg::*;
		import amiq_apb_ex_reg_pkg::*;

		`include "amiq_apb_ex_reg_test_basic.sv"
		`include "amiq_apb_ex_reg_test_random.sv"

	endpackage

`endif

