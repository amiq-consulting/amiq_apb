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
 * MODULE:      amiq_apb_mon_item.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB monitored transfer item definition
 *******************************************************************************/

`ifndef AMIQ_APB_MON_ITEM_SV
	//protection against multiple includes
	`define AMIQ_APB_MON_ITEM_SV

	//AMBA APB transfer item definition
	class amiq_apb_mon_item extends amiq_apb_item;

		`uvm_object_utils(amiq_apb_mon_item)

		//error response
		amiq_apb_error_response_t has_error;

		//start time
		time start_time;

		//end time
		time end_time;

		//system clock period
		time sys_clock_period;

		//constructor
		//@param name - name of the object instance
		function new(string name = "amiq_apb_item");
			super.new(name);
		endfunction

		//function for getting the length of the transfer, in clock cycles
		//@return the length of the transfer, in clock cycles
		function int unsigned get_transfer_length();
			if((end_time >= (sys_clock_period + start_time)) && (sys_clock_period > 0)) begin
				return (1 + ((end_time - start_time) / sys_clock_period));
			end
			else begin
				return 0;
			end
		endfunction

		//function for getting the length of the wait state, in clock cycles
		//@return the length of the wait state, in clock cycles
		function int unsigned get_wait_state_length();
			int unsigned transfer_length = get_transfer_length();

			if(transfer_length > 0) begin
				AMIQ_APB_LEGAL_TRANSFER_LENGTH : assert (transfer_length >= 2) else
					`uvm_error(get_name(), $sformatf("The length of the transfer should be bigger of equal to 2 but found %0d", transfer_length))

				return (transfer_length - 2);
			end
			else begin
				return 0;
			end
		endfunction

		//function for getting the wait state
		//@return wait state
		function amiq_apb_transfer_type_t get_wait_state();
			if(get_wait_state_length() == 0) begin
				get_wait_state = WITHOUT_WAIT_STATE;
			end
			else begin
				get_wait_state = WITH_WAIT_STATE;
			end
		endfunction

		//converts the information containing in the instance of this class to an easy-to-read string
		//@return easy-to-read string with the information contained in the instance of this class
		virtual function string convert2string();
			return $sformatf("%s has_error: %s, [%0d..%0d]", super.convert2string(), has_error.name(), start_time, end_time);
		endfunction

	endclass

`endif
