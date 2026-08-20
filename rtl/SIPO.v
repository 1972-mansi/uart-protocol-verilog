module SIPO (clk, rst, rx_in, sample_done, run_shift, data_out);
  input clk;
  input rst;
  input rx_in;
  input sample_done;
  input run_shift;

  output [9:0] data_out;

  reg [9:0] temp;

  always @(posedge clk or posedge rst) begin
    if (rst)
      temp <= 0;
    else begin
      if (run_shift)
        temp <= {rx_in, temp[9:1]};
    end
  end

  assign data_out = temp;

endmodule