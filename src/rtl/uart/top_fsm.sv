`timescale 1ns / 1ps

module top_fsm
(

    input               clk,
    input               reset_n,
    input               uart_rxd,
    input       [11:0]  data_out,
    
    output              uart_txd,
    output  reg         write_en,
    output  reg [ 3:0]  addr,
    output  reg [11:0]  data_in

);

//===================
//  INTERNAL WIRES
//===================

// from and to uart  
logic        uart_tx_en      ; 
logic [7:0]  send_data       ;
logic [7:0]  received_data   ;
logic        uart_tx_busy    ;
logic        uart_rx_ready   ;

// flags
logic        new_byte_flag   ;
logic        done            ;
logic        w_en        ;

logic        write_task_done ;
logic        read_task_done  ;


// data and adrress
logic [ 7:0] payload_h       ;  
logic [ 7:0] payload_l       ;  
logic [ 3:0] address         ;  
logic [11:0] data            ;  
wire [3:0] select_address;    

//===================
//  FSM STATES  
//===================
  
localparam FSM_IDLE  = 2'd0;
localparam FSM_WRITE = 2'd1;
localparam FSM_READ  = 2'd2;
localparam FSM_DONE  = 2'd3;  
  
logic  [1:0]    current_state;
logic  [1:0]    next_state;
  
always_ff @(posedge clk)     // schimbarea starii
    if(!reset_n) current_state <= FSM_IDLE;
    else         current_state <= next_state;


always_comb begin
    case(current_state)
        FSM_IDLE: 
        begin         // nu se intampla nimic   
            w_en       = 1'b0;
            uart_tx_en = 1'b0;
            done       = 1'b0;                 
        end
        FSM_WRITE: 
        begin        // transmisie de la PC la FPGA
            w_en       = 1'b0;
            uart_tx_en = 1'b0;
            done       = 1'b0;
        end
        FSM_READ: 
        begin         // transmisie de la FPGA la PC
            w_en       = 1'b0;
            uart_tx_en = 1'b1;
            done       = 1'b0;
        end
        FSM_DONE: 
        begin         // transmisie finalizata
            w_en       = 1'b1;
            uart_tx_en = 1'b0;
            done       = 1'b1;
        end
    endcase
end

always_comb 
    case(current_state)
    
        FSM_IDLE:   
            if(new_byte_flag)   next_state = (received_data[7:4] == 4'b1010)|| (received_data[7:4] == 4'b1000)
                                              ? FSM_READ : FSM_WRITE;  
            else                next_state = current_state;
            
        FSM_WRITE: 
            if(write_task_done) next_state = FSM_DONE;
            else                next_state = current_state;

        FSM_READ: 
            if(read_task_done)  next_state = FSM_DONE;
            else                next_state = current_state;

        FSM_DONE: 
            next_state = FSM_IDLE;
            
    endcase


assign idle  = (current_state == FSM_IDLE);
assign write = (current_state == FSM_WRITE);
assign read  = (current_state == FSM_READ);


reg write_ff;

always_ff@(posedge clk)
    if(!reset_n)  write_ff <= 1'b0;
    else          write_ff <= write;
    
//===================
//       RTL 
//===================

always_ff@(posedge clk)
    if(!reset_n)  new_byte_flag <= 1'b0;
    else          new_byte_flag <= uart_rx_ready;
    
always_ff@(posedge clk)  // payload_h
    if(!reset_n)  payload_h <= 7'b0;
    else          payload_h <= (idle & new_byte_flag) ? received_data : payload_h;  
    
always_ff@(posedge clk)  // payload_l
    if(!reset_n)  payload_l <= 7'b0;
    else          payload_l <= (write & new_byte_flag) ? received_data : payload_l;    

always_ff@(posedge clk)  // write_task_done
    if(!reset_n)  write_task_done <= 1'b1;
    else          write_task_done <= write & new_byte_flag;

always_ff@(negedge clk)  // data
    if(!reset_n)  data    <= 12'b0;
    else          data    <= write_task_done ? {payload_h[3:0], payload_l} : data;


//==================
//  REGISTER SET 
//==================

assign select_address = payload_h[7:4];   

/*always_comb 
case(select_address)
    4'b0000 :   address = 4'b0000;  // fg_con
    4'b0001 :   address = 4'b0001;  // fg_clk
    4'b0010 :   address = 4'b0010;  // fg_sig
    4'b0011 :   address = 4'b0100;  // fg_amp
    4'b0100 :   address = 4'b0101;  // fg_off
    4'b0101 :   address = 4'b0110;  // fg_ph
    4'b0110 :   address = 4'b0111;  // fg_dc
    4'b0111 :   address = 4'b1110;  // pwm_con
    4'b1000 :   address = 4'b1001;  // pwm_clk
    4'b1001 :   address = 4'b1011;  // pwm_pr
    4'b1010 :   address = 4'b1100;  // pwm_dc
    4'b1011 :   address = 4'b1101;  // pwm_ph
    4'b1100 :   address = 4'b0011;  // fg_step
    4'b1101 :   address = payload_h[3] ? 4'b1010 : 4'b1000; // pwm_tmr : fg_out
    default :   address = 4'b1111;    
endcase
*/

always_comb begin// 1101 -> pwm_tmr, 1000 ->fg_out
    if(select_address == 4'b1010 || select_address == 4'b1000)
        address = received_data[3:0];
    else
        address = select_address;
end
always_ff@(negedge clk)  // addr
    if(!reset_n)  addr <= 4'b1111;
    else          addr <= address;

assign data_in = data; 
assign write_en = w_en & write_ff;   


//=================
// DATA TO BE SENT
//=================

logic [11:0] send_data_12b;
logic [ 7:0] send_data_l;
logic [ 7:0] send_data_h;
logic        first_byte_sent;
logic        second_byte_sent;

assign send_data_12b = data_out; 
assign send_data_h   = {4'b0, send_data_12b[11:8]};
assign send_data_l   = send_data_12b[7:0]; 

/*
always_ff@(posedge clk) begin // read_task_done
    if(!reset_n)
        read_task_done <= 1'b1;
    else
        read_task_done <= read & first_byte_sent_ff & second_byte_sent;
end
*/

always_ff@(posedge clk)
    if(!reset_n)  first_byte_sent <= 1'b0; 
    else          first_byte_sent <= uart_tx_en & (uart_tx_busy);
    

logic first_byte_sent_ff;
always@(posedge clk)
    first_byte_sent_ff <= first_byte_sent;

always_ff@(negedge clk)
    if(!reset_n)
        second_byte_sent <= 1'b0;
    else begin
        if(second_byte_sent & ~uart_tx_busy)
            begin second_byte_sent <= 1'b0; read_task_done <= 1'b1; end
        else if(first_byte_sent & (~uart_tx_busy))
            second_byte_sent <= 1'b1;
        else
            read_task_done <=1'b0;  
    end


always_ff@(posedge clk)
    if(read & (~first_byte_sent))
        send_data <= send_data_h;
    else if(read & first_byte_sent)
        send_data <= send_data_l;
    else
        send_data <= 8'h0;
        

logic uart_tx_en_ff;
always@(posedge clk or posedge read_task_done)
    if(read_task_done)
        uart_tx_en_ff <= 1'b0;
    else
        uart_tx_en_ff <= uart_tx_en;


//=================
//   UART INST
//=================
  uart
    #(.CLK_HZ(50_000_000),         // ceasul
      .BIT_RATE(9600),         // nr de biti pe secunda transmisi
      .PAYLOAD_BITS(8) )            // nr de biti per payload
    uart_inst
    (
        .clk,                       // ceas
        .reset_n,                   // reset
        .uart_rx_en(1'b1),          // enable receptie
        .uart_tx_en(uart_tx_en_ff), // enable transmisie
        .uart_rxd,                  // bit de receptionare
        .send_data,                 // byte trimis
        .received_data,             // byte receptionat
        .uart_tx_busy,              // busy transmisie
        .uart_rx_ready,             // busy receptie
        .uart_txd                   // bit de transmisie
    );
  
endmodule
