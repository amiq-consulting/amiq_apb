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
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB agent monitor; in the environment there is a common
 *              monitor class for both agents
 *******************************************************************************/

`ifndef AMIQ_MONITOR_SV
	//protection against multiple includes
	`define AMIQ_MONITOR_SV

	//AMBA APB agent monitor
	class amiq_apb_monitor extends uvm_monitor;
		`uvm_component_utils(amiq_apb_monitor)

		//Pointer to agent configuration
		amiq_apb_agent_config agent_config;

		//Analysis port used to send forward the transfer item collected
		uvm_analysis_port #(amiq_apb_mon_item) send_item;

		//Process used in collect_transactions task
		protected process process_collect_transactions;

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "AMIQ_APB_MONITOR";
		endfunction

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_monitor", uvm_component parent);
			super.new(name, parent);
			send_item = new("send_item", this);
		endfunction

		//UVM run phase
		//@param phase - current phase
		virtual task run_phase(uvm_phase phase);
			forever begin
				wait_reset_end();
				collect_transactions();
			end
		endtask

		//Reset handler for monitor; the monitor should drop the item on reset
		virtual function void handle_reset();
			if(process_collect_transactions != null) begin
				process_collect_transactions.kill();
			end
		endfunction

		//wait for reset to be finished
		virtual task wait_reset_end();
			@(posedge(agent_config.dut_vi.reset_n));
		endtask

		//task for collecting one transaction
		virtual task collect_transaction();
			amiq_apb_mon_item item_collected;

			//Wait until a transfer is initialized
			while (agent_config.dut_vi.sel === 0) begin
				@(posedge agent_config.dut_vi.clk);
			end

			//Create a new item_collected
			item_collected = amiq_apb_mon_item::type_id::create("item_collected");
			item_collected.start_time = $time;
			item_collected.address = agent_config.dut_vi.addr & agent_config.get_address_mask();
			item_collected.strobe = agent_config.dut_vi.strb & agent_config.get_strobe_mask();
			item_collected.first_level_protection = amiq_apb_first_level_protection_t'(agent_config.dut_vi.prot[0]);
			item_collected.second_level_protection = amiq_apb_second_level_protection_t'(agent_config.dut_vi.prot[1]);
			item_collected.third_level_protection = amiq_apb_third_level_protection_t'(agent_config.dut_vi.prot[2]);
			item_collected.rw = amiq_apb_direction_t'(agent_config.dut_vi.write);
			item_collected.selected_slave = $clog2(agent_config.dut_vi.sel);

			if(item_collected.rw == WRITE) begin
				item_collected.data = agent_config.dut_vi.wdata & agent_config.get_data_mask();
			end

			//Send the head of a transfer
			send_item.write(item_collected);

			//Wait a clock cycle (in this clock cycle enable must be asserted)
			@(posedge agent_config.dut_vi.clk);
			item_collected.sys_clock_period = $time - item_collected.start_time;

			//Wait until the slave is ready to end a transfer
			while(agent_config.dut_vi.ready === 0) begin
				@(posedge agent_config.dut_vi.clk);
			end

			if(agent_config.get_has_error_signal()) begin
				item_collected.has_error = amiq_apb_error_response_t'(agent_config.dut_vi.slverr);
				if(item_collected.rw == READ) begin
					item_collected.data = agent_config.dut_vi.rdata & agent_config.get_data_mask();
				end
			end

			item_collected.end_time = $time;

			`uvm_info(get_id(), $sformatf("Collected item: %s", item_collected.convert2string()), UVM_LOW)

			send_item.write(item_collected);

			@(posedge agent_config.dut_vi.clk);
		endtask

		//Task used for collecting transfer from the bus
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

	endclass

`endif
