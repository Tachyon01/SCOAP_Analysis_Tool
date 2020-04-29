
//
// Receiver state definition
//
parameter	r_START 	= 3'b001,
          	r_CENTER	= 3'b010,
          	r_WAIT  	= 3'b011,
          	r_SAMPLE	= 3'b100,
		  	r_STOP  	= 3'b101;

//
// Xmitter state definition
//
parameter	x_IDLE		= 3'b000,
			x_START		= 3'b010,
			x_WAIT		= 3'b011,
			x_SHIFT		= 3'b100,
			x_STOP		= 3'b101,
                        x_DataSend        = 3'b111;


parameter	s_idle		= 3'b000,
			s_count1	= 3'b001,
			s_count2	= 3'b010,
			s_count3	= 3'b011,
			s_stop		= 3'b111;
                        

parameter   x_STARTbit  = 2'b00,
			x_STOPbit   = 2'b01,
			x_ShiftReg  = 2'b10,
                        x_miDataSend  = 2'b11;

//
// Common parameter Definition
//
parameter	LO 		= 1'b0,
          	HI		= 1'b1,		
 		X		= 1'bx,
                DataSend  =1'b0;


parameter       DataSend_bit =1'b1;
parameter       DataCon_bit =1'b1;

// *****************************
//
// Receiver Configuration
//
// *****************************

// Word length.  
// This defines the number of bits 
// in a "word".  Typcially 8.
// min=0, max=8

parameter	WORD_LEN = 8;




`define DEBUG
