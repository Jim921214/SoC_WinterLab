`timescale 1ns/1ps

module testbench;

  // input signal  
  reg clk;
  reg rst;
  reg input_signal;

  // output signal  
  wire pulse;

  // testing variables  
  reg expected_pulse;
  integer i, errors;

  // parameter defined
  parameter CYCLE = 10; // clock period 

  // Instantiate the pulse generator module
  pulse_generator uut (
    .clk(clk),
    .rst(rst),
    .input_signal(input_signal),
    .pulse(pulse)
  );

  // dump the waveform for vcd
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars("+mda");
  end

  // Clock generation
  always #(CYCLE/2) clk = ~clk; // 10 ns period (100 MHz clock)

  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    input_signal = 0;
    errors = 0;
    #(CYCLE) rst = 0; // Deassert reset after 10 ns

    // Test sequence with expected values
    $display("pulse =");
    for (i = 0; i < 5; i = i + 1) begin
      input_signal = 0;
      expected_pulse = 0;
      #(CYCLE/2);
      check_output();
      #(CYCLE/2);
    end

    for (i = 0; i < 5; i = i + 1) begin
      input_signal = 1;
      expected_pulse = (i == 0) ? 1 : 0;
      #(CYCLE/2);
      check_output();
      #(CYCLE/2);
    end

    for (i = 0; i < 5; i = i + 1) begin
      input_signal = 0;
      expected_pulse = 0;
      #(CYCLE/2);
      check_output();
      #(CYCLE/2);
    end

    if (errors == 0) begin
      $display("\nTest passed successfully");
    end else begin
      $display("\nTest failed with %d errors", errors);
    end
    $stop;
  
  end
  
  // checking if pulse is the same as expected
  task check_output;
    begin
      $write(" %b", pulse);
      if (pulse !== expected_pulse) begin
        $display("\nError: Expected %b, got %b at time %t", expected_pulse, pulse, $time);
        errors = errors + 1;
      end
    end
  endtask

endmodule

