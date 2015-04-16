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
 * MODULE:      amiq_apb_types.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB types used in the environment
 *******************************************************************************/

`ifndef AMIQ_APB_TYPES_SV
	//protection against multiple includes
	`define AMIQ_APB_TYPES_SV

	//Forward declaration to virtual interface
	typedef virtual amiq_apb_if amiq_apb_vif_t;

	//Define the transfer direction
	typedef enum bit {READ = 0, WRITE = 1} amiq_apb_direction_t;

	//Define the error response
	typedef enum bit {NO_ERROR = 0, WITH_ERROR = 1} amiq_apb_error_response_t;

	//Define the wait-state delay
	typedef enum bit {WITH_WAIT_STATE = 0, WITHOUT_WAIT_STATE = 1} amiq_apb_transfer_type_t;

	//Define the first level of protection
	typedef enum bit {NORMAL_ACCESS = 0, PRIVILEGED_ACCESS = 1} amiq_apb_first_level_protection_t;

	//Define the second level of protection
	typedef enum bit {SECURE_ACCESS = 0, NON_SECURE_ACCESS = 1} amiq_apb_second_level_protection_t;

	//Define the third level of protection
	typedef enum bit {DATA_ACCESS = 0, INSTRUCTION_ACCESS = 1} amiq_apb_third_level_protection_t;

	//Define the bus state
	typedef enum bit[1:0] {IDLE = 0, SETUP = 1, ACCESS = 2} amiq_apb_bus_state_t;

	//Define the data
	typedef bit[`AMIQ_APB_MAX_DATA_WIDTH-1:0] amiq_apb_data_t;

	//Define the address
	typedef bit[`AMIQ_APB_MAX_ADDR_WIDTH-1:0] amiq_apb_addr_t;

	//Define the strobe
	typedef bit[`AMIQ_APB_MAX_STROBE_WIDTH-1:0] amiq_apb_strobe_t;

`endif
