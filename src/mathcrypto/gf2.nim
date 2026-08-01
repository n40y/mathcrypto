# src/mathcrypto

import std/bitops

# =====================================================================
# Helper functions
# =====================================================================

func bitLen*(n: uint): int {.inline.} =
    ## Returns the number of bits required to represent `n` (0 if n == 0).
    if n == 0: 0
    else: fastLog2(n) + 1


# =====================================================================
# Polynomial arithmetic over Z₂[X] & Galois Field GF(2⁸)
# =====================================================================

func polyMulZ2*(a, b: uint): uint {.inline.} =
    ## Multiplies two polynomials **A(X)** and **B(X)** over **{Z}_2[X]**.
    ##
    ## Polynomials are represented as integers where bit `i`
    ## corresponds to the coefficient of **X^i**.
    ##
    ## runnableExamples: \
    ##   # (X² + X + 1) * (X + 1) = X³ + 1
    ##   doAssert polyMulZ2(7, 3) == 9
    ##
    ##   # `(X² + 1) * (X² + 1) = X⁴ + 1  (since 2X² = 0 mod 2)`
    ##   doAssert polyMulZ2(5, 5) == 17
    var a = a
    var b = b
    while b > 0:
        if (b and 1) == 1:
            result = result xor a
        
        a = a shl 1
        b = b shr 1


func polyModZ2*(r: uint, m: uint = 0x11B): uint {.inline.} =
    ## Reduces polynomial `r` modulo `m` over **{Z}_2[X]**.
    ## Defaults to `m = 0x11B` (**X^8 + X^4 + X^3 + X + 1**, the AES irreducible polynomial).
    ##
    ## runnableExamples:
    ##   import std/bitops
    ##   # (X³ + 1) mod (X³ + X + 1) => 9 mod 11 = 2 (polynomial X)
    ##   doAssert polyModZ2(9, 11) == 2
    var r = r
    while r.bitLen >= m.bitLen:
        let k = r.bitLen - m.bitLen
        r = r xor (m shl k)
    return r

func gf28Mul*(a, b: uint, m: uint = 0x11B): uint {.inline.} =
    ## Multiplies two elements `a` and `b` in the finite field **GF(2^8)**
    ## modulo the irreducible polynomial `m` (0x11B by default for AES).
    ##
    ## runnableExamples:
    ##   # Multiply 0x57 by 0x83 in GF(2⁸) with AES polynomial (expected result: 0xC1)
    ##   doAssert gf28Mul(0x57, 0x83) == 0xC1
    return polyModZ2(polyMulZ2(a, b), m)
