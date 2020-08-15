/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    Testbench for the barrel shifter.  It is not exhaustive.  Rather,
    it uses random values for In, Cnt, and Op across a large timespan
    to test as many cases as possible and compare it with the golden
    output (Expected).
 */
module shifter_hier_bench;

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;   

   reg [N-1:0] In;
   reg [C-1:0]  Cnt;
   reg [O-1:0]  Op;
   wire [N-1:0] Out;

   reg         fail;

   reg [31:0]  Expected;
   integer     idx;
   
   shifter_hier DUT (.In(In), .Cnt(Cnt), .Op(Op), .Out(Out));

   initial
     begin
        In = 16'h0000;
        Cnt = 4'b0000;
        Op = 2'b00;
        fail = 0;
        
        #10000;
        if (fail)
          $display("TEST FAILED");
        else
          $display("TEST PASSED");
        $finish;
     end

   always@(posedge DUT.clk)
     begin
        In[15:0] = $random;
        //  In[15:0] = 16'hA0A0;
        Cnt[3:0] = $random;
        Op[1:0] = $random;
     end

   
   always@(negedge DUT.clk)
     begin
        case (Op)
          2'b00 :
            // Rotate Left
            begin
               Expected = In << Cnt | In >> 16-Cnt;

               if (Expected[15:0] !== Out) begin
                  $display("ERRORCHECK :: BarrelShifter :: Rotate Left       : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
                  fail = 1;
			   end
			   else begin
                  $display("LOG :: BarrelShifter :: Rotate Left       : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
               end
            end
          2'b01 :
            // Shift Left
            begin
               Expected = In << Cnt;

               if (Expected[15:0] !== Out) begin
                  $display("ERRORCHECK :: BarrelShifter :: Shift Left        : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
                  fail = 1;
			   end
			   else begin
                  $display("LOG :: BarrelShifter :: Shift Left        : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
               end
            end
          2'b10 :
            // Shift Right Arithmetic
            begin
               for(idx = 31; idx > 15 ; idx = idx - 1)
                 Expected[idx] = In[15];

               Expected[15:0] = In[15:0];
               Expected[15:0] = Expected >> Cnt;
               if (Expected[15:0] !== Out) begin
                  $display("ERRORCHECK :: BarrelShifter :: Shift Right Arith : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
                  fail = 1;
			   end
			   else begin
                  $display("LOG :: BarrelShifter :: Shift Right Arith : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
               end
            end
          2'b11 :
            // Shift Right Logical
            begin
               Expected = In >> Cnt;

               if (Expected[15:0] !== Out) begin
                  $display("ERRORCHECK :: BarrelShifter :: Shift Right Logic : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
                  fail = 1;
			   end
			   else begin
                  $display("LOG :: BarrelShifter :: Shift Right Logic : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
               end
            end
        endcase
     end
   
endmodule // shifter_hier_bench
