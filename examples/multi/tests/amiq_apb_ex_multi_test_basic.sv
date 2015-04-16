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
 * NAME:        amiq_apb_ex_multi_test_basic.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the basic test.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_MULTI_TEST_BASIC_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_MULTI_TEST_BASIC_SV

	class amiq_apb_ex_multi_test_basic extends uvm_test;

		amiq_apb_ex_multi_env env;

		`uvm_component_utils(amiq_apb_ex_multi_test_basic)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM connect phase
		//@param phase - current phase
		virtual function void build_phase(input uvm_phase phase);
			super.build_phase(phase);

			env = amiq_apb_ex_multi_env::type_id::create("env", this);

			begin
				amiq_apb_env_config env_config = amiq_apb_env_config::type_id::create("amiq_apb_env_config", this);
				env_config.number_of_slaves = 2;

				if(!uvm_config_db#(virtual amiq_apb_if)::get(this, "", "dut_vi", env_config.dut_vi)) begin
					`uvm_fatal(get_name(), "Could not get from database the virtual interface")
				end

				uvm_config_db#(amiq_apb_env_config)::set(this, "env*", "env_config", env_config);
			end
		endfunction

	endclass

`endif

