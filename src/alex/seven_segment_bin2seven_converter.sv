module seven_segment_bin2seven_converter(
    input  [3:0] in_4bit,
    output [7:0] out_1hex
);

//==================================
//          PARAMETERS
//==================================

localparam h0 = 8'b0011_1111 ;
localparam h1 = 8'b0000_0110 ;
localparam h2 = 8'b0101_1011 ;
localparam h3 = 8'b0100_1111 ;
localparam h4 = 8'b0110_0110 ;
localparam h5 = 8'b0110_1101 ;
localparam h6 = 8'b0111_1101 ;
localparam h7 = 8'b0000_0111 ;
localparam h8 = 8'b0111_1111 ;
localparam h9 = 8'b0110_1111 ;
localparam hA = 8'b0111_0111 ;
localparam hB = 8'b0111_1100 ;
localparam hC = 8'b0011_1001 ;
localparam hD = 8'b0101_1110 ;
localparam hE = 8'b0111_1001 ;
localparam hF = 8'b0111_0001 ;

//================================== 
//        INTERNAL WIRES               
//================================== 

logic [7:0] out_1hex_data;

//================================== 
//             RTL               
//==================================
always_comb begin
    case( in_4bit )
        0: out_1hex_data = h0;
        1: out_1hex_data = h1;
        2: out_1hex_data = h2;
        3: out_1hex_data = h3;
        4: out_1hex_data = h4;
        5: out_1hex_data = h5;
        6: out_1hex_data = h6;
        7: out_1hex_data = h7;
        8: out_1hex_data = h8;
        9: out_1hex_data = h9;
       10: out_1hex_data = hA;
       11: out_1hex_data = hB;
       12: out_1hex_data = hC;
       13: out_1hex_data = hD;
       14: out_1hex_data = hE;
       15: out_1hex_data = hF;
    endcase
end

assign out_1hex = out_1hex_data;
 
endmodule