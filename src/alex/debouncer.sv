
module debouncer(
   input  logic clk    ,
   input  logic i_async,
   output logic o_sync
);

   parameter CNT_SIZE = 20;
   parameter CNT_BITS = $clog2(CNT_SIZE);

   logic [CNT_BITS-1:0] counter;
   logic                r_sync = 0;

   always_ff@ (posedge clk) begin
      if(r_sync == i_async) begin
         if(counter == (CNT_SIZE-1)) begin
            o_sync <= i_async;
         end else begin
            counter <= counter + 1;
         end
      end else begin
         counter <= 0;
         r_sync  <= i_async;
      end
   end

endmodule
