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
 * MODULE:      amiq_apb_slave_sequencer.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB slave sequencer
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_SEQUENCER_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_SEQUENCER_SV

	//AMBA APB slave sequencer
	class amiq_apb_slave_sequencer extends amiq_apb_sequencer#(amiq_apb_slave_drv_item);

		`uvm_component_utils(amiq_apb_slave_sequencer)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_slave_sequencer", uvm_component parent);
			super.new(name, parent);
		endfunction

	endclass

`endif
