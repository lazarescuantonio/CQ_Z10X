`timescale 1ns / 1ps

module plugboard(
    input  [4:0]  char_in_fw,
    output [4:0]  char_out_fw,
    input  [4:0]  char_in_rev,
    output [4:0]  char_out_rev
    );
    
   assign char_out_fw  = char_in_fw;
   assign char_out_rev = char_in_rev;
   
endmodule
