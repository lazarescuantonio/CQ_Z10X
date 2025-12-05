`timescale 1ns / 1ps

module uart (
input               clk     , // Top level system clock input.
input               reset_n , 

input   wire        uart_rxd, // UART Recieve pin.
output  wire        uart_txd, // UART transmit pin.

input               uart_rx_en,
input               uart_tx_en,

output              uart_tx_busy,
output              uart_rx_ready,

input   wire [7:0]  send_data,
output  wire [7:0]  received_data
);

// Clock frequency in hertz.
parameter CLK_HZ = 50000000;
parameter BIT_RATE =   9600;
parameter PAYLOAD_BITS = 8;

wire [PAYLOAD_BITS-1:0]  uart_rx_data;
wire        uart_rx_valid;
wire        uart_rx_break;

//wire        uart_tx_busy;
wire [PAYLOAD_BITS-1:0]  uart_tx_data;

reg  [PAYLOAD_BITS-1:0]  led_reg;
assign received_data = led_reg;

// ------------------------------------------------------------------------- 

assign uart_rx_ready = uart_rx_valid;

assign uart_tx_data = send_data;
//assign uart_tx_en   = uart_rx_valid;

always @(posedge clk) begin
    if(!reset_n) begin
        led_reg <= 8'hF0;
    end else if(uart_rx_valid) begin
        led_reg <= uart_rx_data[7:0];
    end
end


// ------------------------------------------------------------------------- 

//
// UART RX
uart_rx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_rx(
.clk          (clk          ), // Top level system clock input.
.resetn       (reset_n      ), // Synchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (uart_rx_en   ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data )  // The recieved data.
);

//
// UART Transmitter module.
//
uart_tx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_tx(
.clk          (clk          ),
.resetn       (reset_n      ),
.uart_txd     (uart_txd     ),
.uart_tx_en   (uart_tx_en   ),
.uart_tx_busy (uart_tx_busy ),
.uart_tx_data (uart_tx_data ) 
);


endmodule