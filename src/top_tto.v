`default_nettype none

module top_tto
  #(parameter CLOCK_RATE=1000)
  (
   input [7:0]  io_in,
   output [7:0] io_out
   );
  
  wire                      clk   = io_in[0];
  wire                      reset = io_in[1];
  wire                      stb_1min = io_in[7];
  wire                      uart_tx_pin;
  wire                      lcd_en;
  wire                      lcd_rs;
  wire               [3:0]  lcd_data;

  assign io_out[0] = lcd_data[0];
  assign io_out[1] = lcd_data[1];
  assign io_out[2] = lcd_data[2];
  assign io_out[3] = lcd_data[3];
  assign io_out[4] = lcd_en;
  assign io_out[5] = lcd_rs;
  assign io_out[7] = 0; // uart_tx_pin;

  // instantiate uart
  // uart_tx uart_tx(.clk(clk), .reset(reset), .tx_pin(uart_tx_pin));

  // instatiate lcd
  lcd lcd(.clk(clk), .reset(reset), .stb_1min(stb_1min), .en(lcd_en), .rs(lcd_rs), .data(lcd_data));
  
endmodule
