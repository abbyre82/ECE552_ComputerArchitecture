module replacement_logic(   // Inputs
                            clk,
                            rst,
                            flip,
                            ld_or_st,
                            hit1,
                            hit2,
                            valid1,
                            valid2,
                            dirty1,
                            dirty2,
                            tag_out1,
                            tag_out2,
                            data_out1,
                            data_out2,
                            // Outputs
                            replace_tag,
                            hit,
                            dirty,
                            replace_enable1,
                            replace_enable2,
                            replace_data_out
                        );

input clk, rst, hit1, hit2, valid1, valid2, dirty1, dirty2, ld_or_st, flip;
input [4:0] tag_out1, tag_out2;
input [15:0] data_out1, data_out2;

output hit, dirty, replace_enable1, replace_enable2;
output [4:0] replace_tag;
output [15:0] replace_data_out;

wire victimway, victim;
wire [4:0] victim_tag, hit_tag;
wire [15:0] hit_data_out, victim_data_out;

dffe VICTIMWAY(.en(flip), .q(victimway), .d(~victimway), .clk(clk), .rst(rst));

// Assign explained:
// Are both cache blocks valid - we choose the (already flipped) output of ff
// Otherwise, if way0 (valid1) is valid - target way1
// Otherwise, target way0
assign victim = (valid1 & valid2) ? ~victimway: valid1 ? 1'h1 : 1'h0;

// Intermediate signals for replacement logic
assign victim_tag = victim ? tag_out2 : tag_out1;                   // If replacing - which tag is replaced
assign victim_data_out = victim ? data_out2 : data_out1;            // if replacing - what data is in replaced block
assign hit_tag = (hit1 & valid1) ? tag_out1: tag_out2;                         // if HIT - hit tag
assign hit_data_out = (hit1 & valid1) ? data_out1 : data_out2;                 // if HIT - which data is read

assign replace_enable1 = victim ? 1'h0 : 1'h1;                      // if the victim is way1, way0_en is low
assign replace_enable2 = victim ? 1'h1 : 1'h0;                      // if the victim is way1, way1_en is high
assign hit = (hit1 & valid1) | (hit2 & valid2);                     // Is there a HIT
assign dirty = victim ? dirty2 : dirty1;                            // Set dirty bit based on the victim block
assign replace_data_out = hit ? hit_data_out : victim_data_out;     // data_out corresponds to the hit block OR the victim block
assign replace_tag = hit ? hit_tag : victim_tag;                    // tag corresponds to the hit block OR the victim block


endmodule