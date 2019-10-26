/*********************************************************************
* Module: defines_2.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: Global definitions used by the code for readability
* Change history:	26/10/2019 – File Created
*				 	26/10/2019 - Added Half word and byte supporting definitions
*********************************************************************/

// Added defines for ease of memory addressing
`define		BYTE_OFFSET			4'd8
`define		MEM_WIDTH			4'd31
`define		FIRST_BYTE_OFFSET	4'd0	
`define		SECOND_BYTE_OFFSET	4'd8
`define		THIRD_BYTE_OFFSET	4'd16
`define		FOURTH_BYTE_OFFSET	4'd24