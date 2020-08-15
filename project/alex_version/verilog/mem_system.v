/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   wire ld, ld_or_st;
   wire [4:0] tag;
   wire [7:0] index, index_in;
   wire [2:0] offset, offset_in;
   wire mem_stall;

   wire hit, hit1, hit2;
   wire enable1, enable2;
   wire mem_rd, mem_wr;
   wire [15:0] data_out1, data_out2, data_in, data_from_mem, data_to_mem, mem_addr;
   wire [4:0] tag_out1, tag_out2, tag_in;
   wire valid1, valid2, valid_in;
   wire dirty1, dirty2;
   wire err_mem, err_cache1, err_cache2;
   wire [3:0] busy;
   
   assign ld = Rd;
   assign ld_or_st = Wr | Rd;
   assign tag = Addr[15:11];
   assign index = Addr[10:3];
   assign offset = Addr[2:0];
   assign err = err_mem | err_cache1 | err_cache2;
   // assign err = 0;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;

   cache #(0 + memtype) c0(// Outputs
                     .tag_out              (tag_out1),
                     .data_out             (data_out1),
                     .hit                  (hit1),
                     .dirty                (dirty1),
                     .valid                (valid1),
                     .err                  (err_cache1),
                     // Inputs
                     .enable               (enable1),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index_in),
                     .offset               (offset_in),
                     .data_in              (data_in),
                     .comp                 (comp),
                     .write                (write),
                     .valid_in             (valid_in));

   cache #(2 + memtype) c1(// Outputs
                     .tag_out              (tag_out2),
                     .data_out             (data_out2),
                     .hit                  (hit2),
                     .dirty                (dirty2),
                     .valid                (valid2),
                     .err                  (err_cache2),
                     // Inputs
                     .enable               (enable2),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index_in),
                     .offset               (offset_in),
                     .data_in              (data_in),
                     .comp                 (comp),
                     .write                (write),
                     .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (data_from_mem),
                     .stall             (mem_stall),
                     .busy              (busy),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (data_to_mem),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
   // CONTROLLER
   cacheFSM CONTROLLER(
                     .st(Wr),
                     .ld(Rd),
                     .address(Addr),
                     .hit1(hit1),
                     .hit2(hit2),
                     .dirty1(dirty1),
                     .dirty2(dirty2),
                     .valid1(valid1),
                     .valid2(valid2),
                     .data_in1(data_out1),
                     .data_in2(data_out2),
                     .tag_out1(tag_out1),
                     .tag_out2(tag_out2),
                     .data_in_mem(data_from_mem),
                     .data_in_sys(DataIn),
                     .mem_stall(mem_stall),  // TODO
                     // Outputs
                     .enable1(enable1),
                     .enable2(enable2),
                     .comp(comp),
                     .write(write),
                     .tag_in(tag_in),
                     .cache_data_in(data_in),
                     .valid_in(valid_in),
                     .offset_in(offset_in),
                     .index_in(index_in),
                     .done(Done),
                     .mem_addr(mem_addr),
                     .mem_data(data_to_mem),
                     .wr(mem_wr),
                     .rd(mem_rd),
                     .clk(clk),
                     .rst(rst),
                     .data_out_sys(DataOut),
                     .sys_stall(Stall),
                     .cache_hit(CacheHit)
                     );

endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
