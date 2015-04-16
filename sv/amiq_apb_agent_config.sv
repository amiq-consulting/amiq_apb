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
 * Description: Configuration class for agents - contains switches and address
 *              width and strobe width.
 *******************************************************************************/

`ifndef AMIQ_APB_AGENT_CONFIG_SV
	//protection against multiple includes
	`define AMIQ_APB_AGENT_CONFIG_SV

	//Configuration class for agents - contain switches
	class amiq_apb_agent_config extends uvm_component;
		
		//switch to determine the active or the passive aspect of the agent
		protected uvm_active_passive_enum is_active = UVM_ACTIVE;

		//switch to determine if to enable or not the coverage
		protected bit has_coverage = 1;

		//switch to determine if to enable or not the checks
		protected bit has_checks = 1;

		//pointer to the DUT interface
		protected amiq_apb_vif_t dut_vif;
		
		//active level of reset signal
		protected bit reset_active_level = 0;

		//Address bus width
		protected int unsigned address_width = `AMIQ_APB_MAX_ADDR_WIDTH;

		//Data bus width
		protected int unsigned data_width = `AMIQ_APB_MAX_DATA_WIDTH;

		//Write strobe bus width
		protected int unsigned strobe_width = `AMIQ_APB_MAX_STROBE_WIDTH;

		//Time delay introduced for driving the signals
		protected int unsigned driving_delay = 0;

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
		protected bit initialize_signals_at_signals = 1;

		//function for getting the value of is_active field
		//@return is_active field value
		virtual function uvm_active_passive_enum get_is_active();
			return is_active;
		endfunction

		//function for setting a new value for is_active field
		//@param is_active - new value of the is_active field
		virtual function void set_is_active(uvm_active_passive_enum is_active);
			this.is_active = is_active;
		endfunction
		
		//function for getting the value of has_coverage field
		//@return has_coverage field value
		virtual function bit get_has_coverage();
			return has_coverage;
		endfunction

		//function for setting a new value for has_coverage field
		//@param has_coverage - new value of the has_coverage field
		virtual function void set_has_coverage(bit has_coverage);
			this.has_coverage = has_coverage;
		endfunction

		//function for getting the value of has_checks field
		//@return has_checks field value
		virtual function bit get_has_checks();
			return has_checks;
		endfunction

		//function for setting a new value for has_checks field
		//@param has_checks - new value of the has_checks field
		virtual function void set_has_checks(bit has_checks);
			this.has_checks = has_checks;
		endfunction

		//function for getting the value of dut_vif field
		//@return dut_vif field value
		virtual function amiq_apb_vif_t get_dut_vif();
			return dut_vif;
		endfunction

		//function for setting a new value for dut_vif field
		//@param dut_vif - new value of the dut_vif field
		virtual function void set_dut_vif(amiq_apb_vif_t dut_vif);
			this.dut_vif = dut_vif;
		endfunction

		//function for getting the value of reset_active_level field
		//@return reset_active_level field value
		virtual function bit get_reset_active_level();
			return reset_active_level;
		endfunction

		//function for setting a new value for reset_active_level field
		//@param reset_active_level - new value of the reset_active_level field
		virtual function void set_reset_active_level(bit reset_active_level);
			this.reset_active_level = reset_active_level;
		endfunction
		
		//function for getting the address_width
		//@return address_width
		function int unsigned get_address_width();
			return address_width;
		endfunction

		//function for setting a new address_width
		//@param address_width - new value of address_width
		function void set_address_width(int unsigned address_width);
			this.address_width = address_width;
		endfunction

		//function for getting the data_width
		//@return data_width
		function int unsigned get_data_width();
			return data_width;
		endfunction

		//function for setting a new data_width
		//@param data_width - new value of data_width
		function void set_data_width(int unsigned data_width);
			this.data_width = data_width;
		endfunction

		//function for getting the strobe_width
		//@return strobe_width
		function int unsigned get_strobe_width();
			return strobe_width;
		endfunction

		//function for setting a new strobe_width
		//@param strobe_width - new value of strobe_width
		function void set_strobe_width(int unsigned strobe_width);
			this.strobe_width = strobe_width;
		endfunction

		//function for getting the driving_delay
		//@return driving_delay
		function int unsigned get_driving_delay();
			return driving_delay;
		endfunction

		//function for setting a new driving_delay
		//@param driving_delay - new value of driving_delay
		function void set_driving_delay(int unsigned driving_delay);
			this.driving_delay = driving_delay;
		endfunction

		//function for getting the initialize_signals_at_signals
		//@return initialize_signals_at_signals
		function int unsigned get_initialize_signals_at_signals();
			return initialize_signals_at_signals;
		endfunction

		//function for setting a new initialize_signals_at_signals
		//@param initialize_signals_at_signals - new value of initialize_signals_at_signals
		function void set_initialize_signals_at_signals(int unsigned initialize_signals_at_signals);
			this.initialize_signals_at_signals = initialize_signals_at_signals;
		endfunction

		//function for getting the en_ready_low_max_time
		//@return en_ready_low_max_time
		function bit get_en_ready_low_max_time();
			return en_ready_low_max_time;
		endfunction

		//function for setting a new en_ready_low_max_time
		//@param en_ready_low_max_time - new value of en_ready_low_max_time
		function void set_en_ready_low_max_time(bit en_ready_low_max_time);
			this.en_ready_low_max_time = en_ready_low_max_time;
			if(dut_vif != null) begin
				dut_vif.en_ready_low_max_time = en_ready_low_max_time;
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
			if(dut_vif != null) begin
				dut_vif.en_rst_checks = en_rst_checks;
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
			if(dut_vif != null) begin
				dut_vif.has_error_signal = has_error_signal;
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
			if(dut_vif != null) begin
				dut_vif.en_x_z_checks = en_x_z_checks;
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
			if(dut_vif != null) begin
				dut_vif.en_protocol_checks = en_protocol_checks;
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

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "AGT_CFG";
		endfunction

		`uvm_component_utils(amiq_apb_agent_config)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_agent_configs", uvm_component parent);
			super.new(name, parent);
			set_reset_active_level(0);
		endfunction

		//UVM start of simulation phase
		//@param phase - current phase
		virtual function void start_of_simulation_phase(input uvm_phase phase);
			super.start_of_simulation_phase(phase);
			
			assert (dut_vif != null) else
				`uvm_fatal(get_id(), "The pointer to the DUT interface is null - please make sure you set it via set_dut_vif() function before \"Start of Simulation\" phase!");
			
			dut_vif.en_ready_low_max_time = en_ready_low_max_time;
			dut_vif.en_rst_checks = en_rst_checks;
			dut_vif.has_error_signal = has_error_signal;
			dut_vif.en_x_z_checks = en_x_z_checks;
			dut_vif.en_protocol_checks = en_protocol_checks;
		endfunction

		//task for waiting the reset to start
		virtual task wait_reset_start();
			if(reset_active_level == 0) begin
				@(negedge dut_vif.reset_n);
			end
			else begin
				@(posedge dut_vif.reset_n);
			end
		endtask

		//task for waiting the reset to be finished
		virtual task wait_reset_end();
			if(reset_active_level == 0) begin
				@(posedge dut_vif.reset_n);
			end
			else begin
				@(negedge dut_vif.reset_n);
			end
		endtask
		
	endclass

`endif
