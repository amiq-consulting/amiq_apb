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
 * MODULE:    amiq_apb_master_sequencer.sv
 * PROJECT:     amiq_apb
 * Description:  AMBA APB master sequencer
 *******************************************************************************/

`ifndef AMIQ_APB_MASTER_SEQUENCER_SV
	//protection against multiple includes
	`define AMIQ_APB_MASTER_SEQUENCER_SV

	//AMBA APB master sequencer
	class amiq_apb_master_sequencer extends amiq_apb_sequencer#(amiq_apb_master_drv_item);

		//pointer to the agent configuration unit
		amiq_apb_master_agent_config agent_config;

		`uvm_component_utils(amiq_apb_master_sequencer)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_master_sequencer", uvm_component parent);
			super.new(name, parent);
		endfunction
	endclass

`endif
