module parity_generator #(parameter W = 16) (
  input  wire [W-1:0] a,   // 16-bit input
  output wire parity       // Parity bit output
);

assign parity = ^a;  // XOR reduction to compute parity

endmodule

