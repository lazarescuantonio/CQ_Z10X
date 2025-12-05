module seven_segment_wrapper(
   input  logic         clk  ,
   input  logic         reset,
   input  logic [31: 0] bin  ,
   output logic [ 7: 0] AN, 
   output logic         CA, 
   output logic         CB, 
   output logic         CC, 
   output logic         CD, 
   output logic         CE, 
   output logic         CF, 
   output logic         CG, 
   output logic         DP 
);

   logic [63:0] hex;

   seven_segment_bin2seven_converter b2s_i0 (.in_4bit( bin[ 3: 0] ), .out_1hex( hex[ 7: 0])); 
   seven_segment_bin2seven_converter b2s_i1 (.in_4bit( bin[ 7: 4] ), .out_1hex( hex[15: 8]));
   seven_segment_bin2seven_converter b2s_i2 (.in_4bit( bin[11: 8] ), .out_1hex( hex[23:16]));
   seven_segment_bin2seven_converter b2s_i3 (.in_4bit( bin[15:12] ), .out_1hex( hex[31:24]));
   seven_segment_bin2seven_converter b2s_i4 (.in_4bit( bin[19:16] ), .out_1hex( hex[39:32]));
   seven_segment_bin2seven_converter b2s_i5 (.in_4bit( bin[23:20] ), .out_1hex( hex[47:40]));
   seven_segment_bin2seven_converter b2s_i6 (.in_4bit( bin[27:24] ), .out_1hex( hex[55:48]));
   seven_segment_bin2seven_converter b2s_i7 (.in_4bit( bin[31:28] ), .out_1hex( hex[63:56]));

   seven_segment_driver
      driver_inst(
         .reset  (reset),
         .clk    (clk),
         .digits (hex),
         .AN     (AN ), 
         .CA     (CA ), 
         .CB     (CB ), 
         .CC     (CC ), 
         .CD     (CD ), 
         .CE     (CE ), 
         .CF     (CF ), 
         .CG     (CG ), 
         .DP     (DP ) 
   );

endmodule