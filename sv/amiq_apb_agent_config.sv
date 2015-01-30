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
 * MODULE:      amiq_apb_agent_config.sv
 * PROJECT:     amiq_apb
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: Configuration class for agents - contains switches and address
 *              width and strobe width.
 *******************************************************************************/

`ifndef AMIQ_APB_AGENT_CONFIG_SV
	//protection against multiple includes
	`define AMIQ_APB_AGENT_CONFIG_SV

	//Configuration class for agents - contain switches
	class amiq_apb_agent_config extends uvm_component;

		//Active / passive agent type
		uvm_active_passive_enum active_passive = UVM_ACTIVE;

		//Address bus width
		int unsigned address_width = `AMIQ_APB_MAX_ADDR_WIDTH;

		//Data bus width
		int unsigned data_width = `AMIQ_APB_MAX_DATA_WIDTH;

		//Write strobe bus width
		int unsigned strobe_width = `AMIQ_APB_MAX_STROBE_WIDTH;

		//Time delay introduced for driving the signals
		int unsigned driving_delay = 0;

		//Switch to enable collecting coverage
		bit has_coverage = 1;

		//Indicates that the agent has or has not an error signal
		protected bit has_error_signal = 1;

		//Switch to enable amiq_apb_ready_low_maximum_time check
		protected bit en_ready_low_max_time = 1;

		//Switch to enable reset checks
		protected bit en_rst_checks = 1;

		//Switch to enable x/z checks
		protected bit en_x_z_checks = 1;

		//Switch to enable protocol checks
		protected bit en_protocol_checks = 1;

		//switch to initialize signals at reset
		bit initialize_signals_at_signals = 1;

		//AMBA APB interface
		amiq_apb_vif_t dut_vi;

		//function for getting the en_ready_low_max_time
		//@return en_ready_low_max_time
		function bit get_en_ready_low_max_time();
			return en_ready_low_max_time;
		endfunction

		//function for setting a new en_ready_low_max_time
		//@param en_ready_low_max_time - new value of en_ready_low_max_time
		function void set_en_ready_low_max_time(bit en_ready_low_max_time);
			this.en_ready_low_max_time = en_ready_low_max_time;
			if(dut_vi != null) begin
				dut_vi.en_ready_low_max_time = en_ready_low_max_time;
			end
		endfunction

		//function for getting the en_rst_checks
		//@return en_rst_checks
		function bit get_en_rst_checks();
			return en_rst_checks;
		endfunction

		//function for setting a new en_rst_checks
		//@param en_rst_checks - new value of en_rst_checks
		function void set_en_rst_checks(bit en_rst_checks);
			this.en_rst_checks = en_rst_checks;
			if(dut_vi != null) begin
				dut_vi.en_rst_checks = en_rst_checks;
			end
		endfunction

		//function for getting the has_error_signal
		//@return has_error_signal
		function bit get_has_error_signal();
			return has_error_signal;
		endfunction

		//function for setting a new has_error_signal
		//@param has_error_signal - new value of has_error_signal
		function void set_has_error_signal(bit has_error_signal);
			this.has_error_signal = has_error_signal;
			if(dut_vi != null) begin
				dut_vi.has_error_signal = has_error_signal;
			end
		endfunction

		//function for getting the en_x_z_checks
		//@return en_x_z_checks
		function bit get_en_x_z_checks();
			return en_x_z_checks;
		endfunction

		//function for setting a new en_x_z_checks
		//@param en_x_z_checks - new value of en_x_z_checks
		function void set_en_x_z_checks(bit en_x_z_checks);
			this.en_x_z_checks = en_x_z_checks;
			if(dut_vi != null) begin
				dut_vi.en_x_z_checks = en_x_z_checks;
			end
		endfunction

		//function for getting the en_protocol_checks
		//@return en_protocol_checks
		function bit get_en_protocol_checks();
			return en_protocol_checks;
		endfunction

		//function for setting a new en_protocol_checks
		//@param en_protocol_checks - new value of en_protocol_checks
		function void set_en_protocol_checks(bit en_protocol_checks);
			this.en_protocol_checks = en_protocol_checks;
			if(dut_vi != null) begin
				dut_vi.en_protocol_checks = en_protocol_checks;
			end
		endfunction

		//function to get the address mask based on its width
		//@return address mask
		function amiq_apb_addr_t get_address_mask();
			bit[`AMIQ_APB_MAX_ADDR_WIDTH:0] mask = 1;
			mask = mask << address_width;
			return (mask - 1);
		endfunction

		//function to get the data mask based on its width
		//@return data mask
		function amiq_apb_addr_t get_data_mask();
			bit[`AMIQ_APB_MAX_DATA_WIDTH:0] mask = 1;
			mask = mask << data_width;
			return (mask - 1);
		endfunction

		//function to get the strobe mask based on its width
		//@return strobe mask
		function amiq_apb_addr_t get_strobe_mask();
			bit[`AMIQ_APB_MAX_STROBE_WIDTH:0] mask = 1;
			mask = mask << strobe_width;
			return (mask - 1);
		endfunction

		`uvm_component_utils(amiq_apb_agent_config)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_agent_configs", uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM end of elaboration phase
		//@param phase - current phase
		function void end_of_elaboration_phase(input uvm_phase phase);
			super.end_of_elaboration_phase(phase);
			if(dut_vi != null) begin
				dut_vi.en_ready_low_max_time = en_ready_low_max_time;
				dut_vi.en_rst_checks = en_rst_checks;
				dut_vi.has_error_signal = has_error_signal;
				dut_vi.en_x_z_checks = en_x_z_checks;
				dut_vi.en_protocol_checks = en_protocol_checks;
			end
		endfunction

	endclass

`endif
