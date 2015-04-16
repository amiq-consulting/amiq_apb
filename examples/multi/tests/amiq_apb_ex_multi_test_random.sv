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
 * NAME:        amiq_apb_ex_multi_test_random.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the random test.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_MULTI_TEST_RANDOM_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_MULTI_TEST_RANDOM_SV

	class amiq_apb_ex_multi_test_random extends amiq_apb_ex_multi_test_basic;

		`uvm_component_utils(amiq_apb_ex_multi_test_random)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM connect phase
		//@param phase - current phase
		virtual task run_phase(input uvm_phase phase);
			amiq_apb_ex_multi_virtual_sequence_slave_random slave0_seq;
			amiq_apb_ex_multi_virtual_sequence_slave_random slave1_seq;
			amiq_apb_ex_multi_virtual_sequence_master_random master_seq;

			phase.raise_objection(this, $sformatf("Start of test: %s", get_name()));

			slave0_seq = amiq_apb_ex_multi_virtual_sequence_slave_random::type_id::create("slave0_seq", this);
			slave0_seq.slave_index = 0;
			slave0_seq.start(env.sequencer);

			slave1_seq = amiq_apb_ex_multi_virtual_sequence_slave_random::type_id::create("slave1_seq", this);
			slave1_seq.slave_index = 1;
			slave1_seq.start(env.sequencer);

			master_seq = amiq_apb_ex_multi_virtual_sequence_master_random::type_id::create("master_seq", this);

			assert(master_seq.randomize()) else
				`uvm_fatal("TEST", "Could not randomize amiq_apb_ex_multi_virtual_sequence_master_random");

			fork
				begin
					master_seq.start(env.sequencer);
				end
				begin
					wait(master_seq.current_item >= (master_seq.number_of_items / 2));
					master_seq.drive_reset();
				end
			join

			phase.drop_objection(this,  $sformatf("End of test: %s", get_name()));
		endtask
	endclass

`endif

