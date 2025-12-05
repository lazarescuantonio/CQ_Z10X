module keyps2_rx (
    input  logic       clk,
    input  logic       reset,
    input  logic       ps2d,
    input  logic       ps2c,
    input  logic       rx_en,// ps2 data and clock inputs, receive enable input
    output logic       rx_done_tick,// ps2 receive done tick
    output logic [7:0] rx_data// data received 
);

   // FSMD state declaration
   localparam FSM_IDLE = 1'b0, FSM_BUSY = 1'b1;

   // internal signal declaration
   logic        state_r, state_next;// FSMD state register
   logic  [7:0] filter_r;// shift register filter for ps2c
   logic  [7:0] filter_next;// next state value of ps2c filter register
   logic        f_val_r;// logic for ps2c filter value, either 1 or 0
   logic        f_val_next;// next state for ps2c filter value
   logic  [3:0] n_r, n_next;// register to keep track of bit number 
   logic [10:0] d_r, d_next;// register to shift in FSM_BUSY data
   logic        neg_edge;// negative edge of ps2c clock filter value

   // register for ps2c filter register and filter value
   always_ff @(posedge clk)
      if (reset) begin
         filter_r <= 0;
         f_val_r  <= 0;
      end else begin
         filter_r <= filter_next;
         f_val_r  <= f_val_next;
      end

   // next state value of ps2c filter: right shift in current ps2c value to register
   assign filter_next = {ps2c, filter_r[7:1]};

   // filter value next state, 1 if all bits are 1, 0 if all bits are 0, else no change
   assign f_val_next = (filter_r == 8'b11111111) ? 1'b1 :
                       (filter_r == 8'b00000000) ? 1'b0 :
                        f_val_r;

   // negative edge of filter value: if current value is 1, and next state value is 0
   assign neg_edge = f_val_r & ~f_val_next;

   // FSMD state, bit number, and data registers
   always_ff @(posedge clk)
      if (reset) begin
         state_r <= FSM_IDLE;
         n_r <= 0;
         d_r <= 0;
      end else begin
         state_r <= state_next;
         n_r <= n_next;
         d_r <= d_next;
      end

   // FSMD next state logic
   always_comb begin

      // defaults
      state_next = state_r;
      rx_done_tick = 1'b0;
      n_next = n_r;
      d_next = d_r;

      case (state_r)

         FSM_IDLE:
         if (neg_edge & rx_en)// start bit received
         begin
            n_next     = 4'b1010;// set bit count down to 10
            state_next = FSM_BUSY;// go to FSM_BUSY state
         end

         FSM_BUSY:// shift in 8 data, 1 parity, and 1 stop bit
         begin
         if (neg_edge)// if ps2c negative edge...
            begin
               d_next = {ps2d, d_r[10:1]};// sample ps2d, right shift into data register
               n_next = n_r - 1;// decrement bit count
         end

            if (n_r==0)// after 10 bits shifted in, go to done state
            begin
               rx_done_tick = 1'b1;// assert dat received done tick
               state_next   = FSM_IDLE;// go back to FSM_IDLE
            end
         end
      endcase
   end

   assign rx_data = d_r[8:1];// output data bits 
endmodule
