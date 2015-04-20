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
 * MODULE:      amiq_apb_master_seq_lib.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB master sequence library
 *******************************************************************************/

`ifndef AMIQ_APB_MASTER_SEQ_LIB_SV
	//protection against multiple includes
	`define AMIQ_APB_MASTER_SEQ_LIB_SV

	//AMBA APB master base sequence
	class amiq_apb_master_base_seq extends uvm_sequence#(amiq_apb_master_drv_item);

		`uvm_object_utils(amiq_apb_master_base_seq)

		`uvm_declare_p_sequencer(amiq_apb_master_sequencer)

		//constructor
		//@param name - name of the component instance
		function new(string name = "amiq_apb_master_base_seq");
			super.new(name);
		endfunction

	endclass

	//AMBA APB master simple sequence
	class amiq_apb_master_simple_seq extends amiq_apb_master_base_seq;

		//The address of the transfer
		rand amiq_apb_addr_t master_address;

		//Transfer direction
		rand amiq_apb_direction_t master_rw;

		//The read or write data
		rand amiq_apb_data_t master_data;

		`uvm_object_utils(amiq_apb_master_simple_seq)

		//constructor
		//@param name - name of the component instance
		function new(string name = "amiq_apb_master_simple_seq");
			super.new(name);
		endfunction

		//body task
		virtual task body();
			amiq_apb_master_drv_item master_seq_item = amiq_apb_master_drv_item::type_id::create("master_seq_item");

			start_item(master_seq_item);

			if(!(master_seq_item.randomize() with {
							master_seq_item.selected_slave < p_sequencer.agent_config.get_number_of_slaves();
							address == master_address;
							rw == master_rw;
							data == master_data;
						})) begin
				`uvm_fatal("AMIQ_APB_NOSEQITEM_MSEQ_ERR", "The sequence item could not be generated");
			end

			finish_item(master_seq_item);
		endtask
	endclass

`endif
