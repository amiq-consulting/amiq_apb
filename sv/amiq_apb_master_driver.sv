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
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB master driver
 *******************************************************************************/

`ifndef AMIQ_APB_MASTER_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_MASTER_DRIVER_SV

	//AMBA APB master driver
	class amiq_apb_master_driver extends amiq_apb_driver#(amiq_apb_master_drv_item);
		`uvm_component_utils(amiq_apb_master_driver)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_master_driver", uvm_component parent);
			super.new(name, parent);
		endfunction

		//function for handling reset
		virtual function void handle_reset();
			super.handle_reset();

			if(agent_config.initialize_signals_at_signals == 1) begin
				agent_config.dut_vi.sel <= 0;
				agent_config.dut_vi.enable <= 0;
			end
		endfunction

		//task for driving one transaction
		//@param transaction - transaction to be driven on the bus
		virtual task drive_transaction(amiq_apb_master_drv_item transaction);
			`uvm_info(get_id(), $sformatf("Driving: %s", transaction.convert2string()), UVM_LOW)

			//Wait a time_delay before driving the signals
			#agent_config.driving_delay;

			agent_config.dut_vi.sel[transaction.selected_slave] <= 1;
			agent_config.dut_vi.addr <= transaction.address & agent_config.get_address_mask();
			agent_config.dut_vi.write <= transaction.rw;
			agent_config.dut_vi.strb <= transaction.strobe & agent_config.get_strobe_mask();
			agent_config.dut_vi.prot[0] <= bit'(transaction.first_level_protection);
			agent_config.dut_vi.prot[1] <= bit'(transaction.second_level_protection);
			agent_config.dut_vi.prot[2] <= bit'(transaction.third_level_protection);

			if(transaction.rw == WRITE) begin
				agent_config.dut_vi.wdata <= transaction.data & agent_config.get_data_mask();
			end

			//Wait a clock cycle and after that assert enable signal
			@(posedge agent_config.dut_vi.clk);

			//Wait a time_delay before driving the signals
			#agent_config.driving_delay;

			agent_config.dut_vi.enable <= 1;

			@(posedge agent_config.dut_vi.clk);

			while(agent_config.dut_vi.ready === 0) begin
				@(posedge agent_config.dut_vi.clk);
			end

			//Wait a time_delay before driving the signals
			#agent_config.driving_delay;

			//Drive enable and select signals low
			agent_config.dut_vi.enable <= 0;
			agent_config.dut_vi.sel[transaction.selected_slave] <= 0;

			for(int i = 0; i < transaction.trans_delay; i++) begin
				@(posedge agent_config.dut_vi.clk);
			end
		endtask
	endclass

`endif
