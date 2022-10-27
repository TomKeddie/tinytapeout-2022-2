`default_nettype none

module top_tto (
                input [7:0] io_in,
                output [7:0] io_out
                );
  
  wire                      clk = io_in[0];
  wire                      reset = io_in[1];
  wire                      uart_tx_pin;
  wire                      trig;

  assign io_out[7] = uart_tx_pin;

  // instantiate uart
  uart_tx uart_tx(.clk(clk), .reset(reset), .tx_pin(uart_tx_pin), .trig(trig));
endmodule
