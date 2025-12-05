`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.12.2025 18:12:26
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb();

   reg        clk;
   reg        reset_n;
   reg  [4:0] char_in;
   reg [14:0] key;
   reg  [1:0] rA_cfg;
   reg  [1:0] rB_cfg;
   reg  [1:0] rC_cfg;
   reg        load_key_cfg;
   reg        new_char_pulse;
   wire [4:0] char_out;
   
   enigma dut (.*);
   
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end
   
   initial begin
     key = 15'b0;
     new_char_pulse = 0;
     load_key_cfg = 0;
     rA_cfg = 0;
     rB_cfg = 1;
     rC_cfg = 2;
     
     reset_n = 1;
  #2 reset_n = 0;
  #5 reset_n = 1;
     
   end
   initial begin
     #1;
     @(posedge reset_n);
     
     load_key_cfg = 1;
     @(negedge clk);
     load_key_cfg = 0;
     
     new_char_pulse = 0;
     @(negedge clk);
     char_in = 5'd0;
     new_char_pulse = 1;
     @(negedge clk);
     new_char_pulse = 0;
     
     #200 $stop;
   end

endmodule
