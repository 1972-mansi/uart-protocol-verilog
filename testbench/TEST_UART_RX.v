`timescale 1ns/1ps

module TEST_UART_RX;

  reg clk;
  reg rst;
  reg TX_start;
  reg [7:0] DATA_in;

  wire TX_busy;
  wire [7:0] DATA_out;
  wire parity_error;
  wire stop_error;
  wire op_valid;

  UART dut (
    clk,
    rst,
    TX_start,
    DATA_in,
    TX_busy,
    DATA_out,
    parity_error,
    stop_error,
    op_valid
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    TX_start = 0;
    DATA_in = 0;

    rst = 1;
    #100;
    rst = 0;

    DATA_in = 8'hdd;

    #1000;
    TX_start = 1;

    #10000;
    TX_start = 0;

    #200000;
    $finish;
  end

  always @(posedge op_valid)
    $display("DATA_out = %h", DATA_out);

endmodule