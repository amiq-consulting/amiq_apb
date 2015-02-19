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
 * NAME:        amiq_apb_master_agent.sv
 * PROJECT:     amiq_apb
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB master agent
 *******************************************************************************/

`ifndef AMIQ_APB_MASTER_AGENT_SV
	//protection against multiple includes
	`define AMIQ_APB_MASTER_AGENT_SV

	//AMBA APB master agent
	class amiq_apb_master_agent extends amiq_apb_agent#(amiq_apb_master_drv_item);

		`uvm_component_utils(amiq_apb_master_agent)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);

			cagt_agent_config #(.VIRTUAL_INTF_TYPE(amiq_apb_vif_t))::type_id::set_inst_override(amiq_apb_master_agent_config::get_type(), "agent_config", this);
			cagt_driver #(.VIRTUAL_INTF_TYPE(amiq_apb_vif_t), .REQ(amiq_apb_master_drv_item))::type_id::set_inst_override(amiq_apb_master_driver::get_type(), "driver", this);
			cagt_sequencer #(.REQ(amiq_apb_master_drv_item))::type_id::set_inst_override(amiq_apb_master_sequencer::get_type(), "sequencer", this);
		endfunction

		//UVM connect phase
		//@param phase - current phase
		virtual function void connect_phase(uvm_phase phase);
			amiq_apb_master_sequencer master_sequencer;
			super.connect_phase(phase);

			if($cast(master_sequencer, sequencer) == 0) begin
				`uvm_fatal(get_id(), "Could not cast to amiq_apb_master_sequencer")
			end

			if($cast(master_sequencer.agent_config, agent_config) == 0) begin
				`uvm_fatal(get_id(), "Could not cast to amiq_apb_master_agent_config")
			end
		endfunction
	endclass
`endif

