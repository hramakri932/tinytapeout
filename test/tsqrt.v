// `default_nettype none
// `timescale 1ns / 1ps

// module tb ();

//   initial begin
//     $dumpfile("tb.fst");
//     $dumpvars(0, tb);
//     #1;
//   end

  

// `ifdef GL_TEST
//   wire VPWR = 1'b1;
//   wire VGND = 1'b0;
// `endif

//   tt_um_sqrt_int #(
//       .WIDTH(8)
//   ) dut (

// `ifdef GL_TEST
//       .VPWR(VPWR),
//       .VGND(VGND),
// `endif

//       .clk      (clk), //clk
//       .rst_n    (rst_n), //rst
//       .start    (start), //start
//       .radicand (radicand), //radicand
//       .root     (root), //root
//       .busy     (busy),//busy
//       .done     (done)//done
      
//   );

// endmodule