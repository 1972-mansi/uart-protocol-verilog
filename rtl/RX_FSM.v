module RX_FSM (
  clk,
  rst,
  start_bit_detected,
  run_shift,
  parity_load,
  parity_error,
  chk_stop,
  sample_done
);

  input clk;
  input rst;
  input start_bit_detected;
  input parity_error;

  output reg run_shift;
  output reg parity_load;
  output reg chk_stop;
  output sample_done;

  reg [3:0] bcount;
  reg [3:0] count;
  reg count_en;

  wire data_done;

  parameter IDLE   = 2'b00,
            START  = 2'b01,
            DATA   = 2'b10,
            STOP   = 2'b11;

  reg [1:0] present_state, next_state;

  assign sample_done = (bcount == 15);
  assign data_done   = (count == 10);

  always @(posedge clk or posedge rst) begin
    if (rst)
      bcount <= 0;
    else begin
      if (present_state == IDLE)
        bcount <= 0;
      else if (present_state == START) begin
        if (bcount == 7)
          bcount <= 0;
        else
          bcount <= bcount + 1;
      end
      else if (present_state == DATA) begin
        if (bcount == 15)
          bcount <= 0;
        else
          bcount <= bcount + 1;
      end
      else
        bcount <= 0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst)
      count <= 0;
    else begin
      if (count_en && sample_done)
        count <= count + 1;
      else if (!count_en)
        count <= 0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst)
      present_state <= IDLE;
    else
      present_state <= next_state;
  end

  always @(*) begin
    case (present_state)

      IDLE: begin
        if (start_bit_detected)
          next_state = START;
        else
          next_state = IDLE;
      end

      START: begin
        if (bcount == 7)
          next_state = DATA;
        else
          next_state = START;
      end

      DATA: begin
        if (data_done)
          next_state = STOP;
        else
          next_state = DATA;
      end

      STOP: begin
        next_state = IDLE;
      end

      default: next_state = IDLE;

    endcase
  end

  always @(*) begin
    run_shift   = 0;
    parity_load = 0;
    chk_stop    = 0;
    count_en    = 0;

    case (present_state)

      IDLE: begin
        run_shift   = 0;
        parity_load = 0;
        chk_stop    = 0;
        count_en    = 0;
      end

      START: begin
        run_shift   = 0;
        parity_load = 0;
        chk_stop    = 0;
        count_en    = 0;
      end

      DATA: begin
        run_shift   = sample_done;
        parity_load = 0;
        chk_stop    = 0;
        count_en    = 1;
      end

      STOP: begin
        run_shift   = 0;
        parity_load = 1;
        chk_stop    = 1;
        count_en    = 0;
      end

    endcase
  end

endmodule