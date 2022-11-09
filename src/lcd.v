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

  reg [6:0]            init_delay;
  reg [5:0]            init_state;
  reg                  init_done;
  reg [4:0]            idx;

  wire [7:0]           init_sequence [0:3];
  assign init_sequence[0] = 'h28; // FUNCTIONSET
  assign init_sequence[1] = 'h0c; // DISPLAYCONTROL 
  assign init_sequence[2] = 'h06; // ENTRYMODESET
  assign init_sequence[3] = 'h01; // CLEARDISPLAY

  wire [7:0]           init_text [0:15];
  assign init_text[0]  = "I";
  assign init_text[1]  = "t";
  assign init_text[2]  = "s";
  assign init_text[3]  = " ";
  assign init_text[4]  = "T";
  assign init_text[5]  = "a";
  assign init_text[6]  = "p";
  assign init_text[7]  = "e";
  assign init_text[8]  = "o";
  assign init_text[9]  = "u";
  assign init_text[10] = "t";
  assign init_text[11] = " ";
  assign init_text[12] = "T";
  assign init_text[13] = "i";
  assign init_text[14] = "m";
  assign init_text[15] = "e";

  // time buffer 00:00:00
  reg [7:0]            time_buffer[0:7];
  reg                  time_refresh;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      en_int         <= 1'b0;
      rs_int         <= 1'b0;
      data_int       <= 4'b0;
      init_state     <= 0;
      init_delay     <= 40;
      init_done      <= 0;
      idx            <= 0;
      time_buffer[0] <= "0";
      time_buffer[1] <= "0";
      time_buffer[2] <= ":";
      time_buffer[3] <= "0";
      time_buffer[4] <= "0";
      time_buffer[5] <= ":";
      time_buffer[6] <= "0";
      time_buffer[7] <= "0";
      time_refresh   <= 1;
    end else begin
      case(init_state)
        // init_delay 40ms at startup
        0 : begin
          if (init_delay != 0) 
            begin
              init_delay <= init_delay - 1;
            end else begin
              init_state <= 1;        
            end                  
        end
        // init 4 bit mode
        1 : begin
          data_int <= 3;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          init_state    <= 2;
        end
        // wait 0ms
        2 : begin
          en_int <= 1'b0;
          init_state  <= 3;
        end
        // wait 1ms
        3 : begin
          init_state  <= 4;
        end
        // wait 2ms
        4 : begin
          init_state  <= 5;
        end
        // wait 3ms
        5 : begin
          init_state  <= 6;
        end
        // wait 4ms
        6 : begin
          init_state  <= 7;
        end
        // wait 5ms
        7 : begin
          init_state  <= 8;
        end
        // repeat init 4 bit mode
        8 : begin
          data_int <= 3;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          init_state    <= 9;
        end
        // wait 0ms
        9 : begin
          en_int <= 1'b0;
          init_state  <= 10;
        end
        // wait 1ms
        10 : begin
          init_state  <= 11;
        end
        // wait 2ms
        11 : begin
          init_state  <= 12;
        end
        // wait 3ms
        12 : begin
          init_state  <= 13;
        end
        // wait 4ms
        13 : begin
          init_state  <= 14;
        end
        // wait 5ms
        14 : begin
          init_state  <= 15;
        end
        // repeat init 4 bit mode
        15 : begin
          data_int <= 3;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          init_state    <= 16;
        end
        // wait 0ms
        16 : begin
          en_int <= 1'b0;
          init_state  <= 17;
        end
        // wait 1ms
        17 : begin
          init_state  <= 18;
        end
        // set to 4 bit mode
        18 : begin
          data_int <= 2;
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          init_state    <= 19;
        end
        // wait 0ms
        19 : begin
          en_int <= 1'b0;
          init_state  <= 20;
        end
        20 : begin
          data_int <= (init_sequence[idx] >> 4);
          rs_int   <= 1'b0;
          en_int   <= 1'b1;
          init_state    <= 21;
        end
        // wait 0ms
        21 : begin
          en_int <= 1'b0;
          init_state  <= 22;
        end
        22 : begin
          data_int   <= (init_sequence[idx] & 15);
          rs_int   <= 1'b0;
          en_int     <= 1'b1;
          idx <= idx + 1;
          init_state <= 23;
        end
        // wait 0ms
        23 : begin
          en_int     <= 1'b0;
          if (idx == 4) begin
            init_state <= 24;
            idx <= 0;
          end else begin
            init_state <= 20;
          end
        end
        // wait 1ms
        24 : begin
          init_state  <= 25;
        end
        // wait 2ms
        25 : begin
          init_state  <= 26;
        end
        // init done
        26 : begin
          data_int <= (init_text[idx] >> 4); // MSB
          rs_int   <= 1'b1;
          en_int   <= 1'b1;
          init_state    <= 27;
        end
        // wait 0ms
        27 : begin
          en_int <= 1'b0;
          init_state  <= 28;
        end
        28 : begin
          data_int   <= (init_text[idx] & 15); // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 29;
          idx <= idx + 1;
        end
        // wait 0ms
        29 : begin
          en_int     <= 1'b0;
          if (idx == 16) begin
            init_state <= 30;
            idx <= 0;
          end else begin
            init_state <= 26;
          end
        end
        // time refresh
        30 : begin
          if (time_refresh == 1) begin
            time_refresh  = 0;
            init_state   <= 31;
          end
        end                     
        31: begin
          // cursor to second row
          data_int <= 8 + 4; // SETDDRAMADDR + 2nd Row
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 32;
        end
        // wait 0ms
        32 : begin
          en_int <= 1'b0;
          init_state  <= 33;
        end
        33: begin
          // cursor to second row, 4th column
          data_int <= 4;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 34;
        end
        // wait 0ms
        34 : begin
          en_int <= 1'b0;
          init_state  <= 35;
        end
        // display the time
        35 : begin
          data_int <= (time_buffer[idx] >> 4); // MSB
          rs_int   <= 1'b1;
          en_int   <= 1'b1;
          init_state    <= 36;
        end
        // wait 0ms
        36 : begin
          en_int <= 1'b0;
          init_state  <= 37;
        end
        37 : begin
          data_int   <= (time_buffer[idx] & 15); // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 38;
          idx <= idx + 1;
        end
        // wait 0ms
        38 : begin
          en_int     <= 1'b0;
          if (idx == 8) begin
            init_state <= 39;
            idx <= 0;
          end else begin
            init_state <= 35;
          end
        end
        default : begin
          init_state <= 30;
        end
      endcase
    end
  end
endmodule
