`timescale 1ns/1ps
module testbench;

reg  [8:0] a;
wire [4:0] index;
integer i, j;
parameter CYCLE = 10; // period of time

// unit under tested
leading_one uut(
  .a(a),
  .index(index)
);

// dump the waveform of the simulation for vcd
initial begin
  $dumpfile("testbench.vcd");
  $dumpvars("+mda");
end

// function to compute expected result
function [4:0] answer;
  input [8:0] val;
  reg   [4:0] temp_index;
  begin
    temp_index = 5'b11111; // Default situation set to -1   
    for (j = 8; j >= 0; j = j - 1) begin
      if (val[j] == 1'b1 && temp_index == 5'b11111) begin
        temp_index = j;
      end
    end
    answer = temp_index;
  end
endfunction

// Assign test data and display result
initial begin
  $display("Starting test...");
  for (i = 0; i < 512; i = i + 1) begin
    a = i; // Assign test value
    #CYCLE; // Wait for output to stabilize
    if (index !== answer(a)) begin
      $display("Test failed for input %b: expected %d, got %d", a, answer(a), index);
      $stop;
    end
  end
  $display("All tests passed!");
  $finish;
end
endmodule
