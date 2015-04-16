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
 * NAME:        amiq_apb_ex_multi_scoreboard.sv
 * PROJECT:     amiq_apb
 * Description: Scoreboard to test that what it is driven is the same with
 *              the monitored item.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_MULTI_SCOREBOARD_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_MULTI_SCOREBOARD_SV

	`uvm_analysis_imp_decl(_master_mon)
	`uvm_analysis_imp_decl(_master_drv)
	`uvm_analysis_imp_decl(_slave_drv_0)
	`uvm_analysis_imp_decl(_slave_drv_1)

	//scoreboard class
	class amiq_apb_ex_multi_scoreboard extends uvm_component;

		uvm_analysis_imp_master_mon#(amiq_apb_mon_item, amiq_apb_ex_multi_scoreboard) input_port_master_mon;

		uvm_analysis_imp_master_drv#(amiq_apb_master_drv_item, amiq_apb_ex_multi_scoreboard) input_port_master_drv;
		uvm_analysis_imp_slave_drv_0#(amiq_apb_slave_drv_item, amiq_apb_ex_multi_scoreboard) input_port_slave_drv_0;
		uvm_analysis_imp_slave_drv_1#(amiq_apb_slave_drv_item, amiq_apb_ex_multi_scoreboard) input_port_slave_drv_1;

		//elements received from the master driver
		amiq_apb_master_drv_item master_drv_items[$];

		//elements received from the slave 0 driver
		amiq_apb_slave_drv_item slave_0_drv_items[$];

		//elements received from the slave 1 driver
		amiq_apb_slave_drv_item slave_1_drv_items[$];

		`uvm_component_utils(amiq_apb_ex_multi_scoreboard)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);

			input_port_master_mon = new("input_port_master_mon", this);
			input_port_master_drv = new("input_port_master_drv", this);
			input_port_slave_drv_0 = new("input_port_slave_drv_0", this);
			input_port_slave_drv_1 = new("input_port_slave_drv_1", this);
		endfunction

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "SCOREBOARD";
		endfunction

		//port implementation for data coming from master monitor
		virtual function void write_master_mon(amiq_apb_mon_item transaction);
			if(transaction.end_time != 0) begin
				if(master_drv_items.size() == 0) begin
					`uvm_fatal(get_id(), $sformatf("Received monitor item %s but there is no element in master_drv_items", transaction.convert2string()))
				end

				if(transaction.address != master_drv_items[0].address) begin
					`uvm_fatal(get_id(), $sformatf("address mismatch - exp: %X, rcv: %X", master_drv_items[0].address, transaction.address))
				end

				if(transaction.rw != master_drv_items[0].rw) begin
					`uvm_fatal(get_id(), $sformatf("direction mismatch - exp: %X, rcv: %X", master_drv_items[0].rw, transaction.rw))
				end

				if(transaction.rw == WRITE) begin
					if(transaction.data != master_drv_items[0].data) begin
						`uvm_fatal(get_id(), $sformatf("data mismatch - exp: %X, rcv: %X", master_drv_items[0].data, transaction.data))
					end
				end
				else begin
					if(transaction.selected_slave == 0) begin
						if(slave_0_drv_items.size() == 0) begin
							`uvm_fatal(get_id(), $sformatf("Received monitor item %s but there is no element in slave_0_drv_items", transaction.convert2string()))
						end

						if(transaction.data != slave_0_drv_items[0].data) begin
							`uvm_fatal(get_id(), $sformatf("data mismatch - exp: %X, rcv: %X", slave_0_drv_items[0].data, transaction.data))
						end
					end
					else begin
						if(slave_1_drv_items.size() == 0) begin
							`uvm_fatal(get_id(), $sformatf("Received monitor item %s but there is no element in slave_1_drv_items", transaction.convert2string()))
						end

						if(transaction.data != slave_1_drv_items[0].data) begin
							`uvm_fatal(get_id(), $sformatf("data mismatch - exp: %X, rcv: %X", slave_1_drv_items[0].data, transaction.data))
						end
					end
				end

				if(transaction.first_level_protection != master_drv_items[0].first_level_protection) begin
					`uvm_fatal(get_id(), $sformatf("first_level_protection mismatch - exp: %X, rcv: %X", master_drv_items[0].first_level_protection, transaction.first_level_protection))
				end

				if(transaction.second_level_protection != master_drv_items[0].second_level_protection) begin
					`uvm_fatal(get_id(), $sformatf("second_level_protection mismatch - exp: %X, rcv: %X", master_drv_items[0].second_level_protection, transaction.second_level_protection))
				end

				if(transaction.third_level_protection != master_drv_items[0].third_level_protection) begin
					`uvm_fatal(get_id(), $sformatf("third_level_protection mismatch - exp: %X, rcv: %X", master_drv_items[0].third_level_protection, transaction.third_level_protection))
				end

				if(transaction.strobe != master_drv_items[0].strobe) begin
					`uvm_fatal(get_id(), $sformatf("strobe mismatch - exp: %X, rcv: %X", master_drv_items[0].strobe, transaction.strobe))
				end

				if(transaction.selected_slave != master_drv_items[0].selected_slave) begin
					`uvm_fatal(get_id(), $sformatf("selected_slave mismatch - exp: %X, rcv: %X", master_drv_items[0].selected_slave, transaction.selected_slave))
				end

				if(transaction.selected_slave == 0) begin
					if(transaction.has_error != slave_0_drv_items[0].has_error) begin
						`uvm_fatal(get_id(), $sformatf("has_error mismatch - exp: %X, rcv: %X", slave_0_drv_items[0].has_error, transaction.has_error))
					end

					if(transaction.get_wait_state_length() != slave_0_drv_items[0].wait_time) begin
						`uvm_fatal(get_id(), $sformatf("wait_time mismatch - exp: %X, rcv: %X", slave_0_drv_items[0].wait_time, transaction.get_wait_state_length()))
					end

					void'(slave_0_drv_items.pop_front());
				end
				else begin
					if(transaction.has_error != slave_1_drv_items[0].has_error) begin
						`uvm_fatal(get_id(), $sformatf("has_error mismatch - exp: %X, rcv: %X", slave_1_drv_items[0].has_error, transaction.has_error))
					end

					if(transaction.get_wait_state_length() != slave_1_drv_items[0].wait_time) begin
						`uvm_fatal(get_id(), $sformatf("wait_time mismatch - exp: %X, rcv: %X", slave_1_drv_items[0].wait_time, transaction.get_wait_state_length()))
					end

					void'(slave_1_drv_items.pop_front());
				end

				void'(master_drv_items.pop_front());
			end
		endfunction

		//port implementation for data coming from master driver
		virtual function void write_master_drv(amiq_apb_master_drv_item transaction);
			master_drv_items.push_back(transaction);
		endfunction

		//port implementation for data coming from slave 0 driver
		virtual function void write_slave_drv_0(amiq_apb_slave_drv_item transaction);
			slave_0_drv_items.push_back(transaction);
		endfunction

		//port implementation for data coming from slave 1 driver
		virtual function void write_slave_drv_1(amiq_apb_slave_drv_item transaction);
			slave_1_drv_items.push_back(transaction);
		endfunction

		virtual function void check_phase(input uvm_phase phase);
			super.check_phase(phase);

			if(master_drv_items.size() > 0) begin
				`uvm_fatal("SCOREBOARD", $sformatf("There are still %0d elements in master_drv_items", master_drv_items.size()))
			end

			if(slave_0_drv_items.size() > 1) begin
				`uvm_fatal("SCOREBOARD", $sformatf("There are still %0d elements in slave_0_drv_items", slave_0_drv_items.size()))
			end

			if(slave_1_drv_items.size() > 1) begin
				`uvm_fatal("SCOREBOARD", $sformatf("There are still %0d elements in slave_1_drv_items", slave_1_drv_items.size()))
			end
		endfunction

		//function for handling reset
		virtual function void handle_reset();
			while(master_drv_items.size() > 0) begin
				void'(master_drv_items.pop_front());
			end
			while(slave_0_drv_items.size() > 0) begin
				void'(slave_0_drv_items.pop_front());
			end
			while(slave_1_drv_items.size() > 0) begin
				void'(slave_1_drv_items.pop_front());
			end
		endfunction

	endclass

`endif

