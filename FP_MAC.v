`timescale 1ns / 1ps

module FP_MAC(
    input clk,
    input rst,
    input on_state,
    input [1:0] mode_sel,
    input [63:0] A,
    input [63:0] B,
    output reg done,
    output reg [31:0] accum//storing accumulator in fp32 format
);

    wire [31:0] mul_out;
    wire [31:0] add_out;

    reg [31:0] mul_reg; 
    reg mul_done;
   
//multiplier instance
    fp_mul u_mul(
        .A(A),
        .B(B),
        .mode(mode_sel),
        .P(mul_out)
    );

//    adder instance
    fp_add u_add(
        .a(accum),
        .b(mul_reg),
        .res(add_out)
    );
//architecture  input - multiplier(comb) - mul_reg(register) - adder(comb) - accum register(register)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'd0;
            mul_reg <= 32'd0;
            mul_done <= 0;
            done <= 0;
        end else begin
            done <= 0;

            // Stage 1: Multiplication result in fp32
            if (on_state) begin
                mul_reg <= mul_out;
                mul_done <= 1;
            end else begin
                mul_done <= 0;
            end

           // Stage 2: Accumulation
            if (mul_done) begin
                accum <= add_out;
                done <= 1;
            end
        end
    end

endmodule
