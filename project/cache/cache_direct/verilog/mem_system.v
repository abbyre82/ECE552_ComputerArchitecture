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
   wire [7:0] index;
   wire [2:0] offset, offset_in;
   wire mem_stall;

   wire hit;
   wire enable;
   wire mem_rd, mem_wr;
   wire [15:0] data_out, data_in, data_from_mem, data_to_mem, mem_addr;
   wire [4:0] tag_out, tag_in;
   wire valid, valid_in;
   wire dirty;
   wire err_mem, err_cache;
   wire [3:0] busy;
   
   assign ld = Rd;
   //assign ld_or_st = Wr | Rd;
   assign tag = Addr[15:11];
   assign index = Addr[10:3];
   assign offset = Addr[2:0];
   assign err = err_mem | err_cache;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(
                     // Outputs
                     .tag_out              (tag_out),
                     .data_out             (data_out),
                     .hit                  (hit),
                     .dirty                (dirty),
                     .valid                (valid),
                     .err                  (err_cache),
                     // Inputs
                     .enable               (enable),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index),
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
                     // Inputs
                     .st(Wr),
                     .ld(Rd),
                     .address(Addr),
                     .hit(hit),
                     .dirty(dirty),
                     .valid(valid),
                     .data_in(data_out),
                     .tag_out(tag_out),
                     .data_in_mem(data_from_mem),
                     .data_in_sys(DataIn),
                     .mem_stall(mem_stall),
                     // Outputs
                     .enable(enable),
                     .comp(comp),
                     .write(write),
                     .tag_in(tag_in),
                     .cache_data_in(data_in),
                     .valid_in(valid_in),
                     .offset_in(offset_in),
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
