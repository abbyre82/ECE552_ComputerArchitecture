`define IDLE 0
`define COMPARE_READ 1
`define COMPARE_WRITE 2
`define EVICT_0 3
`define EVICT_1 4
`define EVICT_2 5
`define EVICT_3 6
`define ALLOC_0 7
`define ALLOC_1 8
`define ALLOC_2 9
`define ALLOC_3 10
`define AW_0 11
`define AW_1 12
`define AW_2 13
`define AW_3 14

module cacheFSM(
                ld,
                st,
                address,
                hit,
                dirty,
                valid,
                data_in,
                tag_out,
                data_in_mem,
                mem_stall,
                enable,
                comp,
                write,
                tag_in,
                cache_data_in,
                valid_in,
                offset_in,
                done,
                mem_addr,
                mem_data,
                wr,
                rd,
                clk,
                rst,
                data_out_sys,
                data_in_sys,
                sys_stall,
                cache_hit
);

    input clk, rst;
    input ld, st, hit, dirty, valid, mem_stall;
    input [15:0] address, data_in, data_in_mem, data_in_sys;
    input [4:0] tag_out;
    
    output reg enable, comp, write, done, wr, rd, valid_in;
    output reg [15:0] mem_addr, mem_data, cache_data_in;
    output reg [4:0] tag_in;
    output reg [2:0] offset_in;
    output reg [15:0] data_out_sys;
    output reg sys_stall;
    output reg cache_hit;

    wire [15:0] state;
    reg [15:0] next_state;
    reg ld_reg, st_reg;
    reg [15:0] address_reg, data_in_sys_reg;
    reg hit_reg, dirty_reg;
    reg [15:0] data_out_reg;
    reg [4:0] tag_in_reg;


    wire [4:0] tag;
    wire [7:0] index;
    wire [2:0] offset;

    assign tag = address_reg[15:11];
    assign index = address_reg[10:3];
    assign offset = address_reg[2:0];
    assign ld_or_st = ld | st;

    // Check if we have a ld or store, if neither, stay in IDLE (FIXED)
    // Output stall signal from FSM - every state but IDLE (FIXED)
    // distinguish between mem_stall (in) and cacheFSM_stall (out) (FIXED)
    // Done sig = data out ready
    // We want to wait 2 CYCLES after mem reads - have to add 2 more states (prob)
    //         Alloc0 -> Alloc1 -> Alloc2(Alloc0 available).. (one cycle per alloc)
    // Make state a flip flop instead of always (no posedge or negedge) (FIXED)

    /** CACHE FSM **/
    always @(*) begin
        case(state)
            `IDLE: begin // Check if it's neither ld or st - stay in IDLE
                        next_state = ld ? `COMPARE_READ : (st ? `COMPARE_WRITE : `IDLE);
                        done = 1'h0;
                        sys_stall = 1'h0;
                        enable = 0;
                        write = 0;
                        comp = 0;
                        cache_hit = 0;
                        ld_reg = ld;
                        st_reg = st;
                        hit_reg = 0;
                    end
            `COMPARE_READ: begin
                        next_state = (hit & valid) ? `IDLE : ((~hit & dirty) ? `EVICT_0 : 
                                            (((hit & ~valid) | (~dirty)) ? `ALLOC_0 : `COMPARE_READ));
                        // Cache Inputs
                        comp = 1;
                        write = 0;
                        enable = 1;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_data_in = data_in_sys;
                        // Assign registers for the current operation
                        data_in_sys_reg = data_in_sys;
                        address_reg = address;
                        hit_reg = hit & valid;
                        dirty_reg = dirty;
                        data_out_reg = data_in;
                        tag_in_reg = tag_out;
                        // Mem sys outputs
                        sys_stall = 1;
                        done = (hit & valid) ? 1'h1 : 1'h0;
                        data_out_sys = (hit & valid) ? data_in : data_out_sys;
                        cache_hit = (hit & valid);
                    end
            `COMPARE_WRITE: begin
                        next_state = (hit & valid) ? `IDLE : ((~hit & dirty) ? `EVICT_0 : 
                                            (((hit & ~valid) | (~dirty)) ? `ALLOC_0 : `COMPARE_WRITE));
                        // Cache Inputs
                        comp = 1;
                        write = 1;
                        enable = 1;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_data_in = data_in_sys;
                        // Assign registers for the current operation
                        data_in_sys_reg = data_in_sys;
                        address_reg = address;
                        hit_reg = (hit & valid);
                        dirty_reg = dirty;
                        data_out_reg = data_in;
                        tag_in_reg = tag_out;
                        //flip_victimway = ld_or_st;
                        sys_stall = 1;
                        done = (hit & valid) ? 1'h1 : 1'h0;
                        data_out_sys = (hit & valid) ? data_in : data_out_sys;
                        cache_hit = (hit & valid);
                    end
            `EVICT_0: begin
                        next_state = `EVICT_1;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in_reg, index, 3'h0};
                        mem_data = data_in;
                        sys_stall = 1;
                        // Caches
                        enable = 1;
                        write = 0;
                        comp = 1;
                        tag_in = tag_in_reg;
                        offset_in = 3'h0;
                        valid_in = 1;
                    end
            `EVICT_1: begin
                        next_state = `EVICT_2;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in_reg, index, 3'h2};
                        mem_data = data_in;
                        sys_stall = 1;
                        // Caches
                        enable = 1;
                        write = 0;
                        comp = 1;
                        tag_in = tag_in_reg;
                        offset_in = 3'h2;
                        valid_in = 1;
                    end
            `EVICT_2: begin
                        next_state = `EVICT_3;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in_reg, index, 3'h4};
                        mem_data = data_in;
                        sys_stall = 1;
                        // Caches
                        enable = 1;
                        write = 0;
                        comp = 1;
                        tag_in = tag_in_reg;
                        offset_in = 3'h4;
                        valid_in = 1;
                    end        
            `EVICT_3: begin
                        next_state = `ALLOC_0;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in_reg, index, 3'h6};
                        mem_data = data_in;
                        sys_stall = 1;
                        // Caches
                        enable = 1;
                        write = 0;
                        comp = 1;
                        tag_in = tag_in_reg;
                        offset_in = 3'h6;
                        valid_in = 1;
                    end
            `ALLOC_0: begin
                        next_state = `ALLOC_1;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h0);
                        rd = ld_reg | (st_reg & (offset != 3'h0));
                        mem_addr = {address_reg[15:3], 3'h0}; 
                        mem_data = data_in_sys_reg;
                        sys_stall = 1;
                        // Disable caches
                        enable = 0;
                        write = 0;
                        comp = 0;
                    end
            `ALLOC_1: begin
                        next_state = `ALLOC_2;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h2);
                        rd = ld_reg | (st_reg & (offset != 3'h2));
                        mem_addr = {address_reg[15:3], 3'h2};
                        mem_data = data_in_sys_reg;
                        sys_stall = 1;
                        // Disable caches
                        enable = 0;
                        write = 0;
                        comp = 0;
                    end
            `ALLOC_2: begin
                        next_state = `ALLOC_3;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h4);
                        rd = ld_reg | (st_reg & (offset != 3'h4));
                        mem_addr = {address_reg[15:3], 3'h4};
                        mem_data = data_in_sys_reg;
                        // Cache inputs
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = ld_reg | (st_reg & (offset != 3'h0)) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable = 1;
                        offset_in = 3'h0;
                        // mem_system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h0) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h0) ? 1'h1 : 1'h0;
                    end
            `ALLOC_3: begin
                        next_state = `AW_2;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h6);
                        rd = ld_reg | (st_reg & (offset != 3'h6));
                        mem_addr = {address_reg[15:3], 3'h6};
                        mem_data = data_in_sys_reg;
                        // Cache Inputs
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = ld_reg | (st_reg & (offset != 3'h2)) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable = 1;
                        offset_in = 3'h2;
                        // mem_system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h2) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h2) ? 1'h1 : 1'h0;
                    end
            `AW_2: begin // Done with memory accesses - waiting for outputs
                        next_state = `AW_3;
                        wr = 0;
                        rd = 0;
                        // Cache Inputs
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = ld_reg | (st_reg & (offset != 3'h4)) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable = 1;
                        offset_in = 3'h4;
                        // Mem system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h4) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h4) ? 1'h1 : 1'h0;
                    end
            default: begin //AW_3
                        next_state = `IDLE;
                        wr = 0;
                        rd = 0;
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = ld_reg | (st_reg & (offset != 3'h6)) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable = 1;
                        offset_in = 3'h6;
                        // Mem system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h6) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h6) ? 1'h1 : 1'h0;
                    end
        endcase
    end

// Next state flip-flop
register STATE(.data_in(next_state), .state(state), .clk(clk), .rst(rst));

endmodule