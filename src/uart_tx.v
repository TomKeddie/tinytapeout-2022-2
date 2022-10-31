`default_nettype none

module uart_tx (
                input  clk,
                input  reset,
                output tx_pin
                );

  wire [7:0]           text [0:12];
  assign text[0] = "T";
  assign text[1] = "i";
  assign text[2] = "n";
  assign text[3] = "y";
  assign text[4] = " ";
  assign text[5] = "T";
  assign text[6] = "a";
  assign text[7] = "p";
  assign text[8] = "e";
  assign text[9] = "o";
  assign text[10] = "u";
  assign text[11] = "t";
  assign text[12] = " ";
  
  reg [3:0]            bit_counter;
  reg [3:0]            text_index;
  
  reg                  tx_pin_int;
  assign tx_pin = tx_pin_int;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      bit_counter <= 0;
      tx_pin_int  <= 1'b1;
      text_index <= 0;
    end else begin
      // bit counter - START, 8xDATA, STOP, IDLE = 11 bits
      if (bit_counter == 10) begin
        // reset
        bit_counter    <= 0;
        if (text_index == 12) begin
          text_index <= 0;
        end else begin
          text_index <= text_index + 1;
        end
      end else begin
        // increment counter
        bit_counter <= bit_counter + 1;
      end
      case(bit_counter)
        0       : tx_pin_int = 1'b1; // idle
        1       : tx_pin_int = 1'b0; // start
        10      : tx_pin_int = 1'b1; // stop
        default : tx_pin_int = text[text_index][bit_counter-2];
      endcase
    end
  end
endmodule
