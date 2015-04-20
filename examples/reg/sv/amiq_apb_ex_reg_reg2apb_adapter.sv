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
 * NAME:        amiq_apb_ex_reg_reg2apb_adapter.sv
 * PROJECT:     amiq_ser
 * Description: This file contains the declaration of the register adapter
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_REG2APB_ADAPTER_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_REG2APB_ADAPTER_SV

//register adapter
class amiq_apb_ex_reg_reg2apb_adapter extends uvm_reg_adapter;

	`uvm_object_utils(amiq_apb_ex_reg_reg2apb_adapter)

	//function for getting the ID used in messaging
	//@return message ID
	virtual function string get_id();
		return "ADAPTER";
	endfunction

	//constructor
	//@param name - name of the component instance
	function new(string name = "amiq_apb_ex_reg_reg2apb_adapter");
		super.new(name);
	endfunction

	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		amiq_apb_master_simple_seq transaction = amiq_apb_master_simple_seq::type_id::create("transaction");

		assert (transaction.randomize() with {
			master_address == rw.addr;
			master_data == rw.data;
		}) else
		`uvm_fatal(get_id(), "Could not randomize amiq_apb_drv_item_master");

		if(rw.kind == UVM_WRITE) begin
			transaction.master_rw = WRITE;
		end
		else begin
			transaction.master_rw = READ;
		end

		return transaction;
	endfunction

	virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		amiq_apb_mon_item transaction;

		rw.status = UVM_NOT_OK;

		if($cast(transaction, bus_item)) begin
			if(transaction.rw == WRITE) begin
				rw.kind = UVM_WRITE;
			end
			else begin
				rw.kind = UVM_READ;
			end

			rw.addr = transaction.address;
			rw.data = transaction.data;
			rw.status = UVM_IS_OK;
		end
		else begin
			`uvm_fatal(get_id(), $sformatf("casting did not worked - bus_item: %s", bus_item.convert2string()))
		end

	endfunction
endclass

`endif

