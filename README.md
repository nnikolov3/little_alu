# little_alu

**Description of DUT:**

_Note: I used ChatGPT to write the description based on my own source code. I used my own resources
to research and write the code. I got some inspiration from various sources, but the source is all
written by me, including the testbench. Using the source code and ChatGPT  I generated the design
description. This is educational project based on best effort. No guarantees. It is intended for educational purposes only._

**Inputs and Outputs**

**Inputs:**

- A and B: Two 16-bit data buses serving as the operands for ALU operations.
- op_sel: A 4-bit signal that selects the operation to be performed by the ALU.
- clk: A clock signal used for synchronization.
- reset_p: An active-high synchronous reset signal to initialize the ALU to its idle state.
- start_op: A control signal that triggers the ALU to begin an operation.

**Outputs:**

- result: A 32-bit result bus where the output of the selected operation is stored.
- end_op: A signal that indicates the completion of the currently selected operation.


**Operational Modes**
The ALU supports a range of operations, determined by the op_sel input:
**3'b000: No Operation (NO_OP)**
- The result is set to zero, and no computation is performed.

**3'b001: Addition (ADD)**
- Computes result = A + B in a single clock cycle.

**3'b010: Subtraction (SUB)**
- Computes result = A - B in a single clock cycle.

**3'b011: Bitwise XOR (XOR)**
- Computes result = A ^ B in a single clock cycle.

**3'b100: Multiplication (MUL)**
- Computes result = A * B over three clock cycles using a state machine.

**3'b101: Bitwise AND (AND)**
- Computes result = A & B in a single clock cycle.

**3'b110 and 3'b111: Display Operation**
- These operations output a predefined message ("Niko") to the console using $display. The result remains unchanged (set to zero).

**Design Highlights**

**1. Finite State Machine (FSM)**

The ALU uses a finite state machine (FSM) to control the flow of operations, especially for multi-cycle
operations like multiplication.

**The FSM operates in the following states:**

- **IDLE:** Default state; the ALU awaits the start_op signal. No operations are performed.
- **SINGLE_CYCLE:** Handles single-cycle operations such as addition, subtraction, XOR, and
AND.
- **CYCLE_1, CYCLE_2, CYCLE_3:** Sequential states for completing the three cycles
required by the multiplication operation.


**2. Multiplication Implementation**

The multiplication operation (MUL) is broken into three cycles:
- **CYCLE_1** : Prepares for multiplication.
- **CYCLE_2:** Executes an intermediate step.
- **CYCLE_3** : Finalizes the operation and sets result.

A flag (mul_ready) is used to signal the readiness of the multiplication result.

**3. Synchronous Reset**
The ALU supports an active-high synchronous reset (reset_p) that initializes the FSM to the IDLE
state on the rising edge of the clock signal (clk).


**4. Single-Cycle Operations**
Simple operations such as addition, subtraction, XOR, and AND are executed in one clock cycle
when op_sel is appropriately set.

**5. Output Display**
For op_sel = 3'b110 or 3'b111, the ALU outputs a hardcoded message ("Niko ")
using the $display system task. These operations do not modify the result value.

**Combinational and Sequential Logic**
**Combinational Logic:**

- Determines the next_state of the FSM based on the current state (current_state), input signals (op_sel, start_op), and control flags.
- Performs arithmetic and logical operations as specified by op_sel.
- Updates the result and end_op signals accordingly.

**Sequential Logic:**

- Updates the current_state on the rising edge of the clock (clk) based on the computed
    next_state.
- Responds to the reset_p signal by reinitializing the FSM to the IDLE state.

**Strengths of the Design**
- **Efficient Single-Cycle Operation:** Most operations are completed in a single clock cycle,
ensuring low latency for common tasks.
- **Multi-Cycle Support:** The FSM accommodates complex operations (like multiplication) with
multiple clock cycles, improving scalability.
- **Synchronous Design:** Adheres to best practices for synchronous hardware design, ensuring
predictable and stable operation.
- **Debugging and Visibility:** The $display statements provide an additional mechanism for
verifying functionality and operation during simulation.


**Weaknesses or Considerations**

- Multiplication Implementation: The current design assumes direct computation of A * B in
    three cycles without explicitly handling intermediate partial products. For hardware-level
    optimization, a more detailed implementation could involve iterative or pipeline-based
    multipliers.

- Display Operations: The functionality for op_sel = 3'b110 and 3'b111 could be expanded to
    provide additional context or user-defined outputs.

- Resource Utilization: Additional combinational and sequential resources might be required
    for scaling the design to wider data buses or more complex operations.

**Summary of Operation Cycle Requirements**

- Single-Cycle Operations (ADD, SUB, XOR, AND): Completed in 1 clock cycle.
- No Operation (NO_OP): Completed in 1 clock cycle.
- Multiplication (MUL): Requires 3 clock cycles.
- Display Operations (3'b110, 3'b111): Completed in 1 clock cycle.


**How to test the source code**
I have included in the folder QuestaSim manual, chapter 1, Basic Steps for Simulation covers the steps.
**Example:
```
vlib work
vmap work work
vlog -reportprogress 300 -work work ./*.sv
vsim small_alu_tb**
```



