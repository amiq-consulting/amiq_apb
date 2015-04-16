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
 * MODULE:      amiq_apb_item.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB transfer item definition
 *******************************************************************************/

`ifndef AMIQ_APB_ITEM_SV
	//protection against multiple includes
	`define AMIQ_APB_ITEM_SV

	//AMBA APB transfer item definition
	class amiq_apb_item extends amiq_apb_base_item;

		`uvm_object_utils(amiq_apb_item)

		//The address of the transfer
		rand amiq_apb_addr_t address;

		//Transfer direction
		rand amiq_apb_direction_t rw;

		//The read or write data
		rand amiq_apb_data_t data;

		//The first level transfer protection
		rand amiq_apb_first_level_protection_t first_level_protection;

		//The second level transfer protection
		rand amiq_apb_second_level_protection_t second_level_protection;

		//The third level transfer protection
		rand amiq_apb_third_level_protection_t third_level_protection;

		//The access strobe
		rand amiq_apb_strobe_t strobe;

		//selected slave
		rand int unsigned selected_slave;

		constraint strobe_default {
			solve rw before strobe;
			//For read transfers the bus master must drive all bits of PSTRB LOW.
			rw == READ -> strobe == 0;
		}

		constraint selected_slave_default {
			selected_slave < `AMIQ_APB_MAX_SEL_WIDTH;
		}

		//constructor
		//@param name - name of the object instance
		function new(string name = "amiq_apb_item");
			super.new(name);
		endfunction

		//converts the information containing in the instance of this class to an easy-to-read string
		//@return easy-to-read string with the information contained in the instance of this class
		virtual function string convert2string();
			return $sformatf("dir: %s, addr: %X, data: %X, prot[2:0]: %s %s %s, strobe: %X, selected_slave: %0d",
				rw.name(), address, data, third_level_protection.name(), second_level_protection.name(), first_level_protection.name(), strobe, selected_slave);
		endfunction

	endclass

`endif
