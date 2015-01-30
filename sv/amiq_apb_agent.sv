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
 * MODULE:      amiq_apb_agent.sv
 * PROJECT:     amiq_apb
 * Engineers:   Andra Socianu (andra.socianu@amiq.com)
                Cristian Florin Slav (cristian.slav@amiq.com)
 * Description: AMBA APB base agent
 *******************************************************************************/

`ifndef AMIQ_APB_AGENT_SV
	//protection against multiple includes
	`define AMIQ_APB_AGENT_SV

	//AMBA APB base agent
	class amiq_apb_agent#(type DRIVER_ITEM=amiq_apb_base_item) extends uvm_agent;

		`uvm_component_param_utils(amiq_apb_agent#(DRIVER_ITEM))

		//Agent configuration class
		amiq_apb_agent_config agent_config;

		//Agent monitor
		amiq_apb_monitor monitor;

		//Agent coverage collector
		amiq_apb_coverage coverage;

		//AMBA APB sequencer
		amiq_apb_sequencer#(DRIVER_ITEM) sequencer;

		//Agent driver
		amiq_apb_driver#(DRIVER_ITEM) driver;

		//constructor
		//@param name - name of the component instance
		//@param parent - parent of the component instance
		function new(string name = "amiq_apb_agent", uvm_component parent);
			super.new(name, parent);
		endfunction

		//UVM build phase
		//@param phase - current phase
		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);

			//Verify if the configuration for the agent is set into config_db
			if (!uvm_config_db#(amiq_apb_agent_config)::get(this, "", "agent_config", agent_config)) begin
				`uvm_fatal("AMIQ_APB_NOCFG_AGT_ERR", $sformatf("AMIQ AMBA APB configuration for the %s agent is not set!", get_full_name()));
			end

			monitor = amiq_apb_monitor::type_id::create("monitor", this);

			if(agent_config.has_coverage) begin
				coverage = amiq_apb_coverage::type_id::create("coverage", this);
			end

			if(agent_config.active_passive == UVM_ACTIVE) begin
				driver = amiq_apb_driver#(DRIVER_ITEM)::type_id::create("driver", this);
				sequencer = amiq_apb_sequencer#(DRIVER_ITEM)::type_id::create("sequencer", this);
			end
		endfunction

		//UVM connect phase
		//@param phase - current phase
		virtual function void connect_phase(uvm_phase phase);
			monitor.agent_config = agent_config;

			if(coverage != null) begin
				coverage.agent_config = agent_config;
				monitor.send_item.connect(coverage.receive_item_imp);
			end

			if(driver != null) begin
				driver.agent_config = agent_config;
			end

			if((sequencer != null) && (driver != null)) begin
				driver.seq_item_port.connect(sequencer.seq_item_export);
			end
		endfunction

		//function for getting the ID used in messaging
		//@return message ID
		virtual function string get_id();
			return "AMIQ_APB";
		endfunction

		//function for handling reset
		//@param phase - current phase
		virtual function void handle_reset(uvm_phase phase);
			monitor.handle_reset();

			if(driver != null) begin
				driver.handle_reset();
			end

			if(sequencer != null) begin
				sequencer.handle_reset(phase);
			end
		endfunction

		//wait for reset to start
		virtual task wait_reset_start();
			@(negedge(agent_config.dut_vi.reset_n));
		endtask

		//wait for reset to be finished
		virtual task wait_reset_end();
			@(posedge(agent_config.dut_vi.reset_n));
		endtask

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
