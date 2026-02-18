`timescale 1ns / 1ps
module fp_mul(
    input  [63:0] A,
    input  [63:0] B,
    input  [1:0]  mode,
    output [31:0] P
);

    reg sign;
    reg [10:0] exp_a, exp_b, exp_res;
    reg [52:0] man_a, man_b;
    reg [105:0] man_res;
    reg [22:0]final_man;
    

    integer bias;

    always @(*) begin
        case(mode)
            2'b00:begin//BF16
                    bias = 127;
                    sign = A[15] ^ B[15];
                    exp_a = A[14:7];
                    exp_b = B[14:7];
                    man_a = {1'b1, A[6:0]};//7bits
                    man_b = {1'b1, B[6:0]};
                  end
            2'b01: begin // FP16
                bias = 15;
                sign = A[15] ^ B[15];
                exp_a = A[14:10];
                exp_b = B[14:10];
                man_a = {1'b1, A[9:0]};//11bits
                man_b = {1'b1, B[9:0]};
            end

            2'b10: begin // FP32
                bias = 127;
                sign = A[31] ^ B[31];
                exp_a = A[30:23];
                exp_b = B[30:23];
                man_a = {1'b1, A[22:0]};//24 bits
                man_b = {1'b1, B[22:0]};
            end

            2'b11: begin // FP64
                bias = 1023;
                sign = A[63] ^ B[63];
                exp_a = A[62:52];
                exp_b = B[62:52];
                man_a = {1'b1, A[51:0]};//53 bits
                man_b = {1'b1, B[51:0]};
            end
            
        endcase

        man_res = man_a * man_b;
        exp_res = exp_a + exp_b -2* bias+127;
        case(mode)
             2'b00: begin // BF16
                 if (man_res[15]) begin
                    final_man={man_res[14:0],8'd0};
                    exp_res = exp_res + 1;
                end
                else begin
                    final_man={man_res[13:0],9'd0};
                end
                
            end
            2'b01: begin // FP16
                 if (man_res[21]) begin
                    final_man={man_res[20:0],2'd0};
                    exp_res = exp_res + 1;
                end
                else begin
                    final_man={man_res[19:0],3'd0};
                end
                
            end

            2'b10: begin // FP32
                if (man_res[47]) begin
                    final_man=man_res[46:24];
                    exp_res = exp_res + 1;
                end
                else begin
                    final_man=man_res[45:23];
                end
            end

            2'b11: begin // FP64
                if (man_res[105]) begin
                    final_man=man_res[104:82];
                    exp_res=exp_res+1;
                end
                else begin
                    final_man=man_res[103:81];
                end
            end
        endcase
        
    end

    assign P = {sign, exp_res[7:0], final_man};

endmodule
