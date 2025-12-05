module vga_ram(
   input  logic            clk    ,

   input  logic            wr     ,
   input  logic [   127:0] w_data ,
   input  logic [     6:0] w_col  , // 0-79
   input  logic [     4:0] w_row  , // 0-29

   input  logic            rd     ,
   input  logic [     9:0] r_col  , // 0-639
   input  logic [     9:0] r_row  , // 0-479
   output logic            out
); 

   parameter int R_ROWS = 480;
   parameter int R_COLS = 640;
   parameter int W_ROWS = R_ROWS / 16;
   parameter int W_COLS = R_COLS / 8;

   logic [7:0] mem [0:R_ROWS-1][0:W_COLS-1];
   logic [7:0] r_out;

   genvar i,j;
   generate
   for(i = 0; i < R_ROWS; i=i+1)
      for(j = 0; j < W_COLS; j=j+1)
         initial mem[i][j] = 8'b0;
   endgenerate

   always_ff @(posedge clk)
      if(rd) r_out <= mem[r_row][r_col[9:3]];

   assign out = r_out[r_col[2:0]];

   always@(posedge clk)
      if(wr) begin
         mem[{w_row, 4'd0 }][w_col] <= w_data[  7:  0];
         mem[{w_row, 4'd1 }][w_col] <= w_data[ 15:  8];
         mem[{w_row, 4'd2 }][w_col] <= w_data[ 23: 16];
         mem[{w_row, 4'd3 }][w_col] <= w_data[ 31: 24];
         mem[{w_row, 4'd4 }][w_col] <= w_data[ 39: 32];
         mem[{w_row, 4'd5 }][w_col] <= w_data[ 47: 40];
         mem[{w_row, 4'd6 }][w_col] <= w_data[ 55: 48];
         mem[{w_row, 4'd7 }][w_col] <= w_data[ 63: 56];
         mem[{w_row, 4'd8 }][w_col] <= w_data[ 71: 64];
         mem[{w_row, 4'd9 }][w_col] <= w_data[ 79: 72];
         mem[{w_row, 4'd10}][w_col] <= w_data[ 87: 80];
         mem[{w_row, 4'd11}][w_col] <= w_data[ 95: 88];
         mem[{w_row, 4'd12}][w_col] <= w_data[103: 96];
         mem[{w_row, 4'd13}][w_col] <= w_data[111:104];
         mem[{w_row, 4'd14}][w_col] <= w_data[119:112];
         mem[{w_row, 4'd15}][w_col] <= w_data[127:120];
      end

endmodule
