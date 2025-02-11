module iir_filter #(parameter DATA_WIDTH = 16) (
  input clk,
  input rst,
  input signed [DATA_WIDTH-1:0] x,
  output reg signed [DATA_WIDTH-1:0] y
);
  // wire signed [DATA_WIDTH-1:0] y_next;
  
  // define parameters 
  parameter signed [DATA_WIDTH-1:0] a1 = 16'd4;
  parameter signed [DATA_WIDTH-1:0] a2 = 16'd3;
  parameter signed [DATA_WIDTH-1:0] b0 = 16'd6;
  parameter signed [DATA_WIDTH-1:0] b1 = 16'd1;
  parameter signed [DATA_WIDTH-1:0] b2 = 16'd2;
  
  // states
  reg signed [DATA_WIDTH-1:0] xn1, xn2;
  reg signed [DATA_WIDTH-1:0] yn1, yn2;

  // Sequential logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      xn1 <= {DATA_WIDTH{1'b0}};
      xn2 <= {DATA_WIDTH{1'b0}};
      yn1 <= {DATA_WIDTH{1'b0}};
      yn2 <= {DATA_WIDTH{1'b0}};
    end else begin
      xn2 <= xn1;     // update state 
      xn1 <= x;
      yn2 <= yn1;
      yn1 <= y;
    end
  end

  // Combinational logic
  always @* begin
    if (!rst) y = (b0 * x) + (b1 * xn1) + (b2 * xn2) - (a1 * yn1) - (a2 * yn2);
    else y = 0;
  end
endmodule

