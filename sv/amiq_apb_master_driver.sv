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
 * MODULE:      amiq_apb_master_driver.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB master driver
 *******************************************************************************/

`ifndef AMIQ_APB_MASTER_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_MASTER_DRIVER_SV

	//AMBA APB master driver
	class amiq_apb_master_driver extends amiq_apb_driver #(.DRIVER_ITEM_REQ(amiq_apb_master_drv_item));

		//casted agent configuration
		amiq_apb_master_agent_config master_agent_config;

		//pointer to DUT virtual interface
		local amiq_apb_vif_t dut_vif;

		`uvm_component_utils(amiq_apb_master_driver)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_master_driver", uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM start of simulation phase
		//@param phase - current phase
		virtual function void start_of_simulation_phase(input uvm_phase phase);
			super.start_of_simulation_phase(phase);
			assert ($cast(master_agent_config, agent_config) == 1) else
				`uvm_fatal(get_id(), "Could not cast agent configuration to amiq_apb_master_agent_config");

			dut_vif = master_agent_config.get_dut_vif();
		endfunction

		//function for handling reset
		virtual function void handle_reset();
			super.handle_reset();

			if(master_agent_config.get_initialize_signals_at_signals() == 1) begin
				dut_vif.sel <= 0;
				dut_vif.enable <= 0;
			end
		endfunction

		//task for driving one transaction
		//@param transaction - transaction to be driven on the bus
		virtual task drive_transaction(amiq_apb_master_drv_item transaction);
			int unsigned driving_delay = master_agent_config.get_driving_delay();

			`uvm_info(get_id(), $sformatf("Driving: %s", transaction.convert2string()), UVM_LOW)

			//Wait a time_delay before driving the signals
			#driving_delay;

			dut_vif.sel[transaction.selected_slave] <= 1;
			dut_vif.addr <= transaction.address & master_agent_config.get_address_mask();
			dut_vif.write <= transaction.rw;
			dut_vif.strb <= transaction.strobe & master_agent_config.get_strobe_mask();
			dut_vif.prot[0] <= bit'(transaction.first_level_protection);
			dut_vif.prot[1] <= bit'(transaction.second_level_protection);
			dut_vif.prot[2] <= bit'(transaction.third_level_protection);

			if(transaction.rw == WRITE) begin
				dut_vif.wdata <= transaction.data & master_agent_config.get_data_mask();
			end

			//Wait a clock cycle and after that assert enable signal
			@(posedge dut_vif.clk);

			//Wait a time_delay before driving the signals
			#driving_delay;

			dut_vif.enable <= 1;

			@(posedge dut_vif.clk);

			while(dut_vif.ready === 0) begin
				@(posedge dut_vif.clk);
			end

			//Wait a time_delay before driving the signals
			#driving_delay;

			//Drive enable and select signals low
			dut_vif.enable <= 0;
			dut_vif.sel[transaction.selected_slave] <= 0;

			for(int i = 0; i < transaction.trans_delay; i++) begin
				@(posedge dut_vif.clk);
			end
		endtask
	endclass

`endif
