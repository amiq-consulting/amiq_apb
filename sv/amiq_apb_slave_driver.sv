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
 * Description: AMBA APB slave driver
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_DRIVER_SV

	//AMBA APB slave driver
	class amiq_apb_slave_driver extends amiq_apb_driver#(.DRIVER_ITEM_REQ(amiq_apb_slave_drv_item));

		//casted agent configuration
		amiq_apb_slave_agent_config slave_agent_config;

		//pointer to DUT virtual interface
		local amiq_apb_vif_t dut_vif;

		`uvm_component_utils(amiq_apb_slave_driver)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_slave_driver", uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM start of simulation phase
		//@param phase - current phase
		virtual function void start_of_simulation_phase(input uvm_phase phase);
			super.start_of_simulation_phase(phase);
			assert ($cast(slave_agent_config, agent_config) == 1) else
				`uvm_fatal(get_id(), "Could not cast agent configuration to amiq_apb_slave_agent_config");
			dut_vif = agent_config.get_dut_vif();
		endfunction

		//function for handling reset
		virtual function void handle_reset();
			super.handle_reset();

			if(slave_agent_config.get_initialize_signals_at_signals() == 1) begin
				dut_vif.slverr <= 0;
				dut_vif.ready <= slave_agent_config.get_reset_value_for_ready();
			end
		endfunction

		//function to get the custom read data
		//@param transaction - transaction to be driven on the bus
		//@param address - current address on the bus
		//@param direction - current direction on the bus
		//@return read data
		virtual function amiq_apb_data_t get_read_data(amiq_apb_slave_drv_item transaction, amiq_apb_addr_t address, amiq_apb_direction_t direction);
			return (transaction.data & slave_agent_config.get_data_mask());
		endfunction

		//task for driving one transaction
		//@param transaction - transaction to be driven on the bus
		task drive_transaction(amiq_apb_slave_drv_item transaction);
			int unsigned driving_delay = slave_agent_config.get_driving_delay();

			forever begin
				@(posedge dut_vif.clk);
				if(((dut_vif.sel[slave_agent_config.get_slave_index()] === 1) && (dut_vif.enable === 0)) ||
						((dut_vif.sel[slave_agent_config.get_slave_index()] === 1) && (dut_vif.enable === 1) && (dut_vif.ready === 0))) begin
					break;
				end
			end

			if(transaction.wait_time > 0) begin
				#driving_delay;
				dut_vif.ready <= 0;

				for(int i = 0; i < transaction.wait_time; i++) begin
					@(posedge dut_vif.clk);
				end
			end

			#driving_delay;
			dut_vif.ready <= 1;
			dut_vif.rdata <= get_read_data(transaction, dut_vif.addr, amiq_apb_direction_t'(dut_vif.write));

			if(slave_agent_config.get_has_error_signal()) begin
				dut_vif.slverr <= bit'(transaction.has_error);
			end

			@(posedge dut_vif.clk);

			#driving_delay;
			dut_vif.slverr <= 0;

		endtask

	endclass

`endif
