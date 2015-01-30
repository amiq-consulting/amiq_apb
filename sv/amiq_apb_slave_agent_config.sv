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
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: Configuration class for slave agents.
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_AGENT_CONFIG_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_AGENT_CONFIG_SV

	//Configuration class for slave agents
	class amiq_apb_slave_agent_config extends amiq_apb_agent_config;

		//slave index
		int unsigned slave_index = 0;

		//reset value of ready signal
		bit reset_value_for_ready = 1;

		`uvm_component_utils(amiq_apb_slave_agent_config)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_slave_agent_config", uvm_component parent);
			super.new(name, parent);
		endfunction

	endclass

`endif
