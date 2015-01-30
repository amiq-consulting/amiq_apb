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
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB base driver
 *******************************************************************************/

`ifndef AMIQ_APB_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_DRIVER_SV

	//AMBA APB base driver
	class amiq_apb_driver #(type DRIVER_ITEM=amiq_apb_base_item) extends uvm_driver#(DRIVER_ITEM);

		`uvm_component_param_utils(amiq_apb_driver#(DRIVER_ITEM))

		//Analysis port used to send forward the transfer item to be driven on the bus
		uvm_analysis_port #(DRIVER_ITEM) send_item;

		//Pointer to agent config class
		amiq_apb_agent_config agent_config;

		//process handle for main fork in drive transactions
		protected process process_drive_transactions;

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_driver", uvm_component parent);
			super.new(name, parent);
			send_item = new("send_item", this);
		endfunction

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "AMIQ_APB_DRV";
		endfunction

		//wait for reset to be finished
		virtual task wait_reset_end();
			@(posedge(agent_config.dut_vi.reset_n));
		endtask

		//UVM run phase
		//@param phase - current phase
		virtual task run_phase(uvm_phase phase);
			forever begin
				wait_reset_end();
				drive_transactions();
			end
		endtask

		//function for handling reset
		virtual function void handle_reset();
			if(process_drive_transactions != null) begin
				process_drive_transactions.kill();
				`uvm_info(get_id(), "killing process for drive_transactions() task...", UVM_MEDIUM);
			end
		endfunction

		//task for driving one transaction
		//@param transaction - transaction to be driven on the bus
		virtual task drive_transaction(DRIVER_ITEM transaction);

		endtask

		//task for driving all transactions
		virtual task drive_transactions();
			fork
				begin
					process_drive_transactions = process::self();

					`uvm_info(get_id(), "Starting drive_transactions()...", UVM_LOW);

					forever begin
						DRIVER_ITEM transaction;
						seq_item_port.get_next_item(transaction);
						send_item.write(transaction);

						drive_transaction(transaction);

						seq_item_port.item_done();
					end
				end
			join
		endtask

	endclass

`endif
