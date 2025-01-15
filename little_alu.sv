
/*
Disclaimer: THIS IS A SCHOOL PROJECT.
Nikolay Nikolov
nnikolov@pdx.edu
[x] ALU has six inputs and two outputs.
[x] A and B are input data bus each 16-bits wide and result bus is 32-bits wide.
[x] Reset signal rst is active high, synchronous reset.
[x] Data from A and B and op_sel are read into ALU, only with the signal start_op is active
[x] All operations are performed at the posedge of the clk.
[x] All operations are single cycle, except multiplication (mul) which takes 3 cycles

Operations:
3'b000: no_op;
3'b001: add;
3'b010: sub;
3'b011: xor;
3'b100: mul;
3'b101: and;
3'b110, 3'b111: display (display your name)
*/

module ece593_alu (
    clk,
    A,
    B,
    reset_p,
    start_op,
    end_op,
    op_sel,
    result
);
  // inputs
  input logic [15:0] A, B;
  input logic reset_p, clk, start_op;
  input logic [3:0] op_sel;
  // outputs
  output logic [31:0] result;
  output logic end_op;

  parameter logic [2:0] NO_OP = 3'b000,
                        ADD = 3'b001,
                        SUB = 3'b010,
                        XOR = 3'b011,
                        MUL = 3'b100,
                        AND = 3'b101;


  typedef enum logic [2:0] {
    IDLE = 3'b000,
    SINGLE_CYCLE = 3'b001,
    CYCLE_1 = 3'b011,
    CYCLE_2 = 3'b110,
    CYCLE_3 = 3'b111
  } state_t;

  logic mul_ready;
  state_t current_state, next_state;

  always_ff @(posedge clk) begin
    if (reset_p) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  ////////////////////////////////
  /// Combinational Logic ///////
  ////////////////////////////////
  always_comb begin

    if (start_op) begin
      if (op_sel == MUL) begin
        case (current_state)
          CYCLE_1: begin
            next_state = CYCLE_2;
          end
          CYCLE_2: begin
            next_state = CYCLE_3;
          end
          CYCLE_3: begin
            mul_ready  = 1;
            next_state = IDLE;
          end
          default: next_state = IDLE;
        endcase
      end
    end

    case (current_state)
      IDLE: begin
        end_op = 0;
        mul_ready = 1'b0;

        if (start_op) begin
          next_state = SINGLE_CYCLE;
        end else begin
          next_state = IDLE;
        end
      end


      SINGLE_CYCLE: begin

        case (op_sel)
          ////////////////////////////////
          NO_OP: begin
            result = 32'b0;
            end_op = 1'b1;
          end

          ////////////////////////////////
          ADD: begin
            result = A + B;
            end_op = 1'b1;
          end

          ////////////////////////////////
          SUB: begin
            result = A - B;
            end_op = 1'b1;
          end

          ////////////////////////////////
          XOR: begin
            result = A ^ B;
            end_op = 1'b1;
          end

          ////////////////////////////////
          AND: begin
            result = A & B;
            end_op = 1'b1;
          end

          /////////////////////////////// #5 reset_p = 0;/
          MUL: begin
            next_state = CYCLE_1;
            result = A * B;
            end_op = 1'b1;
          end

          ////////////////////////////////
          3'b110: begin
            result = 32'b0;
            $display("My name is %s", "Niko");
            end_op = 1'b1;
          end

          ////////////////////////////////
          3'b111: begin
            result = 32'b0;
            $display("My name is %s", "Niko");
            end_op = 1'b1;  // Single cycle
          end
          default: result = 32'b0;
        endcase
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

endmodule
