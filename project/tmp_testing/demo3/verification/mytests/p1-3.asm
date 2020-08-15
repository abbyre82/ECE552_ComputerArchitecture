// Authors:
// 	Abby Rechkin
//	Alex Yavnilovitch
//
// Simple test MEM->MEM forwarding

lbi r2 16	// r2 = 16
lbi r3, 10	// r3 = 10
lbi r4, 7	// r4 = 7
st r4, r3, 0	// MEM[10] <- 7
ld r1, r3, 0	// r1 = MEM[10]
st r1, r2, 0	// MEM[16] <- 7
halt
