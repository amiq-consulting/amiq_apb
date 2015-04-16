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
 * MODULE:      amiq_apb_coverage.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB agent coverage collector
 *******************************************************************************/

`ifndef AMIQ_APB_COVERAGE_SV
	//protection against multiple includes
	`define AMIQ_APB_COVERAGE_SV

	`uvm_analysis_imp_decl(_item_from_mon)

	//AMBA APB agent coverage collector
	class amiq_apb_coverage extends uvm_component;

		//pointer to the agent configuration class
		amiq_apb_agent_config agent_config;

		//port for receiving items collected by the monitor
		uvm_analysis_imp_item_from_mon#(amiq_apb_mon_item, amiq_apb_coverage) item_from_mon_port;

		`uvm_component_utils(amiq_apb_coverage)
		
		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "COV";
		endfunction

		//consecutive collected items
		protected amiq_apb_mon_item collected_items[$];

		//function for getting the delay between two consecutive transfers
		//@return the delay between two consecutive transfers
		protected function int unsigned get_delay_between_transfers();
			AMIQ_APB_ALGORITHM_ERROR : assert (collected_items.size() == 2) else
				`uvm_fatal("COVERAGE", $sformatf("Expecting collected_items.size() = 2 but found %0d", collected_items.size()))

			return (((collected_items[1].start_time - collected_items[0].end_time) /  collected_items[0].sys_clock_period) - 1);
		endfunction

		//Cover the current item
		covergroup cover_item with function sample(amiq_apb_mon_item collected_item);
			option.per_instance = 1;

			//Cover the direction
			direction : coverpoint collected_item.rw {
				type_option.comment = "Direction of the APB access";
			}

			//Cover the transition for direction
			trans_direction : coverpoint collected_item.rw {
				bins direction_trans[] = (READ, WRITE => READ, WRITE);
				type_option.comment = "Transitions of APB direction";
			}

			//Cover the first level of protection
			first_level_protection : coverpoint collected_item.first_level_protection {
				type_option.comment = "First level protection of APB access";
			}

			//Cover the transition for the first level of protection
			trans_first_level_protection : coverpoint collected_item.first_level_protection {
				bins trans_first_level_protection[] = (NORMAL_ACCESS, PRIVILEGED_ACCESS => NORMAL_ACCESS, PRIVILEGED_ACCESS);
				type_option.comment = "Transitions of the first level protection of APB access";
			}

			//Cover the second level of protection
			second_level_protection : coverpoint collected_item.second_level_protection {
				type_option.comment = "Second level protection of APB access";
			}

			//Cover the transition for the second level of protection
			trans_second_level_protection : coverpoint collected_item.second_level_protection {
				bins trans_second_level_protection[] = (SECURE_ACCESS, NON_SECURE_ACCESS => SECURE_ACCESS, NON_SECURE_ACCESS);
				type_option.comment = "Transitions of the second level protection of APB access";
			}

			//Cover the third level of protection
			third_level_protection : coverpoint collected_item.third_level_protection {
				type_option.comment = "Third level protection of APB access";
			}

			//Cover the transition for the third level of protection
			trans_third_level_protection : coverpoint collected_item.third_level_protection {
				bins trans_third_level_protection[] = (DATA_ACCESS, INSTRUCTION_ACCESS => DATA_ACCESS, INSTRUCTION_ACCESS);
				type_option.comment = "Transitions of the third level protection of APB access";
			}

			//Cover the cross between the first level of protection and the direction
			tr_first_level_protection_x_direction : cross first_level_protection, direction;

			//Cover the cross between the second level of protection and the direction
			tr_second_level_protection_x_direction : cross second_level_protection, direction;

			//Cover the cross between the third level of protection and the direction
			tr_third_level_protection_x_direction : cross third_level_protection, direction;

			//Cover the fact that the transfer has or has not an error response
			error_response : coverpoint collected_item.has_error {
				type_option.comment = "Error response of APB access";
			}

			//Cover the transition for error response
			trans_error_response : coverpoint collected_item.has_error {
				bins error_response_trans[] = (NO_ERROR, WITH_ERROR => NO_ERROR, WITH_ERROR);
				type_option.comment = "Transitions of error response of APB access";
			}

			//Cover the cross between the error response and the direction
			error_response_x_direction : cross error_response, direction;

			//Cover the strobe values
			strobe : coverpoint collected_item.strobe {
				type_option.comment = "Strobe of APB access";
			}

			//Cover the cross between the strobe and the direction
			tr_strobe_x_direction : cross strobe, direction {
				ignore_bins ig_values = binsof(strobe) intersect {[1:15]} && binsof(direction) intersect {READ};
			}

			//Cover the fact that the transfer has or has not wait-states
			transfer_type : coverpoint collected_item.get_wait_state();

			//Cover the transition for wait-states
			trans_transfer_type : coverpoint collected_item.get_wait_state() {
				bins transfer_type_trans[] = (WITHOUT_WAIT_STATE, WITH_WAIT_STATE => WITHOUT_WAIT_STATE, WITH_WAIT_STATE);
			}

			//Cover the cross between the transfer type (with or without wait-states) and the direction
			transfer_type_x_direction  : cross transfer_type, direction;

			//Cover the wdata bits
			`cvr_multiple_32_bits(wdata, collected_item.data, iff(collected_item.rw == WRITE))

			//Cover the rdata bits
			`cvr_multiple_32_bits(rdata, collected_item.data, iff((collected_item.rw == READ) && (collected_item.has_error == NO_ERROR)))

			//Cover the addr bits
			`cvr_multiple_32_bits(addr, collected_item.address, )

			//Cover the wait-state duration
			wait_state_length : coverpoint collected_item.get_wait_state_length() {
				bins no_wait_state = {0};
				bins small_wait_state_length[] = {[1:10]};
				bins medium_wait_state_length[1] = {[11:50]};
				bins big_wait_state_length[1] = {[51:$]};
			}

			//Cover the transfer length
			transfer_length_units : coverpoint collected_item.get_transfer_length() {
				bins small_transfer_length[] = {[2:12]};
				bins medium_transfer_length[1] = {[13:52]};
				bins big_transfer_length[1] = {[53:$]};
			}
		endgroup

		//Cover the delay between two transfers
		covergroup cover_delay_between_transfers;
			option.per_instance = 1;

			//Cover the delays between transfer
			transfer_delay_units : coverpoint get_delay_between_transfers() {
				bins back2back[] = {0};
				bins small_delays[1] = {[1:10]};
				bins medium_delays[1] = {[11:50]};
				bins big_delays[1] = {[51:100]};
			}

		endgroup

		//Cover how many clock cycle reset lasts
		covergroup cover_reset_length with function sample(int unsigned reset_length);
			option.per_instance = 1;

			reset_time_units : coverpoint reset_length {
				bins short[] = {[1:5]};
				bins long[1] = {[6:$]};
			}
		endgroup

		//function for getting the bus state at reset
		//@return the bus state at reset
		protected function amiq_apb_bus_state_t get_bus_state();
			get_bus_state = IDLE;

			if(collected_items.size() != 0) begin
				amiq_apb_mon_item last_item = collected_items[collected_items.size() - 1];

				if(last_item.end_time == 0) begin
					if($time - last_item.start_time < (2 * last_item.sys_clock_period)) begin
						get_bus_state = SETUP;
					end
					else begin
						get_bus_state = ACCESS;
					end
				end
			end
		endfunction

		covergroup cover_bus_state_at_reset;
			option.per_instance = 1;

			bus_state_on_reset : coverpoint get_bus_state();
		endgroup

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_coverage", uvm_component parent);
			super.new(name, parent);
			
			item_from_mon_port = new("item_from_mon_port", this);

			cover_item = new();
			cover_item.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_item"));

			cover_reset_length = new();
			cover_reset_length.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_reset_length"));

			cover_bus_state_at_reset = new();
			cover_bus_state_at_reset.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_bus_state_at_reset"));

			cover_delay_between_transfers = new();
			cover_delay_between_transfers.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_delay_between_transfers"));

		endfunction

		//UVM build phase
		//@param phase - current phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
		endfunction

		//UVM run phase
		//@param phase - current phase
		task run_phase(uvm_phase phase);
			fork
				collect_reset_time_units();
			join_none
		endtask

		//function for handling reset
		virtual function void handle_reset();
			cover_bus_state_at_reset.sample();
			while(collected_items.size() > 0) begin
				void'(collected_items.pop_front());
			end
		endfunction

		//Task used to collect how many clock cycles a reset lasts
		task collect_reset_time_units();
			amiq_apb_vif_t dut_vif = agent_config.get_dut_vif();

			forever @(negedge dut_vif.reset_n)
				begin
					int unsigned reset_length = 0;

					//Collect the reset_length
					while(dut_vif.reset_n === 0) begin
						reset_length = reset_length + 1;

						@(posedge dut_vif.clk);
					end

					cover_reset_length.sample(reset_length);
				end
		endtask

		//Overwrite the write method in order to cover the transfer item
		//@param transfer APB item received from the monitor
		virtual function void write_item_from_mon(amiq_apb_mon_item transfer);
			if(transfer.end_time != 0) begin
				cover_item.sample(transfer);

				begin
					bit found_item = 0;
					for(int i = 0; i < collected_items.size(); i++) begin
						if(collected_items[i].start_time == transfer.start_time) begin
							collected_items[i] = transfer;
							found_item = 1;
							break;
						end
					end

					AMIQ_APB_ALGORITHM_ERROR : assert (found_item == 1) else
						`uvm_fatal("COVERAGE", $sformatf("Did not found item in collected_items: %s", transfer.convert2string()));

				end
			end
			else begin
				collected_items.push_back(transfer);

				while(collected_items.size() > 2) begin
					void'(collected_items.pop_front());
				end

				if(collected_items.size() == 2) begin
					cover_delay_between_transfers.sample();
				end
			end
		endfunction
	endclass

`endif
