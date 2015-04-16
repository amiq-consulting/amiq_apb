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
 * MODULE:      amiq_apb_macros.sv
 * PROJECT:     amiq_apb
 * Description: AMBA APB specific macros
 *******************************************************************************/

`ifndef AMIQ_APB_MACROS_SV
	//protection against multiple includes
	`define AMIQ_APB_MACROS_SV

	//--------------------------------------------------
	//Coverage specific macros
	//--------------------------------------------------

	`define cvr_multiple_8_bits(name,byte_pos,data,condition) \
    cvr_bit_``name``_``byte_pos``_0_c : coverpoint data``[8*byte_pos+0:8*byte_pos+0] ``condition ; \
    cvr_bit_``name``_``byte_pos``_1_c : coverpoint data``[8*byte_pos+1:8*byte_pos+1]``condition; \
    cvr_bit_``name``_``byte_pos``_2_c : coverpoint data``[8*byte_pos+2:8*byte_pos+2]``condition; \
    cvr_bit_``name``_``byte_pos``_3_c : coverpoint data``[8*byte_pos+3:8*byte_pos+3]``condition; \
    cvr_bit_``name``_``byte_pos``_4_c : coverpoint data``[8*byte_pos+4:8*byte_pos+4]``condition; \
    cvr_bit_``name``_``byte_pos``_5_c : coverpoint data``[8*byte_pos+5:8*byte_pos+5]``condition; \
    cvr_bit_``name``_``byte_pos``_6_c : coverpoint data``[8*byte_pos+6:8*byte_pos+6]``condition; \
    cvr_bit_``name``_``byte_pos``_7_c : coverpoint data``[8*byte_pos+7:8*byte_pos+7]``condition;


	`define cvr_multiple_32_bits(name,data,condition) \
    `cvr_multiple_8_bits(``name``,0,``data``, ``condition``) \
    `cvr_multiple_8_bits(``name``,1,``data``, ``condition``) \
    `cvr_multiple_8_bits(``name``,2,``data``, ``condition``) \
    `cvr_multiple_8_bits(``name``,3,``data``, ``condition``)

`endif