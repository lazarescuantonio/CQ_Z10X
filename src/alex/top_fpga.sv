`timescale 1ns / 1ps
module top_fpga(
    input  logic        clk          ,
    input  logic        reset_async  ,

//    // UART
//    input  logic        uart_rx      ,
//    output logic        uart_tx      ,

    // Input switches
    input  logic [15:0] SW            ,

    // Output LEDs
    output logic [15:0] LED           ,

    // Keyboard
    input  logic         ps2_data     ,
    input  logic         ps2_clk      ,

    // VGA Monitor
    output logic [11: 0] vga_pixel    ,
    output logic         vga_hsync    ,
    output logic         vga_vsync    ,

    // 7segment Display
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

logic       reset;
logic       char_ready;
logic [7:0] char_data;
logic [6:0] x_write_ptr;
logic [4:0] y_write_ptr;
logic [7:0] char_byte0, char_byte1, char_byte2, char_byte3;

assign LED = SW;

debouncer
    debouncer_inst(
        .clk    (clk),
        .i_async(reset_async),
        .o_sync (reset)
    );

keyboard_wrapper
    keyboard_wrap_inst(
        .clk        (clk),
        .reset      (reset),
        .ps2_data   (ps2_data),
        .ps2_clk    (ps2_clk),
        .char_data  (char_data),
        .char_ready (char_ready)
    );

vga_wrapper
    vga_wrap_inst(
        .clk         (clk        ),
        .reset       (reset      ),
        .vga_char_wr (char_ready ),
        .vga_char_in (char_data  ),
        .vga_char_x  (x_write_ptr),
        .vga_char_y  (y_write_ptr),
        .vga_pixel   (vga_pixel  ),
        .vga_hsync   (vga_hsync  ),
        .vga_vsync   (vga_vsync  )
    );

    assign char_byte0 = SW[4:0] + 10;
    assign seven_seg_data = {char_byte3, char_byte2, char_byte1, char_byte0};

    seven_segment_wrapper
        seven_seg_wrap_inst(
        .clk  (clk),
        .reset(reset),
        .bin  (seven_seg_data),
        .AN   (AN), 
        .CA   (CA), 
        .CB   (CB), 
        .CC   (CC), 
        .CD   (CD), 
        .CE   (CE), 
        .CF   (CF), 
        .CG   (CG), 
        .DP   (DP) 
);

endmodule
