`timescale 1ns / 1ps

module fp_add(
    input [31:0] a,
    input [31:0] b,
    output [31:0] res
);
    //Extracting values
    wire sign_a = a[31];
    wire sign_b = b[31];

    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];

    wire [23:0] value_a = {1'b1,a[22:0]};
    wire [23:0] value_b =  {1'b1,b[22:0]};   
    reg [23:0] value_A, value_B;   
    reg [24:0] sum_value;          
    reg sum_sign;
    reg [7:0] sum_power;
    reg [31:0]result;
    integer shift;
    integer i; 
    assign res=result;

    always @(*) begin
        result     = 32'd0;
        value_A    = 0;
        value_B    = 0;
        sum_value  = 0;
        sum_sign   = 0;
        sum_power  = 0;
        
            //Exponent alignment
        if (exp_a >= exp_b) begin
            shift      = exp_a - exp_b;
            value_A    = value_a;
            if(shift<23)value_B    = value_b >> shift;
            else value_B=0;
            sum_power  = exp_a;
        end
        else begin
            shift      = exp_b - exp_a;
            if(shift<23)value_A    = value_a >> shift;
            else value_A=0;
            value_B    = value_b;
            sum_power  = exp_b;
        end
//        addition_or_subtraction
        if (sign_a == sign_b) begin
            sum_value = value_A + value_B;
            sum_sign  = sign_a;
        end
        else begin
            if (value_A >= value_B) begin
                sum_value = value_A - value_B;
                sum_sign  = sign_a;
            end
            else begin
                sum_value = value_B - value_A;
                sum_sign  = sign_b;
            end
        end
        if (sum_value == 0) begin
            result = 32'd0;
        end
        else begin
//            normalization
            if (sum_value[24]) begin
                sum_value = sum_value >> 1;
                sum_power = sum_power + 1;
            end
//            for sum less than 1 case
            else begin
                for (i = 0; i < 23 ; i=i+1) begin
                if(sum_value[23]==0 && sum_power>0)begin
                    sum_value = sum_value << 1;
                    sum_power = sum_power - 1;
                end
                end
            end
            if (sum_power >= 8'hFF) begin//overflow
                sum_power = 8'hFF;
                sum_value = 0;
            end
            result = {sum_sign, sum_power, sum_value[22:0]};
        end
        
    end
endmodule
