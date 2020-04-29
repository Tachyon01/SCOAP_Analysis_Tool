`timescale 1ns/100ps

module uart	(	sys_clk,
				sys_rst_l,

				uart_XMIT_dataH,
				xmitH,
				xmit_dataH,
				xmit_doneH,

				uart_REC_dataH,
				rec_dataH,
				rec_readyH		
			);


`include "inc.h"				

input			sys_clk;
input			sys_rst_l;


output			uart_XMIT_dataH;
input			xmitH;
input	[7:0]	xmit_dataH;
output			xmit_doneH;


input			uart_REC_dataH;
output	[7:0]	rec_dataH;
output			rec_readyH;

reg	[7:0]	rec_dataH;
reg     [7:0]   rec_dataH_temp;
wire    [7:0]   rec_dataH_rec;
wire			rec_readyH;



u_xmit  iXMIT(  .sys_clk(sys_clk),
				.sys_rst_l(sys_rst_l),

				.uart_xmitH(uart_XMIT_dataH),
				.xmitH(xmitH),
				.xmit_dataH(xmit_dataH),
				.xmit_doneH(xmit_doneH),
			);

u_rec iRECEIVER (.sys_rst_l(sys_rst_l),
				.sys_clk(sys_clk),

				
				.uart_dataH(uart_REC_dataH),

				.rec_dataH(rec_dataH_rec),
				.rec_readyH(rec_readyH)

				);

always @(posedge sys_clk or negedge sys_rst_l) begin
   if (~sys_rst_l) begin
      rec_dataH=0;
  end 
   else begin
     rec_dataH=rec_dataH_temp;
   end
  end
  

always @(posedge rec_readyH or negedge sys_rst_l) begin
   if (~sys_rst_l) begin
      rec_dataH_temp<=0;
   end 
   else begin
      rec_dataH_temp<=rec_dataH_rec;
   end
  end

endmodule
