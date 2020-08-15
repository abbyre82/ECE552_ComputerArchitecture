// Authors:
//		Abby Rechkin
//		Alex Yavnilovitch
// Simple test for MEM->EX forwarding

lbi r2, 10		// r2 = 10
lbi r3, 14		// r3 = 14
lbi r4, 6		// r4 = 6
st r3, r2, 6		// MEM[16] <- 14
ld r1, r2, 6		// r1 <- MEM[16]
add r3, r1, r4		// r3 = r1 + r4 = 14 + 6 = 20
halt
