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
 * NAME:        amiq_apb_ex_reg_top.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the top module with a dummy instance of the
 *              APB interface.
 *******************************************************************************/

`timescale 1ns/1ps

`ifndef AMIQ_APB_EX_REG_TOP_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_TOP_SV

	//maximum sel width
	`define AMIQ_APB_MAX_SEL_WIDTH 1

	`include "amiq_apb_ex_reg_test_pkg.sv"

	import uvm_pkg::*;
	import amiq_apb_ex_reg_test_pkg::*;

	module amiq_apb_ex_reg_top;

		reg clock;

		initial begin
			clock = 0;
			forever #5 clock = ~clock;
		end

		amiq_apb_if dut_vif (.clk(clock));

		initial begin
			dut_vif.reset_n <= 0;
			#2000 dut_vif.reset_n <= 1;
		end

		initial begin
			uvm_config_db #(virtual amiq_apb_if)::set(null, "uvm_test_top", "dut_vi", dut_vif);

			run_test();
		end

	endmodule

`endif

