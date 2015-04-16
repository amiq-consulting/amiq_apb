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
 * NAME:        amiq_apb_master_drv_item.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the definition of the item used by master driver.
 *******************************************************************************/

`ifndef AMIQ_APB_MASTER_DRV_ITEM_SV
	//protection against multiple includes
	`define AMIQ_APB_MASTER_DRV_ITEM_SV

	//master driver item
	class amiq_apb_master_drv_item extends amiq_apb_item;

		//Delays between transfers - the transfer delay is driven to the end of transfer
		rand int unsigned trans_delay;

		constraint trans_delay_default {
			soft trans_delay <= 100;
		}

		`uvm_object_utils(amiq_apb_master_drv_item)

		//constructor
		//@param name - name of the object instance
		function new(string name = "amiq_apb_master_drv_item");
			super.new(name);
		endfunction

	endclass

`endif

