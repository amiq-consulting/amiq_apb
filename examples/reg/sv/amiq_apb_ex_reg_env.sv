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
 * NAME:        amiq_apb_ex_reg_env.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the environment used by
 *              "reg" example.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_REG_ENV_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_REG_ENV_SV

	//environment class
	class amiq_apb_ex_reg_env extends uvm_env;

		//instance of the APB UVC environment
		amiq_apb_env env;

		//instance of the register block
		amiq_apb_ex_reg_reg_block reg_block;

		//adaptor
		amiq_apb_ex_reg_reg2apb_adapter reg2apb_adapter;

		//predictor
		amiq_apb_ex_reg_apb2reg_predictor apb2reg_predictor;

		//instance of the virtual sequencers
		amiq_apb_ex_reg_virtual_sequencer sequencer;

		`uvm_component_utils(amiq_apb_ex_reg_env)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);
			amiq_apb_driver#(.DRIVER_ITEM_REQ(amiq_apb_slave_drv_item))::type_id::set_inst_override(amiq_apb_ex_reg_slave_driver::get_type(), "env.slave_agents[0].driver", this);
		endfunction

		//UVM build phase
		//@param phase - current phase
		virtual function void build_phase(input uvm_phase phase);
			super.build_phase(phase);

			env = amiq_apb_env::type_id::create("env", this);
			sequencer = amiq_apb_ex_reg_virtual_sequencer::type_id::create("sequencer", this);

			reg_block = amiq_apb_ex_reg_reg_block::type_id::create("reg_block");
			reg_block.build();
			reg_block.reset("HARD");

			reg2apb_adapter = amiq_apb_ex_reg_reg2apb_adapter::type_id::create("reg2apb_adapter", this);

			apb2reg_predictor = amiq_apb_ex_reg_apb2reg_predictor::type_id::create("apb2reg_predictor", this);


			begin
				amiq_apb_env_config env_config;

				if(!uvm_config_db#(amiq_apb_env_config)::get(this, "", "env_config", env_config)) begin
					`uvm_fatal(get_name(), "Could not get from database the environment configuration class")
				end

				uvm_config_db#(amiq_apb_env_config)::set(this, "env*", "env_config", env_config);
			end
		endfunction

		//UVM connect phase
		//@param phase - current phase
		virtual function void connect_phase(input uvm_phase phase);
			super.connect_phase(phase);

			assert ($cast(sequencer.master_sequencer, env.master_agent.sequencer)) else
				`uvm_fatal("ENV", "Could not cast to amiq_apb_master_sequencer");

			assert ($cast(sequencer.slave_sequencer, env.slave_agents[0].sequencer)) else
				`uvm_fatal("ENV", "Could not cast to amiq_apb_master_sequencer");
			
			sequencer.reg_block = reg_block;
			reg_block.default_map.set_sequencer(env.master_agent.sequencer, reg2apb_adapter);
			apb2reg_predictor.map = reg_block.default_map;
			apb2reg_predictor.adapter = reg2apb_adapter;
			env.master_agent.monitor.output_port.connect(apb2reg_predictor.bus_in);
			
			begin
				amiq_apb_ex_reg_slave_driver slave_driver;
				
				if($cast(slave_driver, env.slave_agents[0].driver) == 0) begin
					`uvm_fatal(get_id(), $sformatf("Could not cast to amiq_apb_ex_reg_slave_driver component: %s", env.slave_agents[0].driver.get_full_name()));
				end
				else begin
					slave_driver.reg_block = reg_block;
				end
			end
		endfunction

		//function for handling reset
		//@param phase - current phase
		virtual function void handle_reset(uvm_phase phase);
			reg_block.reset("HARD");
		endfunction

		//wait for reset to start
		virtual task wait_reset_start();
			@(negedge(env.env_config.dut_vi.reset_n));
		endtask

		//wait for reset to be finished
		virtual task wait_reset_end();
			@(posedge(env.env_config.dut_vi.reset_n));
		endtask

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "ENV";
		endfunction

		//UVM run phase
		//@param phase - current phase
		virtual task run_phase(uvm_phase phase);
			forever begin
				wait_reset_start();

				`uvm_info(get_id(), "Reset start detected", UVM_LOW)

				handle_reset(phase);

				wait_reset_end();

				`uvm_info(get_id(), "Reset end detected", UVM_LOW)
			end
		endtask

	endclass

`endif

