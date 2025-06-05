module MEM1_256X32( CK,CE,WE,A,D,Q);
  input CK,CE,WE;
  input	 [7:0]	A;
  input	 [31:0]	D;
  output [31:0]	Q;
  reg	 [31:0]	Q;

  reg	 [31:0] mem[0:255];

  //Reading
  always @(posedge CK) begin
    if (CE && !WE ) begin
	Q <= mem[A];
    end
  end

  //Writing 
  always @(posedge CK) begin
    if (CE && WE) begin
      mem[A] <= D;
    end
  end
  //Timing
  specify
	(posedge CK *> (Q:A)) = (0);
  endspecify


endmodule
