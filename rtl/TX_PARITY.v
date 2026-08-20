module TX_PARITY (
  input clk,
  input rst,
  input parity_load,
  input [7:0] parity_data_in,
  output reg parity_out
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      parity_out <= 0;
    else begin
      if (parity_load)
        parity_out <= ^parity_data_in;
    end
  end

endmodule