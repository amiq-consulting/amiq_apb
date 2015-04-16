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
 * NAME:        amiq_apb_env_config.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the environment
 *              configuration class.
 *******************************************************************************/

`ifndef AMIQ_APB_ENV_CONFIG_SV
	//protection against multiple includes
	`define AMIQ_APB_ENV_CONFIG_SV

	//environment configuration class
	class amiq_apb_env_config extends uvm_component;

		//number of slave agents
		int unsigned number_of_slaves;

		//AMBA APB interface
		amiq_apb_vif_t dut_vi;

		`uvm_component_utils(amiq_apb_env_config)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_env_config", uvm_component parent);
			super.new(name, parent);
		endfunction

	endclass

`endif

