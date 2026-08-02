`timescale 1ns / 1ps

module cla_tb;

    reg [4:0] A_in;
    reg [4:0] B_in;
    reg Cin;
    reg clk;
    reg rst;

    wire [4:0] Sum_out;
    wire Cout_out;

    cla_adder_top uut (
        .Sum_out(Sum_out), 
        .Cout_out(Cout_out), 
        .A_in(A_in), 
        .B_in(B_in), 
        .Cin(Cin),
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cla_waveforms.vcd");
        $dumpvars(0, cla_tb);

        $monitor("time=%t | In: A=%d B=%d | Out: Sum=%d Cout=%b", $time, A_in, B_in, Sum_out, Cout_out);

        clk = 0; rst = 0;
        A_in = 0; B_in = 0; Cin = 0;
        #10;

        rst = 1;
        #10;

        @(posedge clk);
        A_in = 5'd10; B_in = 5'd5; Cin = 0;
        
        @(posedge clk);
        A_in = 5'd15; B_in = 5'd15; Cin = 0;

        @(posedge clk);
        A_in = 5'd31; B_in = 5'd1; Cin = 0;

        @(posedge clk);
        A_in = 0; B_in = 0;
        @(posedge clk);
        @(posedge clk);
        
        $finish;
    end
endmodule