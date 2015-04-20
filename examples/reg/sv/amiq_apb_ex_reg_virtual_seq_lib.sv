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
 * NAME:        amiq_apb_ex_reg_virtual_seq_lib.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the virtual sequence library
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_VIRTUAL_SEQ_LIB_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_VIRTUAL_SEQ_LIB_SV


	//base virtual sequence
	class amiq_apb_ex_reg_virtual_sequence_base extends uvm_sequence;

		`uvm_object_utils(amiq_apb_ex_reg_virtual_sequence_base)

		`uvm_declare_p_sequencer(amiq_apb_ex_reg_virtual_sequencer)

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "SEQUENCE";
		endfunction

		//constructor
		//@param name - name of the object instance
		function new(string name = "");
			super.new(name);
		endfunction

		//task for randomly driving a reset
		task drive_reset();
			amiq_apb_vif_t dut_vif = p_sequencer.master_sequencer.agent_config.get_dut_vif();
			int unsigned delay;

			`uvm_info(get_id(), "Start driving reset", UVM_LOW)

			assert(std::randomize(delay) with {
						delay inside {[0:10]};
					});
			repeat(delay) @dut_vif.clk;

			assert(std::randomize(delay) with {
						delay inside {[0:10]};
					});
			#(delay);
			dut_vif.reset_n = 0;

			assert(std::randomize(delay) with {
						delay inside {[1:10]};
					});
			repeat(delay) @dut_vif.clk;

			assert(std::randomize(delay) with {
						delay inside {[0:10]};
					});
			#(delay);
			dut_vif.reset_n = 1;

			assert(std::randomize(delay) with {
						delay inside {[1:10]};
					});
			repeat(delay) @dut_vif.clk;
		endtask

	endclass

	//random sequence
	class amiq_apb_ex_reg_virtual_sequence_master_random extends amiq_apb_ex_reg_virtual_sequence_base;

		//number of APB items to send
		rand int unsigned number_of_items;

		//current item
		int current_item;

		constraint number_of_items_default {
			soft number_of_items inside {[500:1000]};
		}

		`uvm_object_utils(amiq_apb_ex_reg_virtual_sequence_master_random)

		//constructor
		//@param name - name of the object instance
		function new(string name = "");
			super.new(name);
		endfunction

		//body task
		virtual task body();
			amiq_apb_ex_reg_virtual_sequencer virtual_sequencer = p_sequencer;
			
			//number of registers
			int unsigned num_of_regs = virtual_sequencer.reg_block.data.size();
			
			for(current_item = 0; current_item < number_of_items; current_item++) begin
				amiq_apb_master_simple_seq master_sequence = amiq_apb_master_simple_seq::type_id::create("master_sequence");

				assert (master_sequence.randomize() with {
					master_address <= (num_of_regs * 4);
					}) else
					`uvm_fatal("random sequence", "Could not randomize item amiq_apb_master_simple_seq");
				master_sequence.start(p_sequencer.master_sequencer);
			end
		endtask
	endclass

	//random sequence
	class amiq_apb_ex_reg_virtual_sequence_slave_random extends amiq_apb_ex_reg_virtual_sequence_base;

		`uvm_object_utils(amiq_apb_ex_reg_virtual_sequence_slave_random)

		//constructor
		//@param name - name of the object instance
		function new(string name = "");
			super.new(name);
		endfunction

		//body task
		virtual task body();
			amiq_apb_slave_simple_seq slave_sequence = amiq_apb_slave_simple_seq::type_id::create("slave_sequence");

			assert (slave_sequence.randomize()) else
				`uvm_fatal("random sequence", "Could not randomize item slave_sequence");

			fork
				begin
					forever begin
						slave_sequence.start(p_sequencer.slave_sequencer);
					end
				end
			join_none
		endtask
	endclass


`endif

