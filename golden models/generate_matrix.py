import numpy as np

# Test case: sequential numbers
A = np.arange(0, 256, dtype=np.int8).reshape(16, 16)

B = np.arange(0, 256, dtype=np.int8).reshape(16, 16)
C = A @ B

# Save for SystemVerilog
np.savetxt('test_A.hex', A.flatten().view(np.uint8), fmt='%02x')
np.savetxt('test_B.hex', B.flatten().view(np.uint8), fmt='%02x')
np.savetxt('expected_C.hex', C, fmt='%d')
