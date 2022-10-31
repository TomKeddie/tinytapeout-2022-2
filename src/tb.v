`default_nettype none
`timescale 1ns/1ps

/*
 this testbench just instantiates the module and makes some convenient wires
 that can be driven / tested by the cocotb test.py
 */

module tb (
           // testbench is controlled by test.py
           input  clk,
           input  rst,
           output uart_tx_pin
           );

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile ("tb.vcd");
    $dumpvars (0, tb);
    #1;
  end

  // wire up the inputs and outputs
  wire uart_tx_pin;

  wire [3:0] lcd_data;
  wire       lcd_en;
  wire       lcd_rs;

  // instantiate the DUT
  top #(.DIVIDER(6),.DELAY_BIT(4)) top (.CLK(clk), .P1B2(rst), .P1A1(lcd_data[0]), .P1A2(lcd_data[1]), .P1A3(lcd_data[2]), .P1A4(lcd_data[3]),
          .P1A7(lcd_en), .P1A8(lcd_rs),
          .P1A10(uart_tx_pin));

endmodule
