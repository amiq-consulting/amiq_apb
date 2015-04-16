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
 * MODULE:      amiq_apb_slave_agent_config.sv
 * PROJECT:     amiq_apb
 * Description: Configuration class for slave agents.
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_AGENT_CONFIG_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_AGENT_CONFIG_SV

	//Configuration class for slave agents
	class amiq_apb_slave_agent_config extends amiq_apb_agent_config;

		//slave index
		protected int unsigned slave_index = 0;

		//reset value of ready signal
		protected bit reset_value_for_ready = 1;

		//function for getting the slave_index
		//@return slave_index
		function int unsigned get_slave_index();
			return slave_index;
		endfunction

		//function for setting a new slave_index
		//@param slave_index - new value of slave_index
		function void set_slave_index(int unsigned slave_index);
			this.slave_index = slave_index;
		endfunction

		//function for getting the reset_value_for_ready
		//@return reset_value_for_ready
		function bit get_reset_value_for_ready();
			return reset_value_for_ready;
		endfunction

		//function for setting a new reset_value_for_ready
		//@param reset_value_for_ready - new value of reset_value_for_ready
		function void set_reset_value_for_ready(bit reset_value_for_ready);
			this.reset_value_for_ready = reset_value_for_ready;
		endfunction

		`uvm_component_utils(amiq_apb_slave_agent_config)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_slave_agent_config", uvm_component parent);
			super.new(name, parent);
		endfunction

	endclass

`endif
