import numpy as np

# Test case: sequential numbers
A = np.arange(1, 65, dtype=np.int8).reshape(8, 8)
B = np.arange(1, 65, dtype=np.int8).reshape(8, 8)
C = np.dot(A, B)

# Save for SystemVerilog
np.savetxt('test_A.txt', A, fmt='%d')
np.savetxt('test_B.txt', B, fmt='%d')
np.savetxt('expected_C.txt', C, fmt='%d')
