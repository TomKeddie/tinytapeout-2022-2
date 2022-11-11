`default_nettype none

// HD74480 LCD driver, assumes 1kHz clock (ie. 1ms period)

module lcd
  #(parameter CLOCK_RATE=1000)
  (
   input        clk,
   input        reset,
   input        hour_inc,
   input        min_inc,
   output       en,
   output       rs, 
   output [3:0] data
   ); 


  reg           en_int;
  reg           rs_int;
  reg [3:0]     data_int;
  assign en   = en_int;
  assign rs   = rs_int;
  assign data = data_int;

  reg [5:0]     init_state;
  reg [4:0]     idx;

  wire [7:0]    init_sequence [0:3];
  assign init_sequence[0] = 'h28; // FUNCTIONSET
  assign init_sequence[1] = 'h0c; // DISPLAYCONTROL 
  assign init_sequence[2] = 'h06; // ENTRYMODESET
  assign init_sequence[3] = 'h01; // CLEARDISPLAY

  reg [5:0]     time_minutes;
  reg [4:0]     time_hours;
  reg [15:0]    time_divider;

  reg           min_inc_1d;
  reg           hour_inc_1d;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      init_state   <= 0;
      time_divider <= 40;
      time_minutes <= 0;
      time_hours   <= 0;
    end else begin
      case(init_state)
        // time_divider 40ms at startup
        0 : begin
          if (time_divider != 0)
            begin
              time_divider <= time_divider - 1;
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
          en_int     <= 1'b0;
          init_state <= 20;
          idx <= 0;
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
        26: begin
          // cursor to home
          data_int <= 8; // SETDDRAMADDR
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 27;
        end
        // wait 0ms
        27 : begin
          en_int <= 1'b0;
          init_state  <= 28;
        end
        28: begin
          // cursor to home
          data_int    <= 0;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 29;
        end
        // wait 0ms
        29 : begin
          en_int <= 1'b0;
          init_state  <= 30;
        end
        // display the first digit of the hour
        30 : begin
          if (time_hours < 10) begin
            data_int <= " " >> 4;
          end else begin
            data_int   <= "0" >> 4; // MSB
          end
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 31;
        end
        // wait 0ms
        31 : begin
          en_int <= 1'b0;
          init_state  <= 32;
        end
        32 : begin
          if (time_hours < 10) begin
            data_int <= " " & 15;
          end else begin
            data_int   <= time_hours / 10; // LSB
          end
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 33;
        end
        // wait 0ms
        33 : begin
          en_int     <= 1'b0;
          init_state <= 34;
        end
        // display the second digit of the hour
        34 : begin
          data_int   <= "0" >> 4; // MSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 35;
        end
        // wait 0ms
        35 : begin
          en_int <= 1'b0;
          init_state  <= 36;
        end
        36 : begin
          data_int   <= time_hours % 10; // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 37;
        end
        // wait 0ms
        37 : begin
          en_int     <= 1'b0;
          init_state <= 38;
        end
        // display the colon
        38 : begin
          data_int   <= ":" >> 4; // MSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 39;
        end
        // wait 0ms
        39 : begin
          en_int <= 1'b0;
          init_state  <= 40;
        end
        40 : begin
          data_int   <= ":" & 15; // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 41;
        end
        // wait 0ms
        41 : begin
          en_int     <= 1'b0;
          init_state <= 42;
        end
        // display the first digit of the minutes
        42 : begin
          data_int <= "0" >> 4; // MSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 43;
        end
        // wait 0ms
        43 : begin
          en_int <= 1'b0;
          init_state  <= 44;
        end
        44 : begin
          data_int   <= time_minutes / 10; // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 45;
        end
        // wait 0ms
        45 : begin
          en_int     <= 1'b0;
          init_state <= 46;
        end
        // display the second digit of the minutes
        46 : begin
          data_int   <= "0" >> 4; // MSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 47;
        end
        // wait 0ms
        47 : begin
          en_int <= 1'b0;
          init_state  <= 48;
        end
        48 : begin
          data_int   <= time_minutes % 10; // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 49;
        end
        // wait 0ms
        default : begin
          en_int     <= 1'b0;
          init_state <= 26;
        end
      endcase // case (init_state)

      // time set
      min_inc_1d  <= min_inc;
      hour_inc_1d <= hour_inc;
      if (!min_inc_1d && min_inc) begin
        time_minutes <= time_minutes + 1;
        time_divider <= 0;
      end
      if (!hour_inc_1d && hour_inc) begin
        time_hours <= time_hours + 1;
      end

      // clock divider and time incrementer
      if (init_state != 0) begin
        if (time_divider == (CLOCK_RATE*60-1)) begin
          time_divider     <= 0;
          if (time_minutes != 59) begin
            time_minutes <= time_minutes + 1;
          end else begin
            time_minutes   <= 0;
            if (time_hours != 23) begin
              time_hours <= time_hours + 1;
            end else begin
              time_hours <= 0;
            end
          end
        end else begin
          time_divider <= time_divider + 1;
        end // else: !if(time_divider == (CLOCK_RATE*60-1))
      end
    end
  end
endmodule
