module UART (
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

  input clk;
  input rst;
  input TX_start;
  input [7:0] DATA_in;

  output TX_busy;
  output [7:0] DATA_out;
  output parity_error;
  output stop_error;
  output op_valid;

  wire tx_data_out;
  wire clk_rx;
  wire clk_tx;

  BRG dut_BRG (
    .clk_in(clk),
    .rst(rst),
    .clk_rx(clk_rx),
    .clk_tx(clk_tx)
  );

  UART_RX dut_RX (
    .clk(clk_rx),
    .rst(rst),
    .rx_data_in(tx_data_out),
    .rx_data_out(DATA_out),
    .parity_error(parity_error),
    .stop_error(stop_error),
    .rx_done(op_valid)
  );

  UART_TX dut_TX (
    .clk(clk_tx),
    .rst(rst),
    .TX_start(TX_start),
    .TX_data_in(DATA_in),
    .TX_data_out(tx_data_out),
    .TX_busy(TX_busy)
  );

endmodule