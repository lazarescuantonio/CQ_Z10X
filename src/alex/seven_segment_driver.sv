module seven_segment_driver(
   input  logic         reset,
   input  logic         clk,
   input  logic [63: 0] digits,
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

parameter logic [18:0] CLK_DIV = 19'd14000;

logic [7:0]  cathodes;
logic [7:0]  anodes;
logic [2:0]  counter;
logic        clk_en;
logic [18:0] clk_div;

always_ff @(posedge clk) begin
   if(reset)
      clk_div <= 0;
   else
      clk_div <= clk_div+1;
end

assign clk_en = clk_div == CLK_DIV;

always_ff@(posedge clk) begin
    if(reset) begin
        counter <= 3'b0;
    end
    else begin
         if(clk_en)
            counter <= counter+1;
    end
end

always_comb begin
    case(counter)
        3'h0: anodes = 8'h01;
        3'h1: anodes = 8'h02;
        3'h2: anodes = 8'h04;
        3'h3: anodes = 8'h08;
        3'h4: anodes = 8'h10;
        3'h5: anodes = 8'h20;
        3'h6: anodes = 8'h40;
        3'h7: anodes = 8'h80;
    endcase
end

assign AN = ~anodes;

always_comb begin
    case(counter)
       3'h0: cathodes = digits[ 7: 0];
       3'h1: cathodes = digits[15: 8];
       3'h2: cathodes = digits[23:16];
       3'h3: cathodes = digits[31:24];
       3'h4: cathodes = digits[39:32];
       3'h5: cathodes = digits[47:40];
       3'h6: cathodes = digits[55:48];
       3'h7: cathodes = digits[63:56];
    endcase
end

assign CA = ~cathodes[0];
assign CB = ~cathodes[1];
assign CC = ~cathodes[2];
assign CD = ~cathodes[3];
assign CE = ~cathodes[4];
assign CF = ~cathodes[5];
assign CG = ~cathodes[6];
assign DP = ~cathodes[7];

endmodule