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
 * NAME:        amiq_apb_slave_agent.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB slave agent
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_AGENT_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_AGENT_SV

	//AMBA APB slave agent
	class amiq_apb_slave_agent extends amiq_apb_agent#(amiq_apb_slave_drv_item);

		`uvm_component_utils(amiq_apb_slave_agent)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);

			amiq_apb_agent_config::type_id::set_inst_override(amiq_apb_slave_agent_config::get_type(), "agent_config", this);
			amiq_apb_driver#(.DRIVER_ITEM_REQ(amiq_apb_slave_drv_item))::type_id::set_inst_override(amiq_apb_slave_driver::get_type(), "driver", this);
			amiq_apb_sequencer#(.DRIVER_ITEM(amiq_apb_slave_drv_item))::type_id::set_inst_override(amiq_apb_slave_sequencer::get_type(), "sequencer", this);
		endfunction

	endclass

`endif

