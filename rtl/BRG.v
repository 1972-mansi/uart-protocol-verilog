module BRG (clk_in, rst, clk_rx, clk_tx);

  parameter n = 50;

  input clk_in;
  input rst;

  output reg clk_rx;
  output reg clk_tx;

  reg [11:0] count;
  reg [4:0] count1;

  always @(posedge clk_in or posedge rst) begin
    if (rst) begin
      count <= 0;
      clk_rx <= 0;
    end
    else begin
      if (count == n-1)
        count <= 0;
      else
        count <= count + 1;

      if (count == 0)
        clk_rx <= 1;
      else if (count == n/2)
        clk_rx <= 0;
    end
  end

  always @(posedge clk_rx or posedge rst) begin
    if (rst) begin
      count1 <= 0;
      clk_tx <= 0;
    end
    else begin
      if (count1 == 15)
        count1 <= 0;
      else
        count1 <= count1 + 1;

      if (count1 == 0)
        clk_tx <= 1;
      else if (count1 == 8)
        clk_tx <= 0;
    end
  end

endmodule