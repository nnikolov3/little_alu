/*
Disclaimer: THIS IS A SCHOOL PROJECT.
Nikolay Nikolov
nnikolov@pdx.edu
ALU self-checking testbench
*/
module little_alu_tb;

  // Signals
  reg clk;
  reg reset_p;
  reg start_op;
  reg [15:0] A;
  reg [15:0] B;
  reg [3:0] op_sel;
  wire [31:0] result;
  wire end_op;

  // Instantiate the DUT (ALU)
  little_alu dut (
      .clk(clk),
      .A(A),
      .B(B),
      .reset_p(reset_p),
      .start_op(start_op),
      .end_op(end_op),
      .op_sel(op_sel),
      .result(result)

  );

  initial begin
    // Initialize signals
    clk     = 0;
    reset_p = 1;
    A       = 16'b0;
    B       = 16'b0;
    op_sel  = 3'b000;
    // Release reset_p

    #5 reset_p = 0;

    /////////////////////////////
    // Test NO_OP ///////////////
    /////////////////////////////

    $monitor("A:%h|B:%h|sel:%b|result:%h|end_op:%h", A, B, op_sel, result, end_op);

    #1 $display("Testing NO OP functionality");
    op_sel   = 3'b000;

    start_op = 1;
    #5
    assert (result == 32'b0)
    else $error("NO OP failed: result should be zero");
    start_op = 0;
    think_line();

    /////////////////////////////
    // Test ADD /////////////////
    /////////////////////////////

    // Test #1 5 + 3 = 8
    #10 $display("Testing ADD functionality");
    #10 $display("ADD test #1");

    start_op = 1;
    op_sel = 3'b001;  // ADD
    A = 16'd5;
    B = 16'd3;
    #5
    assert (result == 32'd8)
    else $error("Add failed: result should be 8");
    #10 $display("Expected:%d|Result:%d", 8, result);

    start_op = 0;
    #1 think_line();

    ///////////////////////////
    #1 $display("ADD test #2");

    // Test #2 0+0 = 0

    start_op = 1;
    op_sel = 3'b001;
    A = 16'd0;
    B = 16'd0;
    #5
    assert (result == 32'd0)
    else $error("Add failed: result should");
    #10 $display("Expected:%d|Result:%d", 0, result);

    start_op = 0;

    #1 think_line();

    reset_p = 0;
    /////////////////////////////
    // Test SUB /////////////////
    /////////////////////////////

    #10 $display("Testing SUB functionality");
    #10 $display("Testing only positive integers");
    #10 $display("SUB test #1");

    start_op = 1;
    op_sel = 3'b010;  // SUB
    A = 16'd5;
    B = 16'd3;
    #5
    assert (result == 32'd2)
    else $error("Sub failed: result should");
    #10 $display("Expected:%d|Result:%d", 2, result);
    start_op = 0;
    #1 think_line();

    //////////////////////////////
    #1 $display("SUB test #2");
    op_sel = 3'b010;  // SUB
    A = 16'd9999;
    B = 16'd3;
    start_op = 1;
    #5
    assert (result == 32'd9996)
    else $error("Sub failed: result should");
    #10 $display("Expected:%d|Result:%d", 32'd9996, result);
    start_op = 0;
    #1 think_line();

    reset_p = 0;

    /////////////////////////////
    // Test XOR /////////////////
    /////////////////////////////

    #1 $display("Testing XOR functionality");
    #1 $display("XOR test #1");

    start_op = 1;
    op_sel = 3'b011;
    A = 16'hAAAA;
    B = 16'h5555;
    #5
    assert (result == 32'hFFFF)
    else $error("XOR failed: result should be FFFF");
    #1 $display("Expected:%h|Result:%h", 32'hFFFF, result);

    start_op = 0;
    #1 think_line();
    ///////////////////////////
    #1 $display("XOR test #2");

    start_op = 1;
    op_sel = 3'b011;
    A = 16'hFFFF;
    B = 16'h0000;
    #5
    assert (result == 32'hFFFF)
    else $error("XOR failed: result should be FFFF");
    #1 $display("Expected:%h|Result:%h", 32'hFFFF, result);

    start_op = 0;
    #1 think_line();

    #5 reset_p = 0;
    /////////////////////////////
    // Test MUL /////////////////
    /////////////////////////////

    #10 $display("Testing MUL functionality");
    #10 $display("MUL test #1");

    start_op = 1;
    op_sel = 3'b100;  // mult
    A = 16'd2;
    B = 16'd3;
    #15
    assert (result == 32'd6)
    else $error("Multiply failed: result should be 6");
    #1 $display("Expected:%d|Result:%d", 6, result);

    start_op = 0;  // it takes 3 cycles
    #1 think_line();
    #15;
    ///////////////////////////
    #10 $display("MUL test #2");

    start_op = 1;
    op_sel = 3'b100;  // mult
    A = 16'd20;
    B = 16'd0;
    #15
    assert (result == 32'd0)
    else $error("Multiply failed: result should be 0");
    #10 $display("Expected:%d|Result:%d", 0, result);
    start_op = 0;
    #1 think_line();

    #5 reset_p = 0;

    /////////////////////////////
    // Test AND /////////////////
    /////////////////////////////
    #10 $display("Testing AND functionality");
    #10 $display("AND test #1");

    start_op = 1;
    op_sel = 3'b101;  // Logical AND
    A = 16'hAAAA;
    B = 16'hFFFF;
    #15
    assert (result == 32'hAAAA)
    else $error("AND failed: Result should be 0000");
    #10 $display("Expected:%h|Result:%h", 32'hAAAA, result);
    start_op = 0;
    #1 think_line();

    reset_p = 0;

    ////////////////////////////
    #10 $display("AND test #2");

    start_op = 1;
    op_sel = 3'b101;  // Logical AND
    A = 16'h0000;
    B = 16'hA0A0;
    #15
    assert (result == 32'h0000)
    else $error("AND failed: Result should be h0000");
    #10 $display("Expected:%h|Result:%h", 32'h0000, result);

    start_op = 0;
    #1 think_line();

    reset_p = 0;

    /////////////////////////////
    // Test DISPLAY /////////////
    /////////////////////////////

    #10 $display("Testing 'DISPLAY NAME and ECE593 functionality");
    #10 $display("Testing for 3'b111");

    start_op = 1;
    op_sel = 3'b111;
    A = 16'b0;  // setting it for good practice
    B = 16'b0;  // setting it for good practice
    start_op = 0;
    think_line();
    ////////////////////////////
    #5 reset_p = 0;

    op_sel = 3'b110;
    #10 $display("Testing for 3'b110");

    start_op = 1;
    A = 16'b0;  // setting it for good practice
    B = 16'b0;  // setting it for good practice

    start_op = 0;
    think_line();


    #10 $display("Testbench completed.");
    #10 think_line();
    #10 $finish;

  end

  always #2.5 clk = ~clk;

  task automatic think_line();
    $display("==========================================================");
  endtask

endmodule

