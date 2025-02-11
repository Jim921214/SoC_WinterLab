`timescale 1ns / 1ps

module testbench;
  
  parameter DATA_WIDTH = 16;
  parameter N = 8;
  parameter CYCLE = 10; // Clock period in ns
  
  // Test Inputs and Outputs
  reg clk, rst;
  reg signed [DATA_WIDTH-1:0] x [0:N-1];
  reg signed [DATA_WIDTH-1:0] y_golden [0:N-1];
  wire signed [DATA_WIDTH-1:0] y_hw;
  
  integer i;
  reg signed [DATA_WIDTH-1:0] y_hw_array [0:N-1];
  reg status;
  
  // Instantiate IIR filter module
  iir_filter uut (
    .clk(clk),
    .rst(rst),
    .x(x[i]),
    .y(y_hw)
  );
  
  // Dump the waveform of the simulation for VCD
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars("+mda");
  end  
  
  // IIR Golden Reference Model (Software Equivalent)
  task iir_golden;
    input signed [DATA_WIDTH-1:0] x_in;
    output reg signed [DATA_WIDTH-1:0] y_out;
    reg signed [DATA_WIDTH-1:0] y_tmp [0:N-1];
    integer j;  
    // define parameters 
    parameter signed [DATA_WIDTH-1:0] a1 = 16'd4;
    parameter signed [DATA_WIDTH-1:0] a2 = 16'd3;
    parameter signed [DATA_WIDTH-1:0] b0 = 16'd6;
    parameter signed [DATA_WIDTH-1:0] b1 = 16'd1;
    parameter signed [DATA_WIDTH-1:0] b2 = 16'd2;
    
    begin
      y_tmp[0] = b0 * x[0];
      y_tmp[1] = b0 * x[1] + b1 * x[0] - a1 * y_tmp[0];
      for (j = 2; j < N; j = j + 1) begin
        y_tmp[j] = b0 * x[j] + b1 * x[j-1] + b2 * x[j-2] - a1 * y_tmp[j-1] - a2 * y_tmp[j-2];
      end
      y_out = y_tmp[i];
    end
  endtask
  
  // Clock Generation
  always #(CYCLE/2) clk = ~clk;
  
  // Test Procedure
  initial begin
    clk = 0;
    rst = 1;
    status = 0;
  // Input signal array
    x[0] = 1; x[1] = 2; x[2] = 3; x[3] = 4;
    x[4] = 5; x[5] = 6; x[6] = 7; x[7] = 8;
    
  // Reset system
  #CYCLE rst = 0;
  
  // Compute golden reference output
  for (i = 0; i < N; i = i + 1) begin
    iir_golden(x[i], y_golden[i]);
  end
  
  // Process input through hardware filter
  for (i = 0; i < N; i = i + 1) begin
    #(CYCLE/2) y_hw_array[i] = y_hw;
    $display("y_hw[%1d] = %1d", i, y_hw_array[i]);
    #(CYCLE/2);
  end
  
  // Compare results
  for (i = 0; i < N; i = i + 1) begin
    if (y_hw_array[i] !== y_golden[i]) begin
      status = 1;
      $display("Error at %1d: y_hw = %1d, y_golden = %1d", i, y_hw_array[i], y_golden[i]);
    end
  end
  
  if (status == 0)
    $display("Test Passed!");
  else
    $display("Test Failed!");
  
  $stop;
  end
  
endmodule

