# Designed by Om Joshi
# Shor's Algorithm, ported to Python from Matlab

import numpy as np
import matplotlib.pyplot as plt
from math import sqrt, gcd

# https://en.wikipedia.org/wiki/Quantum_Fourier_transform
# see above link for explanation of algorithm

def shor_algorithm():
    print("Shor's Algorithm in Python, designed by Om Joshi")
    N = int(input("What number do you want to factor? N = ")) # our factorization target
    Q = N**2

    # generate the QFT by computing roots of unity (sped up by memoizing)
    qft = np.zeros((Q,Q), dtype='complex_')
    root_lookup = {}
    for i in range(Q):
        for j in range(Q):
            if i*j in root_lookup:
                qft[i][j] = root_lookup[i*j]
            else:
                root = np.exp(1j*2*np.pi*i*j/Q)/sqrt(Q)
                root_lookup[i*j] = root
                qft[i][j] = root

    # loop until we find a suitable x value
    while True:
        x = int(input(f"Pick a number x where 1 < x < {N}: x = "))
        if (g:=gcd(N,x)) != 1:
            print(f"Hooray! gcd(N,x) != 1, it's {g} which is a factor of {N}.")
            break
        
        r_reg = np.zeros((Q), dtype='complex_') # input state

        # simulate the partial measurement of the powmod register as `target`
        target = pow(x, int(np.random.choice(range(Q))), N)
        
        # collapse the state to values of r where x^r = target mod N,
        # setting r_reg = 1 to indicate an equal superposition over such r
        for i in range(Q):
            if pow(x,i,N) == target:
                r_reg[i] = 1
        
        r_reg /= np.linalg.norm(r_reg) # normalize the resulting state vector

        k_reg = qft@r_reg # apply the qft -> k domain
        k_abs = np.abs(k_reg*k_reg) # compute the probability vector

        '''
        # plot the probability of each value in the k domain
        fig, ax = plt.subplots()
        ax.plot(range(Q),k_abs)
        ax.set_title(f"QFT for N={N} Q={Q} x={x}");
        ax.set_xlim(-Q/10, Q+Q/10)
        ax.set_xlabel("k");
        ax.set_ylabel("P(k)")
        fig.show()
        '''
        
        # simulate measurement of the top few k values
        # using |k_reg| as measurement probability
        top = 20
        k_top = np.zeros((top), dtype="float64")
        for i in range(top):
            k_top[i] = np.random.choice(range(Q), p=k_abs)/Q

        # prompt for user input to determine the period based on measured values
        print("These are the approximate values of c/s:")
        print(k_top)
        print("Each value is very close to a fraction with a small denominator s_i")
        s = int(input("What do you think lcm(s_i) is? "))
        if s % 2 == 0 and (root:=pow(x,s//2,N)) != N-1: # nontrivial square root
            print(f"If everything went right, {N} = {gcd(N,root+1)} * {gcd(N,root-1)}")
            break
        print("You were unlucky! Try again with a different x value!")

if __name__ == "__main__":
    shor_algorithm()