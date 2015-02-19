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
 * MODULE:      amiq_apb_sequencer.sv
 * PROJECT:     amiq_apb
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB base sequencer
 *******************************************************************************/

`ifndef AMIQ_APB_SEQUENCER_SV
	//protection against multiple includes
	`define AMIQ_APB_SEQUENCER_SV

	//AMBA APB base sequencer
	class amiq_apb_sequencer #(type DRIVER_ITEM=amiq_apb_base_item) extends cagt_sequencer #(.REQ(DRIVER_ITEM));

		`uvm_component_param_utils(amiq_apb_sequencer#(DRIVER_ITEM))

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_sequencer", uvm_component parent);
			super.new(name, parent);
		endfunction
	endclass

`endif
