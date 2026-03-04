`default_nettype none
`timescale 1ns / 1ps

module tb ();

  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  reg clk;
  reg rst;     // active HIGH reset
  reg start;

  reg  [7:0] radicand; // Input
  wire [3:0] root; // Result
  wire busy;
  wire done;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  tt_um_sqrt_int #(
      .WIDTH(8)
  ) dut (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .clk      (clk),
      .rst      (rst),      // direct connection
      .start    (start),
      .radicand (radicand),
      .root     (root),
      .busy     (busy),
      .done     (done)
  );

endmodule