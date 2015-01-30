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
 * MODULE:      amiq_apb_slave_driver.sv
 * PROJECT:     amiq_apb
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB slave driver
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_DRIVER_SV

	//AMBA APB slave driver
	class amiq_apb_slave_driver extends amiq_apb_driver#(amiq_apb_slave_drv_item);

		//Pointer to slave agent config class
		amiq_apb_slave_agent_config slave_agent_config;

		`uvm_component_utils(amiq_apb_slave_driver)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_slave_driver", uvm_component parent);
			super.new(name, parent);
		endfunction

		//function for handling reset
		virtual function void handle_reset();
			super.handle_reset();

			if(agent_config.initialize_signals_at_signals == 1) begin
				agent_config.dut_vi.slverr <= 0;
				agent_config.dut_vi.ready <= slave_agent_config.reset_value_for_ready;
			end
		endfunction

		//function to get the custom read data
		//@param transaction - transaction to be driven on the bus
		//@param address - current address on the bus
		//@param direction - current direction on the bus
		//@return read data
		virtual function amiq_apb_data_t get_read_data(amiq_apb_slave_drv_item transaction, amiq_apb_addr_t address, amiq_apb_direction_t direction);
			return (transaction.data & agent_config.get_data_mask());
		endfunction

		//task for driving one transaction
		//@param transaction - transaction to be driven on the bus
		task drive_transaction(amiq_apb_slave_drv_item transaction);

			forever begin
				@(posedge agent_config.dut_vi.clk);
				if(((agent_config.dut_vi.sel[slave_agent_config.slave_index] === 1) && (agent_config.dut_vi.enable === 0)) ||
						((agent_config.dut_vi.sel[slave_agent_config.slave_index] === 1) && (agent_config.dut_vi.enable === 1) && (agent_config.dut_vi.ready === 0))) begin
					break;
				end
			end

			if(transaction.wait_time > 0) begin
				#agent_config.driving_delay;
				agent_config.dut_vi.ready <= 0;

				for(int i = 0; i < transaction.wait_time; i++) begin
					@(posedge agent_config.dut_vi.clk);
				end
			end

			#agent_config.driving_delay;
			agent_config.dut_vi.ready <= 1;
			agent_config.dut_vi.rdata <= get_read_data(transaction, agent_config.dut_vi.addr, amiq_apb_direction_t'(agent_config.dut_vi.write));

			if(agent_config.get_has_error_signal()) begin
				agent_config.dut_vi.slverr <= bit'(transaction.has_error);
			end

			@(posedge agent_config.dut_vi.clk);

			#agent_config.driving_delay;
			agent_config.dut_vi.slverr = 0;

		endtask

		//UVM end of elaboration phase
		//@param phase - current phase
		function void end_of_elaboration_phase(input uvm_phase phase);
			super.end_of_elaboration_phase(phase);
			assert ($cast(slave_agent_config, agent_config)) else
			`uvm_fatal(get_id(), "Could not cast to slave agent configuration");
		endfunction

	endclass

`endif
