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
 * NAME:        amiq_apb_ex_reg_reg_block.sv
 * PROJECT:     amiq_ser
 * Description: This file contains the definitions of the registers block
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_REG_BLOCK_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_REG_BLOCK_SV

//register block
class amiq_apb_ex_reg_reg_block extends uvm_reg_block;

	`uvm_object_utils(amiq_apb_ex_reg_reg_block)

	//data registers
	rand amiq_apb_ex_reg_reg_data data[];

	//constructor
	//@param name - name of the component instance
	function new(string name = "amiq_apb_ex_reg_reg_block");
		super.new(name, 1);
	endfunction

	//build function
	virtual function void build();
		data = new[128];

		for(int i = 0; i < data.size(); i++) begin
			data[i] = amiq_apb_ex_reg_reg_data::type_id::create($sformatf("data[%0d]", i));
			data[i].configure(this, null, "");
			data[i].build();
		end

		default_map = create_map("map", 'h0, 4, UVM_LITTLE_ENDIAN);
		default_map.set_check_on_read(1);

		for(int i = 0; i < data.size(); i++) begin
			default_map.add_reg(data[i], (i * 4), "RW");
		end

		lock_model();
	endfunction

endclass

`endif

