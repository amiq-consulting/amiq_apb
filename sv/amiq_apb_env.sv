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
 * NAME:        amiq_apb_env.sv
 * PROJECT:     amiq_apb
 * Description: This file contains the declaration of the APB UVC environment class
 *******************************************************************************/

`ifndef AMIQ_APB_ENV_SV
	//protection against multiple includes
	`define AMIQ_APB_ENV_SV

	//APB UVC environment class
	class amiq_apb_env extends uvm_env;

		//environment configuration class
		amiq_apb_env_config env_config;

		//master
		amiq_apb_master_agent master_agent;

		//list of slave agents
		amiq_apb_slave_agent slave_agents[];

		`uvm_component_utils(amiq_apb_env)

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_env", uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM build phase
		//@param phase - current phase
		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);

			//Verify if the configuration for the agent is set into config_db
			if (!uvm_config_db#(amiq_apb_env_config)::get(this, "", "env_config", env_config)) begin
				`uvm_fatal("AMIQ_APB_NOCFG_ENV_ERR", $sformatf("AMIQ AMBA APB configuration for the environment is not set!"));
			end

			begin
				amiq_apb_master_agent_config master_agent_config;
				master_agent = amiq_apb_master_agent::type_id::create("master_agent", this);

				master_agent_config = amiq_apb_master_agent_config::type_id::create("agent_config", master_agent);
				master_agent_config.set_dut_vif(env_config.dut_vi);
				master_agent_config.set_number_of_slaves(env_config.number_of_slaves);

				uvm_config_db#(amiq_apb_agent_config)::set(this, "master_agent", "agent_config", master_agent_config);
			end

			slave_agents = new[env_config.number_of_slaves];

			for(int i = 0; i < env_config.number_of_slaves; i++) begin
				amiq_apb_slave_agent_config slave_agent_config;
				string agent_name = $sformatf("slave_agents[%0d]", i);
				slave_agents[i] = amiq_apb_slave_agent::type_id::create(agent_name, this);

				slave_agent_config = amiq_apb_slave_agent_config::type_id::create("agent_config", slave_agents[i]);
				slave_agent_config.set_dut_vif(env_config.dut_vi);
				slave_agent_config.set_slave_index(i);

				uvm_config_db#(amiq_apb_agent_config)::set(this, agent_name, "agent_config", slave_agent_config);
			end
		endfunction

	endclass

`endif

