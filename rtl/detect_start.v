module detect_start (
  input rx_in,
  output start_bit_detected
);

  assign start_bit_detected = ~rx_in;

endmodule



