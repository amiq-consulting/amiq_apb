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
 * MODULE:      amiq_apb_ex_reg_slave_driver.sv
 * PROJECT:     amiq_apb
 * Description: Custom AMBA APB slave driver for returning data from register model 
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_SLAVE_DRIVER_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_SLAVE_DRIVER_SV

	//AMBA APB slave driver
	class amiq_apb_ex_reg_slave_driver extends amiq_apb_slave_driver;

		//pointer to the register block
		amiq_apb_ex_reg_reg_block reg_block;

		`uvm_component_utils(amiq_apb_ex_reg_slave_driver)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_ex_reg_slave_driver", uvm_component parent);
			super.new(name, parent);
		endfunction

		//function to get the custom read data
		//@param transaction - transaction to be driven on the bus
		//@param address - current address on the bus
		//@param direction - current direction on the bus
		//@return read data
		virtual function amiq_apb_data_t get_read_data(amiq_apb_slave_drv_item transaction, amiq_apb_addr_t address, amiq_apb_direction_t direction);
			uvm_reg register = reg_block.default_map.get_reg_by_offset(address, 1);
			
			if(register == null) begin
				return super.get_read_data(transaction, address, direction);
			end
			else begin
				return register.get_mirrored_value();
			end
		endfunction

	endclass

`endif
