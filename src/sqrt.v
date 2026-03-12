`default_nettype none
`timescale 1ns / 1ps

module tt_um_sqrt_int (
    input  wire       clk,
    input  wire       ena,
    input  wire       rst_n,
    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,
    output wire [7:0] uio_oe,
    output wire [7:0] uio_out,
    input  wire [7:0] uio_in
);

    assign uio_oe  = 8'b0;
    assign uio_out = {7'b0,state};

    localparam ITER = 4;

    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state;

    reg [7:0] radicand;
    reg [7:0] remainder;
    reg [2:0] count;

    // combine enable and reset into one reset signal
    wire rst = ~rst_n | ~ena;

    // detect rst_n rising edge (start signal)
    reg rst_n_d;
    always @(posedge clk)
        rst_n_d <= rst_n;

    wire start = rst_n & ~rst_n_d;

    wire [7:0] trial    = (uo_out << 2) | 8'b1;
    wire [7:0] rem_next = {remainder[5:0], radicand[7:6]};

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            uo_out    <= 0;
            remainder <= 0;
            radicand  <= 0;
            count     <= 0;
        end
        else begin
            case (state)

            IDLE: begin
                if (start) begin
                    radicand  <= ui_in;
                    remainder <= 0;
                    uo_out    <= 0;
                    count     <= ITER;
                    state     <= RUN;
                end
            end

            RUN: begin
                radicand <= {radicand[5:0], 2'b00};

                if (rem_next >= trial) begin
                    remainder <= rem_next - trial;
                    uo_out    <= (uo_out << 1) | 8'b1;
                end
                else begin
                    remainder <= rem_next;
                    uo_out    <= (uo_out << 1);
                end

                count <= count - 1;

                if (count == 1)
                    state <= IDLE;
            end

            endcase
        end
    end

endmodule