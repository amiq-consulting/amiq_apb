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
 * MODULE:      amiq_apb_agent.sv
 * PROJECT:     amiq_apb
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB base agent
 *******************************************************************************/

`ifndef AMIQ_APB_AGENT_SV
	//protection against multiple includes
	`define AMIQ_APB_AGENT_SV

	//AMBA APB base agent
	class amiq_apb_agent #(type DRIVER_ITEM_REQ=uvm_sequence_item) extends uagt_agent #(.VIRTUAL_INTF_TYPE(amiq_apb_vif_t), .MONITOR_ITEM(amiq_apb_mon_item), .DRIVER_ITEM_REQ(DRIVER_ITEM_REQ));

		`uvm_component_param_utils(amiq_apb_agent#(DRIVER_ITEM_REQ))

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_agent", uvm_component parent);
			super.new(name, parent);

			uagt_monitor#(.VIRTUAL_INTF_TYPE(amiq_apb_vif_t), .MONITOR_ITEM(amiq_apb_mon_item))::type_id::set_inst_override(amiq_apb_monitor::get_type(), "monitor", this);
			uagt_coverage#(.VIRTUAL_INTF_TYPE(amiq_apb_vif_t), .MONITOR_ITEM(amiq_apb_mon_item))::type_id::set_inst_override(amiq_apb_coverage::get_type(), "coverage", this);
		endfunction
	endclass

`endif
