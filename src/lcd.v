`default_nettype none

// HD74480 LCD driver, assumes 1kHz clock (ie. 1ms period)

module lcd (
            input        clk,
            input        reset,
            output       en,
            output       rs, 
            output [3:0] data 
            );


  reg                  en_int;
  reg                  rs_int;
  reg [3:0]            data_int;
  assign en   = en_int;
  assign rs   = rs_int;
  assign data = data_int;
  reg [6:0]            delay;

  reg [7:0]            state;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      en_int   <= 1'b0;
      rs_int   <= 1'b0;
      data_int <= 4'b0;
      state    <= 0;
      delay    <= 40;
    end else begin
      case(state)
        // delay 40ms at startup
        0 : begin
          if (delay != 0) 
            begin
              delay <= delay - 1;
            end else begin
              state <= 1;        
            end                  
        end
        // init 4 bit mode
        1 : begin
          data_int <= 3;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 2;
        end
        // wait 0ms
        2 : begin
          en_int <= 1'b0;
          state  <= 3;
        end
        // wait 1ms
        3 : begin
          state  <= 4;
        end
        // wait 2ms
        4 : begin
          state  <= 5;
        end
        // wait 3ms
        5 : begin
          state  <= 6;
        end
        // wait 4ms
        6 : begin
          state  <= 7;
        end
        // wait 5ms
        7 : begin
          state  <= 8;
        end
        // repeat init 4 bit mode
        8 : begin
          data_int <= 3;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 9;
        end
        // wait 0ms
        9 : begin
          en_int <= 1'b0;
          state  <= 10;
        end
        // wait 1ms
        10 : begin
          state  <= 11;
        end
        // wait 2ms
        11 : begin
          state  <= 12;
        end
        // wait 3ms
        12 : begin
          state  <= 13;
        end
        // wait 4ms
        13 : begin
          state  <= 14;
        end
        // wait 5ms
        14 : begin
          state  <= 15;
        end
        // repeat init 4 bit mode
        15 : begin
          data_int <= 3;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 16;
        end
        // wait 0ms
        16 : begin
          en_int <= 1'b0;
          state  <= 17;
        end
        // wait 1ms
        17 : begin
          state  <= 18;
        end
        // set to 4 bit mode
        18 : begin
          data_int <= 2;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 19;
        end
        // wait 0ms
        19 : begin
          en_int <= 1'b0;
          state  <= 20;
        end
        // FUNCTIONSET MSB
        20 : begin
          data_int <= 2;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 21;
        end
        // wait 0ms
        21 : begin
          en_int <= 1'b0;
          state  <= 22;
        end
        // FUNCTIONSET LSB (2 lines)
        22 : begin
          data_int <= 8; // C
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 23;
        end
        // wait 0ms
        23 : begin
          en_int <= 1'b0;
          state  <= 24;
        end
        // DISPLAYCONTROL MSB
        24 : begin
          data_int <= 0;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 25;
        end
        // wait 0ms
        25 : begin
          en_int <= 1'b0;
          state  <= 26;
        end
        // DISPLAYCONTROL LSB
        26 : begin
          data_int <= 8 | 4; // display on
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 27;
        end
        // wait 0ms
        27 : begin
          en_int <= 1'b0;
          state  <= 28;
        end
        // CLEARDISPLAY MSB
        28 : begin
          data_int <= 0;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 29;
        end
        // wait 0ms
        29 : begin
          en_int <= 1'b0;
          state  <= 30;
        end
        // CLEARDISPLAY LSB
        30 : begin
          data_int <= 1;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 31;
        end
        // wait 0ms
        31 : begin
          en_int <= 1'b0;
          state  <= 32;
        end
        // wait 1ms
        32 : begin
          state  <= 33;
        end
        // wait 2ms
        33 : begin
          state  <= 34;
        end
        // ENTRYMODESET MSB
        34 : begin
          data_int <= 0;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 35;
        end
        // wait 0ms
        35 : begin
          en_int <= 1'b0;
          state  <= 36;
        end
        // ENTRYMODESET LSB
        36 : begin
          data_int <= 4 | 2; // ENTRYLEFT | ENTRYSHIFTINCREMENT
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          state    <= 37;
        end
        // wait 0ms
        37 : begin
          en_int <= 1'b0;
          state  <= 38;
        end
        // init done
        38 : begin
          data_int <= ("T" >> 4);
          rs_int   <= 1'b1;
          en_int   <= 1'b1;
          state    <= 39;
        end
        // wait 0ms
        39 : begin
          en_int <= 1'b0;
          state  <= 40;
        end
        40 : begin
          data_int <= ("T" & 15);
          rs_int   <= 1'b1;
          en_int   <= 1'b1;
          state    <= 41;
        end
        // wait 0ms
        41 : begin
          en_int <= 1'b0;
          state  <= 42;
        end
        default : state <= state;
      endcase
    end
  end
endmodule
