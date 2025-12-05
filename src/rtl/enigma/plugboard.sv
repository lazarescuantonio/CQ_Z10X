`timescale 1ns / 1ps

module plugboard(
    input         [4:0]  char_in_fw,
    output logic  [4:0]  char_out_fw,
    input         [4:0]  char_in_rev,
    output logic  [4:0]  char_out_rev,
    input         [4:0]  pb_lut0_reg,
    input         [4:0]  pb_lut1_reg,
    input         [4:0]  pb_lut2_reg,
    input         [4:0]  pb_lut3_reg,
    input         [4:0]  pb_lut4_reg,
    input         [4:0]  pb_lut5_reg,
    input         [4:0]  pb_lut6_reg,
    input         [4:0]  pb_lut7_reg,
    input         [4:0]  pb_lut8_reg,
    input         [4:0]  pb_lut9_reg
    );
   
   always_comb begin
      case(char_in_fw)
        0: char_out_fw = pb_lut0_reg; // A
        1: char_out_fw = pb_lut1_reg; // B
        2: char_out_fw = pb_lut2_reg; // C
        3: char_out_fw = pb_lut3_reg; // D
        4: char_out_fw = pb_lut4_reg; // E
        5: char_out_fw = pb_lut5_reg; // F
        6: char_out_fw = pb_lut6_reg; // G
        7: char_out_fw = pb_lut7_reg; // H
        8: char_out_fw = pb_lut8_reg; // I
        9: char_out_fw = pb_lut9_reg; // J
        default: char_out_fw = char_in_fw; // restul raman la fel...
      endcase
   end
   
   always_comb begin
      case(char_in_rev)
        0: char_out_fw = pb_lut0_reg; // A
        1: char_out_fw = pb_lut1_reg; // B
        2: char_out_fw = pb_lut2_reg; // C
        3: char_out_fw = pb_lut3_reg; // D
        4: char_out_fw = pb_lut4_reg; // E
        5: char_out_fw = pb_lut5_reg; // F
        6: char_out_fw = pb_lut6_reg; // G
        7: char_out_fw = pb_lut7_reg; // H
        8: char_out_fw = pb_lut8_reg; // I
        9: char_out_fw = pb_lut9_reg; // J
        default: char_out_rev = char_in_rev; // restul raman la fel...
      endcase
   end
   
   
   
endmodule
