`timescale 1ns/100ps


module u_rec (	
				sys_rst_l,
				sys_clk,

				uart_dataH,

				rec_dataH,
				rec_readyH

				);


`include "inc.h"

input			sys_rst_l;	
input			sys_clk;	

input			uart_dataH;	

output	[7:0]	rec_dataH;	
output			rec_readyH;



reg		[2:0]	next_state, state;
reg				rec_datH, rec_datSyncH;
reg		[3:0]	bitCell_cntrH;
reg				cntr_resetH;
reg		[7:0]	par_dataH;
reg				shiftH;
reg		[3:0]	recd_bitCntrH;
reg				countH;
reg				rstCountH;
reg				rec_readyH;
reg				rec_readyInH;


wire	[7:0]	rec_dataH;


assign rec_dataH = par_dataH;

always @(posedge sys_clk or negedge sys_rst_l)
  if (~sys_rst_l) begin
     rec_datSyncH <= 1;
     rec_datH     <= 1;
  end else begin
     rec_datSyncH <= uart_dataH;
     rec_datH     <= rec_datSyncH;
  end


always @(posedge sys_clk or negedge sys_rst_l)
  if (~sys_rst_l) bitCell_cntrH <= 0;
  else if (cntr_resetH) bitCell_cntrH <= 0;
  else bitCell_cntrH <= bitCell_cntrH + 1;


always @(posedge sys_clk or negedge sys_rst_l)
  if (~sys_rst_l) par_dataH <= 0;
  else if(shiftH) begin
     par_dataH[6:0] <= par_dataH[7:1];
     par_dataH[7]   <= rec_datH;
  end


always @(posedge sys_clk or negedge sys_rst_l)
  if (~sys_rst_l) recd_bitCntrH <= 0;
  else if (countH) recd_bitCntrH <= recd_bitCntrH + 1;
  else if (rstCountH) recd_bitCntrH <= 0;




always @(posedge sys_clk or negedge sys_rst_l)
  if (~sys_rst_l) state <= r_START;
  else state <= next_state;


always @(state or rec_datH or bitCell_cntrH or recd_bitCntrH)
begin

  next_state  = state;
  cntr_resetH = HI;
  shiftH      = LO;
  countH      = LO;
  rstCountH   = LO;
  rec_readyInH= LO;

  case (state)
     
    r_START: begin
       if (~rec_datH ) next_state = r_CENTER;
       else begin 
         next_state = r_START;
         rstCountH  = HI; 
         rec_readyInH = HI; 
       end
    end

    r_CENTER: begin
       if (bitCell_cntrH == 4'h4) begin
         if (~rec_datH) next_state = r_WAIT;
         else next_state = r_START;
       end else begin
         next_state  = r_CENTER;
		 cntr_resetH = LO;            
       end
    end


	r_WAIT: begin
		if (bitCell_cntrH == 4'hE) begin
           if (recd_bitCntrH == WORD_LEN)
             next_state = r_STOP; 
           else begin
             next_state = r_SAMPLE;
           end
        end else begin
             next_state  = r_WAIT;
             cntr_resetH = LO;   
        end
    end

	r_SAMPLE: begin
		shiftH = HI; 
		countH = HI; 
		next_state = r_WAIT;
	end	


    r_STOP: begin
		next_state = r_START;
        rec_readyInH = HI;
    end

    default: begin
       next_state  = 3'bxxx;
       cntr_resetH = X;
	   shiftH      = X;
	   countH      = X;
       rstCountH   = X;
       rec_readyInH  = X;

    end

  endcase


end


always @(posedge sys_clk or negedge sys_rst_l)
  if (~sys_rst_l) rec_readyH <= 0;
  else rec_readyH <= rec_readyInH;




endmodule
