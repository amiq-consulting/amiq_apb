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
 * NAME:        amiq_apb_ex_multi_env.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the environment used by
 *              "multi" example.
 *******************************************************************************/

`ifndef AMIQ_APB_EX_MULTI_ENV_SV
	//protection against multiple includes
	`define AMIQ_APB_EX_MULTI_ENV_SV

	//environment class
	class amiq_apb_ex_multi_env extends uvm_env;

		//instance of the APB UVC environment
		amiq_apb_env env;

		//instance of the virtual sequencers
		amiq_apb_ex_multi_virtual_sequencer sequencer;

		//instance of the scoreboard
		amiq_apb_ex_multi_scoreboard scoreboard;

		`uvm_component_utils(amiq_apb_ex_multi_env)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(input string name, input uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM build phase
		//@param phase - current phase
		virtual function void build_phase(input uvm_phase phase);
			super.build_phase(phase);

			env = amiq_apb_env::type_id::create("env", this);
			sequencer = amiq_apb_ex_multi_virtual_sequencer::type_id::create("sequencer", this);
			scoreboard = amiq_apb_ex_multi_scoreboard::type_id::create("scoreboard", this);

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

			sequencer.slave_sequencers = new[env.env_config.number_of_slaves];
			for(int i = 0; i < env.env_config.number_of_slaves; i++) begin
				assert ($cast(sequencer.slave_sequencers[i], env.slave_agents[i].sequencer)) else
					`uvm_fatal("ENV", "Could not cast to amiq_apb_slave_sequencer");
			end

			env.master_agent.monitor.output_port.connect(scoreboard.input_port_master_mon);

			env.master_agent.driver.output_port.connect(scoreboard.input_port_master_drv);
			env.slave_agents[0].driver.output_port.connect(scoreboard.input_port_slave_drv_0);
			env.slave_agents[1].driver.output_port.connect(scoreboard.input_port_slave_drv_1);
		endfunction

		//function for handling reset
		//@param phase - current phase
		virtual function void handle_reset(uvm_phase phase);
			scoreboard.handle_reset();
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

