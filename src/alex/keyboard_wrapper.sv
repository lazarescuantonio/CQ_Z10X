module keyboard_wrapper(
    input  logic       clk,
    input  logic       reset,
    input  logic       ps2_data,
    input  logic       ps2_clk,  // ps2 data and clock lines
    output logic [7:0] char_data,  // scan_code received from keyboard to process
    output logic       char_ready  // signal to outer control system to sample scan_code
);

   logic [7:0] scan_code;

keyboard 
   keyboard_inst (
      .clk            (clk        ),
      .reset          (reset      ),
      .ps2d           (ps2_data   ),
      .ps2c           (ps2_clk    ),
      .scan_code      (scan_code  ),
      .scan_code_ready(char_ready ),
      .letter_case_out(letter_case)
   );

key2ascii 
   key2ascii_inst (
      .letter_case(letter_case),
      .scan_code  (scan_code  ),
      .ascii_code (char_data  )
   );


endmodule

