`timescale 1ns / 1ps

module d_flip_flop (
    output reg Q,
    input D,
    input clk,
    input rst
);
    always @(posedge clk or negedge rst) begin
        if (!rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule

module cla_logic (
    output [4:0] Sum,
    output Cout,
    input [4:0] A,
    input [4:0] B,
    input Cin
);
    wire [4:0] P, G;
    wire [5:0] C;

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign Sum = P ^ C[4:0];
    assign Cout = C[5];

endmodule

module cla_adder_top (
    output [15:0] led,
    input [15:0] sw,
    input [3:0] btn,
    input clk
);

    wire [4:0] A_in = sw[4:0];
    wire [4:0] B_in = sw[9:5];
    wire Cin_in = sw[10];
    
    assign led[15:6] = 10'b0;
    
    wire rst_n = ~btn[0]; 

    wire [4:0] Sum_out;
    wire Cout_out;
    wire [4:0] A_reg, B_reg;
    wire [4:0] Sum_comb;
    wire Cout_comb;

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : input_stage
            d_flip_flop ff_a (.Q(A_reg[i]), .D(A_in[i]), .clk(clk), .rst(rst_n)); 
            d_flip_flop ff_b (.Q(B_reg[i]), .D(B_in[i]), .clk(clk), .rst(rst_n));
        end
    endgenerate

    cla_logic adder_core (
        .Sum(Sum_comb),
        .Cout(Cout_comb),
        .A(A_reg),
        .B(B_reg),
        .Cin(Cin_in)
    );

    generate
        for (i = 0; i < 5; i = i + 1) begin : output_sum_stage
            d_flip_flop ff_sum (.Q(Sum_out[i]), .D(Sum_comb[i]), .clk(clk), .rst(rst_n));
        end
    endgenerate
    d_flip_flop ff_cout (.Q(Cout_out), .D(Cout_comb), .clk(clk), .rst(rst_n));

    assign led[4:0] = Sum_out;
    assign led[5] = Cout_out;

endmodule