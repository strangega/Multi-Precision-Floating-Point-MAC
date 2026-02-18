`timescale 1ns / 1ps

module FP_MAC_tb;

    reg clk;
    reg rst;
    reg on_state;
    reg [1:0] mode_sel;
    reg [63:0] A;
    reg [63:0] B;

    wire done;
    wire [31:0] accum;

    FP_MAC DUT (
        .clk(clk),
        .rst(rst),
        .on_state(on_state),
        .mode_sel(mode_sel),
        .A(A),
        .B(B),
        .done(done),
        .accum(accum)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        on_state = 0;

        #100;
        rst = 0;
        // FP32 TEST
        mode_sel = 2'b10;   // FP32
        A = 64'h0000000040A00000;  // 5.0 
        B = 64'h0000000040400000;  // 3.0

        #20; on_state = 1;
        #20; on_state = 0;

        wait(done);
        #20;
           
        // FP16 TEST (1.0 * 2.0)
       
        mode_sel = 2'b01;   // FP16
        A = 64'h0000000000003C00;  // 1.0 FP16
        B = 64'h0000000000004000;  // 2.0 FP16

        #20; on_state = 1;
        #20; on_state = 0;

        wait(done);
        #20;

        // BF16 TEST (1.0 * 2.0)
    
        mode_sel = 2'b00;   // BF16
        A = 64'h0000000000003F80;  // 1.0 BF16
        B = 64'h0000000000004000;  // 2.0 BF16

        #20; on_state = 1;
        #20; on_state = 0;

        wait(done);
        #20;
        
        // FP64 TEST (2.0 * 3.0)

        mode_sel = 2'b11;   // FP64
        A = 64'h4000000000000000;  // 2.0 FP64
        B = 64'h4008000000000000;  // 3.0 FP64

        #20; on_state = 1;
        #20; on_state = 0;

        wait(done);
        #20;
        

        #50;
        $finish;
    end

endmodule
