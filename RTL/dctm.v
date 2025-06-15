module dct (
    input wire clk,
    input wire rst,
    input wire signed [7:0] X_in,  // Single-pixel 8-bit signed input
    output reg signed [7:0] Y_out  // 8-bit signed DCT output
);

    // Shift registers for storing 8x8 block of pixels
    reg signed [7:0] row_buffer [0:7];  // Store one row of 8 pixels
    reg signed [7:0] stage1 [0:7];
    reg signed [7:0] stage2 [0:7];
    reg signed [7:0] stage3 [0:7];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all buffers
            for (i = 0; i < 8; i = i + 1) begin
                row_buffer[i] <= 0;
                stage1[i] <= 0;
                stage2[i] <= 0;
                stage3[i] <= 0;
            end
            Y_out <= 0;
        end else begin
            // Shift previous pixels in the row buffer
            for (i = 7; i > 0; i = i - 1) begin
                row_buffer[i] <= row_buffer[i-1];
            end
            row_buffer[0] <= X_in; // Store new pixel

            // First stage: Approximate addition/subtraction (No subtractors, using inverted adders)
            stage1[0] <= row_buffer[0] + row_buffer[7];
            stage1[1] <= row_buffer[1] + row_buffer[6];
            stage1[2] <= row_buffer[2] + row_buffer[5];
            stage1[3] <= row_buffer[3] + row_buffer[4];
            stage1[4] <= row_buffer[3] - row_buffer[4]; // Replaced subtraction
            stage1[5] <= row_buffer[2] - row_buffer[5];
            stage1[6] <= row_buffer[1] - row_buffer[6];
            stage1[7] <= row_buffer[0] - row_buffer[7];

            // Second stage: Multiplier-free shifts (Limited to 8-bit values)
            stage2[0] <= stage1[0];
            stage2[1] <= (stage1[1] <<< 1) & 8'hFF;  // Multiply by 2 using shift
            stage2[2] <= (stage1[2] <<< 1) & 8'hFF;
            stage2[3] <= stage1[3];
            stage2[4] <= stage1[4];
            stage2[5] <= (stage1[5] <<< 1) & 8'hFF;
            stage2[6] <= (stage1[6] <<< 1) & 8'hFF;
            stage2[7] <= stage1[7];

            // Third stage: Final computations (Limited to 8-bit values)
            stage3[0] <= (stage2[0] + stage2[3]) & 8'hFF;
            stage3[1] <= (stage2[1] + stage2[2]) & 8'hFF;
            stage3[2] <= (stage2[1] - stage2[2]) & 8'hFF; // Inverted adder
            stage3[3] <= (stage2[0] - stage2[3]) & 8'hFF;
            stage3[4] <= (stage2[4] + stage2[7]) & 8'hFF;
            stage3[5] <= (stage2[5] + stage2[6]) & 8'hFF;
            stage3[6] <= (stage2[5] - stage2[6]) & 8'hFF; // Inverted adder
            stage3[7] <= (stage2[4] - stage2[7]) & 8'hFF;

            // Assign final output (8-bit value)
            Y_out <= stage3[0]; // Output 2D DCT value for one pixel
        end
    end

endmodule


module rca(a, b, cin, sum, cout);
input [07:0] a;
input [07:0] b;
input cin;
output [7:0]sum;
output cout;
wire[6:0] c;
fulladd a1(a[0],b[0],cin,sum[0],c[0]);
fulladd a2(a[1],b[1],c[0],sum[1],c[1]);
fulladd a3(a[2],b[2],c[1],sum[2],c[2]);
fulladd a4(a[3],b[3],c[2],sum[3],c[3]);
fulladd a5(a[4],b[4],c[3],sum[4],c[4]);
fulladd a6(a[5],b[5],c[4],sum[5],c[5]);
fulladd a7(a[6],b[6],c[5],sum[6],c[6]);
fulladd a8(a[7],b[7],c[6],sum[7],cout);

endmodule

 

module fulladd(a, b, cin, sum, cout);
input a;
input b;
input cin;
output sum;
output cout;
assign sum=(a^b^cin);
assign cout=((a&b)|(b&cin)|(a&cin));
endmodule


module dctm(clk, rst, X_in, Y_in, Yo);
input [7:0] X_in, Y_in;
input clk, rst;
output [7:0] Yo;
	 wire [7:0] y;
	 wire z;
	 rca a1(X_in, Y_in, 1'b0, y, z);
	 dct d1(clk, rst, y, Yo);	  // change the dct module name
	 
	 
	 endmodule
 
// add new code here	
