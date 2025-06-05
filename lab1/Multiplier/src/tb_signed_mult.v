module testbench;

reg clk;
reg [7:0] a, b;

wire [15:0] out;


signed_mult multiplier1(out, clk, a, b);

initial begin
clk = 0;
$display("first example: a = 3 b = 17");
a = 3; b = 17; 
#80 $display("first example done");
$display("second example: a = 7 b = 7");
a = 7; b = 7; 
#80 $display("second example done");
$finish;
end

always #1 clk = !clk;

//always @(posedge clk) $strobe("out: %d busy: %d at time=%t", ab, busy, $stime);

endmodule