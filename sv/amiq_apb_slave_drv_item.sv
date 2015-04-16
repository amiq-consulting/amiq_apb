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
 * NAME:        amiq_apb_slave_drv_item.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the definition of the item used by slave driver
 *******************************************************************************/

`ifndef AMIQ_APB_SLAVE_DRV_ITEM_SV
	//protection against multiple includes
	`define AMIQ_APB_SLAVE_DRV_ITEM_SV

	//slave driver item
	class amiq_apb_slave_drv_item extends amiq_apb_base_item;

		//wait time
		rand int unsigned wait_time;

		//The read data
		rand amiq_apb_data_t data;

		//Switch to enable an error response
		rand amiq_apb_error_response_t has_error;

		constraint wait_time_default {
			soft wait_time <= 100;
		}

		`uvm_object_utils(amiq_apb_slave_drv_item)

		//constructor
		//@param name - name of the object instance
		function new(string name = "amiq_apb_slave_drv_item");
			super.new(name);
		endfunction

		//converts the information containing in the instance of this class to an easy-to-read string
		//@return easy-to-read string with the information contained in the instance of this class
		virtual function string convert2string();
			return $sformatf("wait_time: %0d, data: %X, has_error: %s", wait_time, data, has_error.name());
		endfunction

	endclass

`endif

