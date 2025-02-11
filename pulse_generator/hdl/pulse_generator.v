module pulse_generator(
  input wire clk,
  input wire rst,
  input wire input_signal,
  output reg pulse
);

  // define states
  parameter w1 = 1'b1, w0 = 1'b0;
  reg state, next_state;
  reg next_pulse;

  // finite state machine
  always @(negedge clk or posedge rst) begin
    if (rst) begin
      state <= w1;
      pulse <= 0;
    end else begin
      state <= next_state;
      pulse <= next_pulse;
    end
  end

  // combinational logic
  always @(*) begin
    next_pulse = 0;
    case (state)
      w1: begin
        if (input_signal) begin
          next_state = w0;
          next_pulse = 1;
        end else begin
          next_state = w1; 
          next_pulse = 0;
        end

      end
      w0: begin
        if (!input_signal) begin
          next_state = w1;
          next_pulse = 0;
        end else begin
          next_state = w0;
          next_pulse = 0;
        end
      end
    endcase
  end

endmodule

