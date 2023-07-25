#%% RAS
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Use the RAS matrix scaling algorithm to find a matrix X that approximately satisfies 
# X[ ,+] = hanghe  (marginals constraints on rows)
# X[+, ] = liehe  (marginals constraints on cols)
# and X is obtained by scaling rows and columns of A

def RAS(Z_old, X_new, F_T, V_T):

    Z = np.copy(Z_old)
    hanghe = X_new - F_T # intermediate demand (RRNN,1)
    liehe = X_new - V_T # intermediate input (1, RRNN)

    converged = False
    maxDiff = np.ones((501))

    for k in range(1, 501):

        # Step 2: Column scaling
        r1 = liehe / np.sum(Z, axis=0)
        r1[np.isnan(r1)] = 0
        r1[np.isinf(r1)] = 0
        Z = np.matmul(Z, np.diag(r1)) 

        # Step 1: Row scaling
        s1 = hanghe / np.sum(Z, axis=1)
        s1[np.isnan(s1)] = 0
        s1[np.isinf(s1)] = 0
        Z = np.matmul(np.diag(s1), Z) 

        # Check for convergence
        rowDiff = np.sum(np.abs(np.sum(Z, axis=1) - hanghe)) / np.sum(hanghe)
        colDiff = np.sum(np.abs(np.sum(Z, axis=0) - liehe)) / np.sum(liehe)
        maxDiff[k] = rowDiff + colDiff
        converged = (maxDiff[k] < 0.005)
        print(maxDiff[k])
        
        if converged:
            break

    print('min:', np.min(maxDiff))
    plt.plot(maxDiff[1:k])

    return Z   




