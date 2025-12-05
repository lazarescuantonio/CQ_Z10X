module vga_wrapper(
   input  logic        clk       ,
   input  logic        reset     ,

   input  logic        vga_char_wr,
   input  logic [ 7:0] vga_char_in,
   input  logic [ 6:0] vga_char_x ,
   input  logic [ 4:0] vga_char_y ,

   // Towards Display 
   output logic [11:0] vga_pixel  ,
   output logic        vga_hsync  ,
   output logic        vga_vsync 
);

logic [127:0] vga_ram_data_wr;
logic [  9:0] x,y;
logic         video_on, pixel_clk_en;
logic         vga_ram_pixel;

vga_sync
   vga_sync_inst(
      .clk     (clk         ),
      .reset   (reset       ),
      .hsync   (vga_hsync   ),
      .vsync   (vga_vsync   ),
      .video_on(video_on    ),
      .p_tick  (pixel_clk_en),
      .x       (x           ),
      .y       (y           )
   );

char_rom
   char_rom_inst(
      .addr(    vga_char_in),
      .data(vga_ram_data_wr)
   );

assign vga_ram_rd = video_on & pixel_clk_en;

vga_ram
   vga_ram_inst(
      .clk    (clk        ),

      // Char Write interface from top
      .wr     (vga_char_wr    ),
      .w_data (vga_ram_data_wr),
      .w_col  (vga_char_x     ), // 0-79
      .w_row  (vga_char_y     ), // 0-29

      // Read interface from vga_sync
      .rd     (video_on & pixel_clk_en),
      .r_col  (x          ), // 0-639
      .r_row  (y          ), // 0-479
      .out    (vga_ram_pixel)
); 

assign vga_pixel = video_on ? (vga_ram_pixel ? 12'hFFF : 12'h000) : 12'h000;


endmodule