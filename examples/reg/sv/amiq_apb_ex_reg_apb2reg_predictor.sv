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
 * NAME:        amiq_apb_ex_reg_apb2reg_predictor.sv
 * PROJECT:     amiq_ser
 * Description: This file contains the declaration of the register predictor
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_APB2REG_PREDICTOR_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_APB2REG_PREDICTOR_SV

	//register adapter
	class amiq_apb_ex_reg_apb2reg_predictor extends uvm_reg_predictor#(amiq_apb_mon_item);

		`uvm_component_utils(amiq_apb_ex_reg_apb2reg_predictor)

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "PREDICTOR";
		endfunction

		//constructor
		//@param name - name of the component instance
		function new(string name = "amiq_apb_ex_reg_apb2reg_predictor", uvm_component parent);
			super.new(name, parent);
		endfunction

		//input port implementation 
		//@param tr - incoming monitor item
		virtual function void write(amiq_apb_mon_item tr);
			if(tr.end_time != 0) begin
				if(tr.has_error == NO_ERROR) begin
					super.write(tr);
				end
			end
		endfunction

	endclass

`endif

