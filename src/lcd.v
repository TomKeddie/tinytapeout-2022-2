`default_nettype none

// HD74480 LCD driver, assumes 1kHz clock (ie. 1ms period)

module lcd
  #(parameter CLOCK_RATE=1000)
  (
   input        clk,
   input        reset,
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

  reg [7:0]     init_state;

  // time buffer 00:00:00
  // reg [3:0]            time_buffer[0:5];
  reg [5:0]     time_minutes;
  reg [4:0]     time_hours;
  reg [13:0]    time_divider;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      en_int       <= 1'b0;
      rs_int       <= 1'b0;
      data_int     <= 4'b0;
      init_state   <= 0;
      time_minutes <= 0;
      time_hours <= 0;
      time_divider <= 40;
    end else begin
      case(init_state)
        // init_delay 40ms at startup
        0 : begin
          if (time_divider != 0) 
            begin
              time_divider <= time_divider - 1;
            end else begin
              init_state <= 1;
            end                  
        end
        // rising edge of EN for 4 bit init - writing 3
        1 : begin
          data_int   <= 3;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 2;
        end
        // falling edge of EN for 4 bit init - writing 3
        2 : begin
          en_int     <= 1'b0;
          init_state <= 3;
        end
        // delay
        3 : begin
          init_state    <= 4;
        end
        // delay
        4 : begin
          init_state    <= 5;
        end
        // delay
        5 : begin
          init_state    <= 6;
        end
        // delay
        6 : begin
          init_state    <= 7;
        end
        // delay
        7 : begin
          init_state    <= 8;
        end
        // rising edge of EN for 4 bit init (repeated) - writing 3
        8 : begin
          data_int   <= 3;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 9;
        end
        // falling edge of EN for 4 bit init (repeated) - writing 3
        9 : begin
          en_int     <= 1'b0;
          init_state <= 10;
        end
        // delay
        10 : begin
          init_state    <= 11;
        end
        // delay
        11 : begin
          init_state    <= 12;
        end
        // delay
        12 : begin
          init_state    <= 13;
        end
        // delay
        13 : begin
          init_state    <= 14;
        end
        // delay
        14 : begin
          init_state    <= 15;
        end
        // rising edge of EN for 4 bit init (repeated) - writing 3
        15 : begin
          data_int   <= 3;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 16;
        end
        // falling edge of EN for 4 bit init (repeated) - writing 3
        16 : begin
          en_int     <= 1'b0;
          init_state <= 17;
        end
        // delay
        17 : begin
          init_state    <= 18;
        end
        // rising edge of EN for 4 bit mode - writing 2
        18 : begin
          data_int   <= 2;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 19;
        end
        // falling edge of EN for 4 bit mode - writing 2
        19 : begin
          en_int     <= 1'b0;
          init_state <= 20;
        end
        // rising edge of EN for FUNCTIONSET (MSB) - writing 2
        20 : begin
          data_int   <= 2;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 21;
        end
        // falling edge of EN for FUNCTIONSET (MSB) - writing 2
        21 : begin
          en_int     <= 1'b0;
          init_state <= 22;
        end
        // rising edge of EN for FUNCTIONSET (LSB) - writing 8
        22 : begin
          data_int   <= 8;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 23;
        end
        // falling edge of EN for FUNCTIONSET (LSB) - writing 8
        23 : begin
          en_int     <= 1'b0;
          init_state <= 24;
        end
        // rising edge of EN for DISPLAYCONTROL (MSB) - writing 0
        24 : begin
          data_int   <= 0;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 25;
        end
        // falling edge of EN for DISPLAYCONTROL (MSB) - writing 0
        25 : begin
          en_int     <= 1'b0;
          init_state <= 26;
        end
        // rising edge of EN for DISPLAYCONTROL (LSB) - writing 12
        26 : begin
          data_int   <= 12;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 27;
        end
        // falling edge of EN for DISPLAYCONTROL (LSB) - writing 12
        27 : begin
          en_int     <= 1'b0;
          init_state <= 28;
        end
        // rising edge of EN for ENTRYMODESET (MSB) - writing 0
        28 : begin
          data_int   <= 0;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 29;
        end
        // falling edge of EN for ENTRYMODESET (MSB) - writing 0
        29 : begin
          en_int     <= 1'b0;
          init_state <= 30;
        end
        // rising edge of EN for ENTRYMODESET (LSB) - writing 6
        30 : begin
          data_int   <= 6;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 31;
        end
        // falling edge of EN for ENTRYMODESET (LSB) - writing 6
        31 : begin
          en_int     <= 1'b0;
          init_state <= 32;
        end
        // rising edge of EN for CLEARDISPLAY (MSB) - writing 0
        32 : begin
          data_int   <= 0;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 33;
        end
        // falling edge of EN for CLEARDISPLAY (MSB) - writing 0
        33 : begin
          en_int     <= 1'b0;
          init_state <= 34;
        end
        // rising edge of EN for CLEARDISPLAY (LSB) - writing 1
        34 : begin
          data_int   <= 1;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 35;
        end
        // falling edge of EN for CLEARDISPLAY (LSB) - writing 1
        35 : begin
          en_int     <= 1'b0;
          init_state <= 36;
        end
        // rising edge of EN for I (MSB) - writing 4
        36 : begin
          data_int   <= 4;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 37;
        end
        // falling edge of EN for I (MSB) - writing 4
        37 : begin
          en_int     <= 1'b0;
          init_state <= 38;
        end
        // rising edge of EN for I (LSB) - writing 9
        38 : begin
          data_int   <= 9;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 39;
        end
        // falling edge of EN for I (LSB) - writing 9
        39 : begin
          en_int     <= 1'b0;
          init_state <= 40;
        end
        // rising edge of EN for t (MSB) - writing 7
        40 : begin
          data_int   <= 7;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 41;
        end
        // falling edge of EN for t (MSB) - writing 7
        41 : begin
          en_int     <= 1'b0;
          init_state <= 42;
        end
        // rising edge of EN for t (LSB) - writing 4
        42 : begin
          data_int   <= 4;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 43;
        end
        // falling edge of EN for t (LSB) - writing 4
        43 : begin
          en_int     <= 1'b0;
          init_state <= 44;
        end
        // rising edge of EN for s (MSB) - writing 7
        44 : begin
          data_int   <= 7;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 45;
        end
        // falling edge of EN for s (MSB) - writing 7
        45 : begin
          en_int     <= 1'b0;
          init_state <= 46;
        end
        // rising edge of EN for s (LSB) - writing 3
        46 : begin
          data_int   <= 3;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 47;
        end
        // falling edge of EN for s (LSB) - writing 3
        47 : begin
          en_int     <= 1'b0;
          init_state <= 48;
        end
        // rising edge of EN for   (MSB) - writing 2
        48 : begin
          data_int   <= 2;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 49;
        end
        // falling edge of EN for   (MSB) - writing 2
        49 : begin
          en_int     <= 1'b0;
          init_state <= 50;
        end
        // rising edge of EN for   (LSB) - writing 0
        50 : begin
          data_int   <= 0;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 51;
        end
        // falling edge of EN for   (LSB) - writing 0
        51 : begin
          en_int     <= 1'b0;
          init_state <= 52;
        end
        // rising edge of EN for T (MSB) - writing 5
        52 : begin
          data_int   <= 5;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 53;
        end
        // falling edge of EN for T (MSB) - writing 5
        53 : begin
          en_int     <= 1'b0;
          init_state <= 54;
        end
        // rising edge of EN for T (LSB) - writing 4
        54 : begin
          data_int   <= 4;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 55;
        end
        // falling edge of EN for T (LSB) - writing 4
        55 : begin
          en_int     <= 1'b0;
          init_state <= 56;
        end
        // rising edge of EN for a (MSB) - writing 6
        56 : begin
          data_int   <= 6;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 57;
        end
        // falling edge of EN for a (MSB) - writing 6
        57 : begin
          en_int     <= 1'b0;
          init_state <= 58;
        end
        // rising edge of EN for a (LSB) - writing 1
        58 : begin
          data_int   <= 1;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 59;
        end
        // falling edge of EN for a (LSB) - writing 1
        59 : begin
          en_int     <= 1'b0;
          init_state <= 60;
        end
        // rising edge of EN for p (MSB) - writing 7
        60 : begin
          data_int   <= 7;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 61;
        end
        // falling edge of EN for p (MSB) - writing 7
        61 : begin
          en_int     <= 1'b0;
          init_state <= 62;
        end
        // rising edge of EN for p (LSB) - writing 0
        62 : begin
          data_int   <= 0;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 63;
        end
        // falling edge of EN for p (LSB) - writing 0
        63 : begin
          en_int     <= 1'b0;
          init_state <= 64;
        end
        // rising edge of EN for e (MSB) - writing 6
        64 : begin
          data_int   <= 6;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 65;
        end
        // falling edge of EN for e (MSB) - writing 6
        65 : begin
          en_int     <= 1'b0;
          init_state <= 66;
        end
        // rising edge of EN for e (LSB) - writing 5
        66 : begin
          data_int   <= 5;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 67;
        end
        // falling edge of EN for e (LSB) - writing 5
        67 : begin
          en_int     <= 1'b0;
          init_state <= 68;
        end
        // rising edge of EN for o (MSB) - writing 6
        68 : begin
          data_int   <= 6;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 69;
        end
        // falling edge of EN for o (MSB) - writing 6
        69 : begin
          en_int     <= 1'b0;
          init_state <= 70;
        end
        // rising edge of EN for o (LSB) - writing 15
        70 : begin
          data_int   <= 15;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 71;
        end
        // falling edge of EN for o (LSB) - writing 15
        71 : begin
          en_int     <= 1'b0;
          init_state <= 72;
        end
        // rising edge of EN for u (MSB) - writing 7
        72 : begin
          data_int   <= 7;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 73;
        end
        // falling edge of EN for u (MSB) - writing 7
        73 : begin
          en_int     <= 1'b0;
          init_state <= 74;
        end
        // rising edge of EN for u (LSB) - writing 5
        74 : begin
          data_int   <= 5;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 75;
        end
        // falling edge of EN for u (LSB) - writing 5
        75 : begin
          en_int     <= 1'b0;
          init_state <= 76;
        end
        // rising edge of EN for t (MSB) - writing 7
        76 : begin
          data_int   <= 7;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 77;
        end
        // falling edge of EN for t (MSB) - writing 7
        77 : begin
          en_int     <= 1'b0;
          init_state <= 78;
        end
        // rising edge of EN for t (LSB) - writing 4
        78 : begin
          data_int   <= 4;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 79;
        end
        // falling edge of EN for t (LSB) - writing 4
        79 : begin
          en_int     <= 1'b0;
          init_state <= 80;
        end
        // rising edge of EN for   (MSB) - writing 2
        80 : begin
          data_int   <= 2;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 81;
        end
        // falling edge of EN for   (MSB) - writing 2
        81 : begin
          en_int     <= 1'b0;
          init_state <= 82;
        end
        // rising edge of EN for   (LSB) - writing 0
        82 : begin
          data_int   <= 0;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 83;
        end
        // falling edge of EN for   (LSB) - writing 0
        83 : begin
          en_int     <= 1'b0;
          init_state <= 84;
        end
        // rising edge of EN for T (MSB) - writing 5
        84 : begin
          data_int   <= 5;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 85;
        end
        // falling edge of EN for T (MSB) - writing 5
        85 : begin
          en_int     <= 1'b0;
          init_state <= 86;
        end
        // rising edge of EN for T (LSB) - writing 4
        86 : begin
          data_int   <= 4;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 87;
        end
        // falling edge of EN for T (LSB) - writing 4
        87 : begin
          en_int     <= 1'b0;
          init_state <= 88;
        end
        // rising edge of EN for i (MSB) - writing 6
        88 : begin
          data_int   <= 6;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 89;
        end
        // falling edge of EN for i (MSB) - writing 6
        89 : begin
          en_int     <= 1'b0;
          init_state <= 90;
        end
        // rising edge of EN for i (LSB) - writing 9
        90 : begin
          data_int   <= 9;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 91;
        end
        // falling edge of EN for i (LSB) - writing 9
        91 : begin
          en_int     <= 1'b0;
          init_state <= 92;
        end
        // rising edge of EN for m (MSB) - writing 6
        92 : begin
          data_int   <= 6;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 93;
        end
        // falling edge of EN for m (MSB) - writing 6
        93 : begin
          en_int     <= 1'b0;
          init_state <= 94;
        end
        // rising edge of EN for m (LSB) - writing 13
        94 : begin
          data_int   <= 13;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 95;
        end
        // falling edge of EN for m (LSB) - writing 13
        95 : begin
          en_int     <= 1'b0;
          init_state <= 96;
        end
        // rising edge of EN for e (MSB) - writing 6
        96 : begin
          data_int   <= 6;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 97;
        end
        // falling edge of EN for e (MSB) - writing 6
        97 : begin
          en_int     <= 1'b0;
          init_state <= 98;
        end
        // rising edge of EN for e (LSB) - writing 5
        98 : begin
          data_int   <= 5;
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 99;
        end
        // falling edge of EN for e (LSB) - writing 5
        99 : begin
          en_int     <= 1'b0;
          init_state <= 100;
        end
        // rising edge of EN for SETDDRAMADDR + 2nd Row (MSB) - writing 12
        100 : begin
          data_int   <= 12;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 101;
        end
        // falling edge of EN for SETDDRAMADDR + 2nd Row (MSB) - writing 12
        101 : begin
          en_int     <= 1'b0;
          init_state <= 102;
        end
        // rising edge of EN for SETDDRAMADDR + 2nd Row (LSB) - writing 4
        102 : begin
          data_int   <= 4;
          rs_int     <= 1'b0;
          en_int     <= 1'b1;
          init_state <= 103;
        end
        // falling edge of EN for SETDDRAMADDR + 2nd Row (LSB) - writing 4
        103 : begin
          en_int     <= 1'b0;
          init_state <= 135;
        end
        // display the first digit of the hour
        135 : begin
          if (time_hours < 10) begin
            data_int <= " " >> 4;
          end else begin
            data_int   <= "0" >> 4; // MSB
          end
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 136;
        end
        // wait 0ms
        136 : begin
          en_int <= 1'b0;
          init_state  <= 137;
        end
        137 : begin
          if (time_hours < 10) begin
            data_int <= " " & 15;
          end else begin
            data_int   <= time_hours/10; // LSB
          end
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 138;
        end
        // wait 0ms
        138 : begin
          en_int     <= 1'b0;
          init_state <= 139;
        end
        // display the second digit of the hour
        139 : begin
          data_int   <= "0" >> 4; // MSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 140;
        end
        // wait 0ms
        140 : begin
          en_int <= 1'b0;
          init_state  <= 141;
        end
        141 : begin
          data_int   <= time_hours % 10; // LSB
          rs_int     <= 1'b1;
          en_int     <= 1'b1;
          init_state <= 142;
        end
        // wait 0ms
        default : begin
          en_int     <= 1'b0;
          init_state <= 100;
        end
      endcase // case (init_state)

      if (init_state != 0 && time_divider == (CLOCK_RATE/60-1)) begin
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
      end
    end
  end
endmodule
