import numpy as np

# Test case: sequential numbers
A = np.arange(1, 65, dtype=np.int32).reshape(8, 8)
B = np.arange(1, 65, dtype=np.int32).reshape(8, 8)
C = np.dot(A, B)

# Save for SystemVerilog
np.savetxt('test_A.txt', A.flatten(), fmt='%02x')
np.savetxt('test_B.txt', B.flatten(), fmt='%02x')
np.savetxt('expected_C.txt', C, fmt='%d')
