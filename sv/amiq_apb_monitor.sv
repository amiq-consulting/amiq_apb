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
 * MODULE:      amiq_monitor.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB agent monitor; in the environment there is a common
 *              monitor class for both agents
 *******************************************************************************/

`ifndef AMIQ_MONITOR_SV
	//protection against multiple includes
	`define AMIQ_MONITOR_SV

	//AMBA APB agent monitor
	class amiq_apb_monitor extends uvm_monitor;

		//agent configuration
		amiq_apb_agent_config agent_config;

		//process for collect_transactions() task
		protected process process_collect_transactions;

		//port for sending the collected item
		uvm_analysis_port#(amiq_apb_mon_item) output_port;

		`uvm_component_utils(amiq_apb_monitor)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_monitor", uvm_component parent);
			super.new(name, parent);
			output_port = new("output_port", this);
		endfunction

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "MON";
		endfunction

		//UVM start of simulation phase
		//@param phase - current phase
		virtual function void start_of_simulation_phase(input uvm_phase phase);
			super.start_of_simulation_phase(phase);
			
			assert (agent_config != null) else
				`uvm_fatal(get_id(), "The pointer to the agent configuration is null - please make sure you set agent_config before \"Start of Simulation\" phase!");
		endfunction

		//task for collecting one transaction
		virtual task collect_transaction();
			amiq_apb_vif_t dut_vif = agent_config.get_dut_vif();

			amiq_apb_mon_item item_collected;

			//Wait until a transfer is initialized
			while (dut_vif.sel === 0) begin
				@(posedge dut_vif.clk);
			end

			//Create a new item_collected
			item_collected = amiq_apb_mon_item::type_id::create("item_collected");
			item_collected.start_time = $time;
			item_collected.address = dut_vif.addr & agent_config.get_address_mask();
			item_collected.strobe = dut_vif.strb & agent_config.get_strobe_mask();
			item_collected.first_level_protection = amiq_apb_first_level_protection_t'(dut_vif.prot[0]);
			item_collected.second_level_protection = amiq_apb_second_level_protection_t'(dut_vif.prot[1]);
			item_collected.third_level_protection = amiq_apb_third_level_protection_t'(dut_vif.prot[2]);
			item_collected.rw = amiq_apb_direction_t'(dut_vif.write);
			item_collected.selected_slave = $clog2(dut_vif.sel);

			if(item_collected.rw == WRITE) begin
				item_collected.data = dut_vif.wdata & agent_config.get_data_mask();
			end

			//Send the head of a transfer
			output_port.write(item_collected);

			//Wait a clock cycle (in this clock cycle enable must be asserted)
			@(posedge dut_vif.clk);
			item_collected.sys_clock_period = $time - item_collected.start_time;

			//Wait until the slave is ready to end a transfer
			while(dut_vif.ready === 0) begin
				@(posedge dut_vif.clk);
			end

			if(agent_config.get_has_error_signal()) begin
				item_collected.has_error = amiq_apb_error_response_t'(dut_vif.slverr);
				if(item_collected.rw == READ) begin
					item_collected.data = dut_vif.rdata & agent_config.get_data_mask();
				end
			end

			item_collected.end_time = $time;

			`uvm_info(get_id(), $sformatf("Collected item: %s", item_collected.convert2string()), UVM_LOW)

			output_port.write(item_collected);

			@(posedge dut_vif.clk);
		endtask

		//task for waiting the reset to be finished
		virtual task wait_reset_end();
			agent_config.wait_reset_end();
		endtask

		//task for collecting all transactions
		virtual task collect_transactions();
			fork
				begin
					process_collect_transactions = process::self();

					`uvm_info(get_id(), "Starting collect_transactions()...", UVM_LOW);

					forever begin
						collect_transaction();
					end
				end
			join
		endtask

		//function for handling reset
		virtual function void handle_reset();
			if(process_collect_transactions != null) begin
				process_collect_transactions.kill();
				`uvm_info(get_id(), "killing process for collect_transactions() task...", UVM_MEDIUM);
			end
		endfunction

		//UVM run phase
		//@param phase - current phase
		virtual task run_phase(uvm_phase phase);
			forever begin
				fork
					begin
						wait_reset_end();
						collect_transactions();
						disable fork;
					end
				join
			end
		endtask

	endclass

`endif
