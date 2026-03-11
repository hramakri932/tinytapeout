`default_nettype none
`timescale 1ns / 1ps

module tt_um_sqrt_int #(
    parameter WIDTH = 8  // must be even
)(
    input  wire                 clk,
    input  wire                 ena,      // mandatory enable pin
    input  wire                 rst_n,    //active LOW
    input  wire                 start,
    input  wire [WIDTH-1:0]     ui_in,
    output reg  [WIDTH/2-1:0]   uo_out, 
    output reg                  busy,
    output reg                  done,
    output wire [7:0]            uio_oe, // remaining unused
    output wire [7:0]            uio_out,
    input wire  [7:0]            uio_in
);

    localparam ITER = WIDTH/2;

    // Internal registers
    reg [WIDTH-1:0] remainder;
    reg [WIDTH-1:0] radicand_shift;
    reg [$clog2(ITER+1)-1:0] count;

    reg [WIDTH-1:0] remainder_next;
    reg [WIDTH-1:0] trial;

    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;
    reg state;

    wire rst = ~rst_n | ~ena;
    assign uio_oe = 8'b0;
    assign uio_out = 8'b0;
    wire [7:0] radicand = ui_in;
    reg [WIDTH/2-1:0] root;
    always @(*) begin
    uo_out = root;
    end

    always @(posedge clk) begin
        if (rst) begin
            state          <= IDLE;
            busy           <= 1'b0;
            done           <= 1'b0;
            root           <= 0;
            remainder      <= 0;
            radicand_shift <= 0;
            count          <= 0;
        end else begin

            case (state)

            IDLE: begin
                done <= 1'b0;

                if (start) begin
                    busy           <= 1'b1;
                    root           <= 0;
                    remainder      <= 0;
                    radicand_shift <= radicand;
                    count          <= ITER;
                    state          <= RUN;
                end
            end

            RUN: begin
                // Bring down next 2 bits (MSB-first)
                remainder_next = {remainder[WIDTH-3:0], radicand_shift[WIDTH-1:WIDTH-2]};
                radicand_shift <= {radicand_shift[WIDTH-3:0], 2'b00};

                // trial = (root << 2) | 1
                trial = ({root, 2'b1});

                if (remainder_next >= trial) begin
                    remainder <= remainder_next - trial;
                    root      <= {root[WIDTH/2-2:0], 1'b1};
                end else begin
                    remainder <= remainder_next;
                    root      <= {root[WIDTH/2-2:0], 1'b0};
                end

                count <= count - 1;

                if (count == 1) begin
                    state <= IDLE;
                    busy  <= 1'b0;
                    done  <= 1'b1;
                end
            end

            endcase
        end
    end

endmodule