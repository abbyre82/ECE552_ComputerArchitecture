//	Authors: 
//		Abby Rechkin
//		Alex Yavnilovitch
// Simple test for EX->EX forwarding


lbi r1, 20		// r1 = 20
lbi r3, -15		// r3 = -15
subi r2, r1, 5		// r2 = 5 - r1 = 5 - 20 = -15
add r2, r3, r2		// r2 = r3 + r2 = -15 -15 = -30
halt
