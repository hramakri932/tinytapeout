`default_nettype none
`timescale 1ns / 1ps

module tt_um_sqrt_int #(
    parameter WIDTH = 8  // must be even
)(
    input  wire                 clk,
    input  wire                 ena,      // mandatory enable pin
    input  wire                 rst_n,    //active LOW
    input  wire [WIDTH-1:0]     ui_in,
    output reg  [WIDTH-1:0]   uo_out, 
    output wire [7:0]            uio_oe, 
    output reg [7:0]            uio_out,
    input wire  [7:0]            uio_in
);

    localparam ITER = WIDTH/2;

    // Internal registers
    reg [WIDTH-1:0] remainder;
    reg [WIDTH-1:0] radicand_shift;
    reg [WIDTH/2:0] count;

    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;
    reg state;

    wire rst = ~rst_n | ~ena;
    wire start = uio_in[0];
    wire [7:0] radicand = ui_in;
    assign uio_oe = 8'b0;
    reg busy;

    // Minimal fix: remainder_next and trial as wires
    wire [WIDTH-1:0] remainder_next = {remainder[WIDTH-3:0], radicand_shift[WIDTH-1:WIDTH-2]};
    wire [WIDTH-1:0] trial        = {uo_out[5:0], 2'b01};

    always @(posedge clk) begin
        if (rst) begin
            state          <= IDLE;
            busy           <= 1'b0;
            uio_out        <= 8'b0;
            uo_out         <= 0;
            remainder      <= 0;
            radicand_shift <= 0;
            count          <= 0;
        end else begin

            case (state)

            IDLE: begin
            uio_out <= 0;

                if (start) begin
                    
                    busy           <= 1'b1;
                    uo_out         <= 0;
                    remainder      <= 0;
                    radicand_shift <= radicand;
                    count          <= ITER;  // minimal fix: avoid truncation
                    state          <= RUN;
                end
            end

            RUN: begin
                // Bring down next 2 bits (MSB-first)
                radicand_shift <= {radicand_shift[WIDTH-3:0], 2'b00};

                if (remainder_next >= trial) begin
                    remainder <= remainder_next - trial;
                    uo_out    <= {4'b0, uo_out[WIDTH/2-2:0], 1'b1};
                end else begin
                    remainder <= remainder_next;
                    uo_out    <= {4'b0, uo_out[WIDTH/2-2:0], 1'b0};
                end

                count <= count - 1;

                if (count == 1) begin
                    state <= IDLE;
                    busy  <= 1'b0;
                    uio_out <= 1;
                end
            end

            endcase
        end
    end

endmodule
