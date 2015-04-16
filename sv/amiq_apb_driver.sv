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
 * MODULE:      amiq_apb_driver.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB driver
 *******************************************************************************/

`ifndef AMIQ_APB_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_DRIVER_SV

	//AMBA APB driver
	class amiq_apb_driver #(type DRIVER_ITEM_REQ=uvm_sequence_item) extends uvm_driver#(.REQ(DRIVER_ITEM_REQ), .RSP(DRIVER_ITEM_REQ));
		
		//pointer to the agent configuration class
		amiq_apb_agent_config agent_config;

		//port for sending the item to be driven on bus
		uvm_analysis_port#(DRIVER_ITEM_REQ) output_port;

		//process for drive_transactions() task
		protected process process_drive_transactions;
		
		`uvm_component_param_utils(amiq_apb_driver#(DRIVER_ITEM_REQ))

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_driver", uvm_component parent);
			super.new(name, parent);
			output_port = new("output_port", this);
		endfunction
		
		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "DRV";
		endfunction

		//task for waiting the reset to be finished
		virtual task wait_reset_end();
			agent_config.wait_reset_end();
		endtask

		//function for handling reset
		virtual function void handle_reset();
			if(process_drive_transactions != null) begin
				process_drive_transactions.kill();
				`uvm_info(get_id(), "killing process for drive_transactions() task...", UVM_MEDIUM);
			end
		endfunction

		//task for driving one transaction
		virtual task drive_transaction(DRIVER_ITEM_REQ transaction);
			`uvm_fatal(get_id(), $sformatf("You must implement drive_transaction() task from %s(%s)", get_full_name(), get_type_name()))
		endtask

		//task for driving all transactions
		virtual task drive_transactions();
			fork
				begin
					process_drive_transactions = process::self();
					`uvm_info(get_id(), "Starting drive_transactions()...", UVM_LOW);

					forever begin
						DRIVER_ITEM_REQ transaction;

						seq_item_port.get_next_item(transaction);
						output_port.write(transaction);

						drive_transaction(transaction);

						seq_item_port.item_done();
					end
				end
			join
		endtask

		//UVM start of simulation phase
		//@param phase - current phase
		virtual function void start_of_simulation_phase(input uvm_phase phase);
			super.start_of_simulation_phase(phase);

			assert (agent_config != null) else
				`uvm_fatal(get_id(), "The pointer to the agent configuration is null - please make sure you set agent_config before \"Start of Simulation\" phase!");
		endfunction

		//UVM run phase
		//@param phase - current phase
		task run_phase(uvm_phase phase);
			forever begin
				fork
					begin
						wait_reset_end();
						drive_transactions();
						disable fork;
					end
				join
			end
		endtask
		
	endclass

`endif
