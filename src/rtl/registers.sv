`timescale 1ns / 1ps

`define  NO_OF_BITS       12
`define  NO_OF_REGS       15
`define  ADDR_SIZE         4

module registers(
    // INTRARILE MODULULUI
    input                         clk,
    input                         reset,
    input                         write_en,
    input      [ `ADDR_SIZE-1:0]  addr,
    input      [`NO_OF_BITS-1:0]  data_in,
    input      [            4:0]  char_out,

    // IESIRILE MODULULUI
    output logic [`NO_OF_BITS-1:0] data_out,
    output logic [`NO_OF_BITS-1:0] pb_lut0_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut1_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut2_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut3_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut4_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut5_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut6_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut7_reg,     
    output logic [`NO_OF_BITS-1:0] pb_lut8_reg,     
    output logic [`NO_OF_BITS-1:0] char_output_reg, 
    output logic [`NO_OF_BITS-1:0] pb_lut9_reg, 
    output logic [`NO_OF_BITS-1:0] r1_cfg_reg,     
    output logic [`NO_OF_BITS-1:0] r2_cfg_reg,      
    output logic [`NO_OF_BITS-1:0] r3_cfg_reg,      
    output logic [`NO_OF_BITS-1:0] char_input_reg  
    
    );
    
    //  ------------------------------------------------------
    //  DECLARARE FIRE INTERNE
    //  ------------------------------------------------------    
    
    reg  [`NO_OF_REGS-1:0]  select_reg;  
    wire                    select_pb_lut0;
    wire                    select_pb_lut1;
    wire                    select_pb_lut2;
    wire                    select_pb_lut4;
    wire                    select_pb_lut3;
    wire                    select_pb_lut5;
    wire                    select_pb_lut6;
    wire                    select_pb_lut7;
    wire                    select_pb_lut8;
    wire                    select_output;
    wire                    select_input;
    wire                    select_pb_lut9;
    wire                    select_r1_cfg;
    wire                    select_r2_cfg;
    wire                    select_r3_cfg;
    wire                    write_pb_lut0; 
    wire                    write_pb_lut1;
    wire                    write_pb_lut2;
    wire                    write_pb_lut4;
    wire                    write_pb_lut3;
    wire                    write_pb_lut5;  
    wire                    write_pb_lut6;   
    wire                    write_pb_lut7;
    wire                    write_pb_lut8;   
    wire                    write_pb_lut9;
    wire                    write_r1_cfg;
    wire                    write_r2_cfg;
    wire                    write_r3_cfg;
    wire                    write_input;         
    wire                    write_output;        
    
    //  ------------------------------------------------------
    //  DECODER
    //  ------------------------------------------------------
    always_comb
        case(addr)
            `ADDR_SIZE'b0000:    select_reg = `NO_OF_REGS'b0000_0000_0000_0001;
            `ADDR_SIZE'b0001:    select_reg = `NO_OF_REGS'b0000_0000_0000_0010;
            `ADDR_SIZE'b0010:    select_reg = `NO_OF_REGS'b0000_0000_0000_0100;
            `ADDR_SIZE'b0011:    select_reg = `NO_OF_REGS'b0000_0000_0000_1000;
            `ADDR_SIZE'b0100:    select_reg = `NO_OF_REGS'b0000_0000_0001_0000;
            `ADDR_SIZE'b0101:    select_reg = `NO_OF_REGS'b0000_0000_0010_0000;
            `ADDR_SIZE'b0110:    select_reg = `NO_OF_REGS'b0000_0000_0100_0000;
            `ADDR_SIZE'b0111:    select_reg = `NO_OF_REGS'b0000_0000_1000_0000;
            `ADDR_SIZE'b1000:    select_reg = `NO_OF_REGS'b0000_0001_0000_0000;
            `ADDR_SIZE'b1001:    select_reg = `NO_OF_REGS'b0000_0010_0000_0000;
            `ADDR_SIZE'b1010:    select_reg = `NO_OF_REGS'b0000_0100_0000_0000;
            `ADDR_SIZE'b1011:    select_reg = `NO_OF_REGS'b0000_1000_0000_0000;
            `ADDR_SIZE'b1100:    select_reg = `NO_OF_REGS'b0001_0000_0000_0000;
            `ADDR_SIZE'b1101:    select_reg = `NO_OF_REGS'b0010_0000_0000_0000;
            `ADDR_SIZE'b1110:    select_reg = `NO_OF_REGS'b0100_0000_0000_0000;
            default              select_reg = `NO_OF_REGS'b0000_0000_0000_0000;
        endcase
    
    assign select_pb_lut0  = select_reg[ 0];   
    assign select_pb_lut1  = select_reg[ 1];   
    assign select_pb_lut2  = select_reg[ 2];    
    assign select_pb_lut3  = select_reg[ 3];   
    assign select_pb_lut4  = select_reg[ 4];   
    assign select_pb_lut5  = select_reg[ 5];   
    assign select_pb_lut6  = select_reg[ 6];   
    assign select_pb_lut7  = select_reg[ 7];   
    assign select_pb_lut8  = select_reg[ 8];   
    assign select_pb_lut9  = select_reg[ 9];   
    assign select_r1_cfg   = select_reg[10];
    assign select_r2_cfg   = select_reg[11];
    assign select_r3_cfg   = select_reg[12];
    assign select_input    = select_reg[13];
    assign select_output   = select_reg[14];   
    
    //  ------------------------------------------------------
    //  WRITE                                 
    //  ------------------------------------------------------ 
       
    assign write_pb_lut0 = select_pb_lut0 & write_en;
    assign write_pb_lut1 = select_pb_lut1 & write_en;
    assign write_pb_lut2 = select_pb_lut2 & write_en;   
    assign write_pb_lut3 = select_pb_lut3 & write_en;  
    assign write_pb_lut4 = select_pb_lut4 & write_en;  
    assign write_pb_lut5 = select_pb_lut5 & write_en;  
    assign write_pb_lut6 = select_pb_lut6 & write_en;  
    assign write_pb_lut7 = select_pb_lut7 & write_en;  
    assign write_pb_lut8 = select_pb_lut8 & write_en;  
    assign write_pb_lut9 = select_pb_lut9 & write_en;  
    assign write_r1_cfg  = select_r1_cfg  & write_en; 
    assign write_r2_cfg  = select_r2_cfg  & write_en;  
    assign write_r3_cfg  = select_r3_cfg  & write_en;  
    assign write_input   = select_input   & write_en;  
    assign write_output  = select_output  & write_en;  

    always_ff@(posedge clk)
        if (reset)                pb_lut0_reg <= `NO_OF_BITS'd0;
        else if (write_pb_lut0)   pb_lut0_reg <= {7'b0, data_in[4:0]};

    always_ff@(posedge clk)
        if (reset)              pb_lut1_reg <= `NO_OF_BITS'd1;
        else if (write_pb_lut1) pb_lut1_reg <= {7'b0, data_in[4:0]};

    always_ff@(posedge clk)
        if (reset)              pb_lut2_reg <= `NO_OF_BITS'd2;
        else if (write_pb_lut2) pb_lut2_reg <= {8'b0, data_in[4:0]};
        
    always_ff@(posedge clk)
        if (reset)              pb_lut3_reg <= `NO_OF_BITS'd3;
        else if (write_pb_lut3) pb_lut3_reg <=  {8'b0, data_in[4:0]};
        
    always_ff@(posedge clk)
        if (reset)              pb_lut4_reg <= `NO_OF_BITS'd4;
        else if (write_pb_lut4) pb_lut4_reg <= {8'b0, data_in[4:0]};
           
    always_ff@(posedge clk)
        if (reset)              pb_lut5_reg <= `NO_OF_BITS'd5;
        else if (write_pb_lut5) pb_lut5_reg <=  {8'b0, data_in[4:0]};
    
    always_ff@(posedge clk)
        if (reset)              pb_lut6_reg  <= `NO_OF_BITS'd6;
        else if (write_pb_lut6) pb_lut6_reg  <=  {8'b0, data_in[4:0]};
        
    always_ff@(posedge clk)
        if (reset)              pb_lut7_reg  <= `NO_OF_BITS'd7;
        else if (write_pb_lut7) pb_lut7_reg  <=  {8'b0, data_in[4:0]};
        
    always_ff@(posedge clk)
        if (reset)              pb_lut8_reg <= `NO_OF_BITS'd8;
        else if (write_pb_lut8) pb_lut8_reg <=  {8'b0, data_in[4:0]};
    
    always_ff@(posedge clk)
        if (reset)              pb_lut9_reg <= `NO_OF_BITS'd9;
        else if (write_pb_lut9) pb_lut9_reg <= {7'b0, data_in[4:0]};
  
    always_ff@(posedge clk)
        if (reset)              r1_cfg_reg  <= `NO_OF_BITS'd0;
        else if (write_r1_cfg)  r1_cfg_reg  <= {7'b0, data_in[1:0]};      

    always_ff@(posedge clk)
        if (reset)              r2_cfg_reg  <= `NO_OF_BITS'd1;
        else if (write_r2_cfg)  r2_cfg_reg  <= {7'b0, data_in[1:0]}; 
        
    always_ff@(posedge clk)
        if (reset)              r3_cfg_reg  <= `NO_OF_BITS'd2;
        else if (write_r3_cfg)  r3_cfg_reg  <= {7'b0, data_in[1:0]}; 
        
    always_ff@(posedge clk)
        if (reset)              char_input_reg  <= `NO_OF_BITS'b0;
        else if (write_input)   char_input_reg  <= {7'b0, data_in[4:0]};
        
    always_ff@(posedge clk)
        if (reset)              char_output_reg <= `NO_OF_BITS'b0;
        else                    char_output_reg <= {'0, char_out};
        
      
    //  ------------------------------------------------------
    //  READ                    
    //  ------------------------------------------------------
    always_comb
        case(addr)
             4'b0000:   data_out = pb_lut0_reg;    
             4'b0001:   data_out = pb_lut1_reg; 
             4'b0010:   data_out = pb_lut2_reg;
             4'b0011:   data_out = pb_lut3_reg;
             4'b0100:   data_out = pb_lut4_reg;
             4'b0101:   data_out = pb_lut5_reg; 
             4'b0110:   data_out = pb_lut6_reg; 
             4'b0111:   data_out = pb_lut7_reg;  
             4'b1000:   data_out = pb_lut8_reg; 
             4'b1001:   data_out = pb_lut9_reg;
             4'b1010:   data_out = r1_cfg_reg;
             4'b1011:   data_out = r2_cfg_reg; 
             4'b1100:   data_out = r3_cfg_reg; 
             4'b1101:   data_out = char_input_reg; 
             4'b1110:   data_out = char_output_reg; 
             default    data_out = `NO_OF_BITS'b0;
        endcase
   
endmodule

