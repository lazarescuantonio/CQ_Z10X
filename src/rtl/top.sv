`timescale 1ns / 1ps

module top(
    input         clk,
    input         reset_n,
    input         uart_rxd,
    output        uart_txd,
    input  [14:0] key,              // switches
    input         direct_remote_sw, // switch
    input         load_key_cfg      // button
);

    logic [11:0]  data_out;
    logic         write_en;
    logic [ 3:0]  addr;
    logic [11:0]  data_in;
    logic [11:0]  pb_lut0_reg;     
    logic [11:0]  pb_lut1_reg;     
    logic [11:0]  pb_lut2_reg;     
    logic [11:0]  pb_lut3_reg;     
    logic [11:0]  pb_lut4_reg;     
    logic [11:0]  pb_lut5_reg;     
    logic [11:0]  pb_lut6_reg;     
    logic [11:0]  pb_lut7_reg;     
    logic [11:0]  pb_lut8_reg;     
    logic [ 4:0]  char_out; 
    logic [ 4:0]  char_input_reg_ff;
    logic [11:0]  pb_lut9_reg;
    logic [11:0]  r1_cfg_reg;    
    logic [11:0]  r2_cfg_reg;      
    logic [11:0]  r3_cfg_reg;      
    logic [11:0]  char_input_reg;
    logic         new_char_pulse;

top_fsm fsm (.*);

registers regs (    
    .pb_lut0_reg,     
    .pb_lut1_reg,     
    .pb_lut2_reg,     
    .pb_lut3_reg,     
    .pb_lut4_reg,     
    .pb_lut5_reg,     
    .pb_lut6_reg,     
    .pb_lut7_reg,     
    .pb_lut8_reg,     
    .char_output_reg(char_out), 
    .pb_lut9_reg, 
    .r1_cfg_reg,     
    .r2_cfg_reg,      
    .r3_cfg_reg,      
    .char_input_reg,
    .reset(~reset_n),
    .*);

enigma(
   .char_in(char_input_reg[4:0]),
   .key,
   .load_key_cfg,
   .rA_cfg(r1_cfg_reg[1:0]),
   .rB_cfg(r2_cfg_reg[1:0]),
   .rC_cfg(r3_cfg_reg[1:0]),
   .new_char_pulse,
   .char_out,
   .pb_lut0_reg,     
   .pb_lut1_reg,     
   .pb_lut2_reg,     
   .pb_lut3_reg,     
   .pb_lut4_reg,     
   .pb_lut5_reg,     
   .pb_lut6_reg,     
   .pb_lut7_reg,     
   .pb_lut8_reg,
   .*
   );
   
always_ff @(posedge clk)
   if (~reset_n) char_input_reg_ff <= 0;
   else          char_input_reg_ff <= char_input_reg;

assign new_char_pulse = char_input_reg ^ char_input_reg_ff; // only one pulse
   
endmodule
