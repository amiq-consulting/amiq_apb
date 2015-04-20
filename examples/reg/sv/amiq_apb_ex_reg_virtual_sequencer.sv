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
 * NAME:        amiq_apb_ex_reg_virtual_sequencer.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the virtual sequencer.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_VIRTUAL_SEQUENCER_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_VIRTUAL_SEQUENCER_SV

	//virtual sequencer
	class amiq_apb_ex_reg_virtual_sequencer extends uvm_virtual_sequencer;

		//pointer to the master sequencer
		amiq_apb_master_sequencer master_sequencer;

		//pointer to the slave sequencer
		amiq_apb_slave_sequencer slave_sequencer;
		
		//pointer to the register block
		amiq_apb_ex_reg_reg_block reg_block;

		`uvm_component_utils(amiq_apb_ex_reg_virtual_sequencer)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);
		endfunction

	endclass

`endif

