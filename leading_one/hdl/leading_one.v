module leading_one (
    input wire [8:0] a,       // 9-bit input
    output reg [4:0] index    // 5-bit output (to represent -1 to 8)
);

always @(*) begin
    if (a[8] == 1'b1) begin
        index = 5'd8;
    end else if (a[7] == 1'b1) begin
        index = 5'd7;
    end else if (a[6] == 1'b1) begin
        index = 5'd6;
    end else if (a[5] == 1'b1) begin
        index = 5'd5;
    end else if (a[4] == 1'b1) begin
        index = 5'd4;
    end else if (a[3] == 1'b1) begin
        index = 5'd3;
    end else if (a[2] == 1'b1) begin
        index = 5'd2;
    end else if (a[1] == 1'b1) begin
        index = 5'd1;
    end else if (a[0] == 1'b1) begin
        index = 5'd0;
    end else begin
        index = 5'b11111;     // Represents -1 in 5-bit signed format
    end
end

endmodule
