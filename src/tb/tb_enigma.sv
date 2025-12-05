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

logic        clk           ;
logic        reset_n       ;
logic  [4:0] char_in       ;
logic [14:0] key           ;
logic  [1:0] rA_cfg        ;
logic  [1:0] rB_cfg        ;
logic  [1:0] rC_cfg        ;
logic        load_key_cfg  ;
logic        new_char_pulse;
logic  [4:0] char_out      ;
logic  [4:0] pb_lut0_reg   ;
logic  [4:0] pb_lut1_reg   ;
logic  [4:0] pb_lut2_reg   ;
logic  [4:0] pb_lut3_reg   ;
logic  [4:0] pb_lut4_reg   ;
logic  [4:0] pb_lut5_reg   ;
logic  [4:0] pb_lut6_reg   ;
logic  [4:0] pb_lut7_reg   ;
logic  [4:0] pb_lut8_reg   ;
logic  [4:0] pb_lut9_reg   ;


enigma dut
(
   .clk           ,
   .reset_n       ,
   .char_in       ,
   .key           ,
   .rA_cfg        ,
   .rB_cfg        ,
   .rC_cfg        ,
   .load_key_cfg  ,
   .new_char_pulse,
   .char_out      ,
   .pb_lut0_reg   ,
   .pb_lut1_reg   ,
   .pb_lut2_reg   ,
   .pb_lut3_reg   ,
   .pb_lut4_reg   ,
   .pb_lut5_reg   ,
   .pb_lut6_reg   ,
   .pb_lut7_reg   ,
   .pb_lut8_reg   ,
   .pb_lut9_reg
);

initial begin
   clk = 0;
   forever #5 clk = ~clk;
end


initial begin
   char_in        = '0;
   key            = '0;
   rA_cfg         = '0;
   rB_cfg         = '0;
   rC_cfg         = '0;
   load_key_cfg   = '0;
   new_char_pulse = '0;
   pb_lut0_reg    = 5'd0; // (lut0 este pt cifra A) A la A
   pb_lut1_reg    = 5'd1; // B la B
   pb_lut2_reg    = 5'd2;
   pb_lut3_reg    = 5'd3;
   pb_lut4_reg    = 5'd4;
   pb_lut5_reg    = 5'd5;
   pb_lut6_reg    = 5'd6;
   pb_lut7_reg    = 5'd7;
   pb_lut8_reg    = 5'd8;
   pb_lut9_reg    = 5'd9;
   
   @(negedge clk);
   reset_n = 0;
   repeat(2) @(negedge clk);
   reset_n = 1;
   
   
   
   
// test 1
   rA_cfg = 0; // right
   rB_cfg = 1; // mid
   rC_cfg = 2; // left
   
   //     C     B     A
   key = {5'd0, 5'd0, 5'd14};
   @(negedge clk);
   load_key_cfg = 1;
   @(negedge clk);
   load_key_cfg = 0;
   
   
   char_in = 0; // A
   @(negedge clk);
   new_char_pulse = 1;
   @(negedge clk);
   new_char_pulse = 0;
   
   
   char_in = 1; // B
   @(negedge clk);
   new_char_pulse = 1;
   @(negedge clk);
   new_char_pulse = 0;
   
   
   char_in = 2; // C
   @(negedge clk);
   new_char_pulse = 1;
   @(negedge clk);
   new_char_pulse = 0;
   
   
   char_in = 3; // D
   @(negedge clk);
   new_char_pulse = 1;
   @(negedge clk);
   new_char_pulse = 0;
   
   
   char_in = 23; // X
   @(negedge clk);
   new_char_pulse = 1;
   @(negedge clk);
   new_char_pulse = 0;
   
   
   repeat(100) @(posedge clk);
   $stop();
end

endmodule
