`timescale 1ns/1ps

module testbench;

parameter W = 16;               // datawidth
parameter TWO_POWER_16 = 65536; // two to the power of 16
parameter CYCLE = 10;
reg [W-1:0] x;                  // input data
wire parity_test;               // result from under test unit
reg parity_answer;              // result calculated to be the answer
reg error;                     // record if the test is successful (status=0)
reg ans_tmp;
integer i, j;

// Instantiate the UUT
parity_generator #(.W(W)) uut (
  .a(x),
  .parity(parity_test)
);

// waveform of the simulation for vcd
initial begin
  $dumpfile("testbench.vcd");
  $dumpvars("+mda");
end

// calculate the answer
function automatic  parity_generator_ans(input [W-1:0] a);
  begin
    ans_tmp = 0;
    for (j = 0; j < W; j = j + 1) begin
      ans_tmp = ans_tmp ^ a[j];  // XOR reduction loop
    end
    parity_generator_ans = ans_tmp;
  end
endfunction

// assign data and disply results
initial begin
  error = 0;
  for (i = 0; i < TWO_POWER_16; i = i + 1) begin
    x = i;
    parity_answer = parity_generator_ans(x);
    #CYCLE;
    if (parity_answer !== parity_test) begin
      error = 1;
      $display("Test Failed at x = %b, parity_test = %b, parity_answer = %b", x, parity_test, parity_answer);
      $stop;
    end
  end

  if (error == 0) begin
    $display("Test Successful!");
  end

  $finish;
end

endmodule
