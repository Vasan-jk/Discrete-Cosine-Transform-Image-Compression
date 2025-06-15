module test;
parameter n=65536;
// Inputs
reg [7:0] a;
reg [7:0] b;
reg clk, rst;
reg [7:0] data [0:n];
reg [7:0] data1 [0:n];
integer i,f1,f2;

// Outputs
wire [7:0] p;

// Instantiate the Unit Under Test (UUT)
dctm mul8bit_inst(clk, rst, a, b, p );

 
initial begin
rst = 1; #10;
rst = 0; #10;
end 

initial begin

  $readmemh("image_textfilex.txt", data); end
  initial begin
  $readmemh("image_textfiley.txt", data1); end
  initial begin
  f1= $fopen("clk.txt","w");
  end
initial begin
a = 8'b0;
b = 8'b0;
#10;
// Initialize Inputs
for (i=0;i<(n+1);i=i+1)begin
a = data[i];
b = data1[i];
//bin=1'b0;
$fwrite(f1,"%d\n",p);
// Wait 100 ns for global reset to finish
#1;
      end  
// Add stimulus here
end   
always #10 clk = ~clk;    
endmodule
