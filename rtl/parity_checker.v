module parity_checker (
  input parity_in,
  input [7:0] data_in,
  input parity_load,
  output parity_error,
  output [7:0] data_out
);

  assign parity_error = parity_load && (parity_in != (^data_in));
  assign data_out = parity_error ? 8'h00 : data_in;

endmodule