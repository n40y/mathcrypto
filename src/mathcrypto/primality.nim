## src/mathcrypto/primality.nim

#[
Primality testing module in Nim

Offers Miller-Rabin (deterministic uint64) and Solovay-Strassen (using Jacobi).
]#

import std/random
import jacobi

proc powerMod*(base, exp, m: uint64): uint64 =
    var res: uint64 = 1
    var b = base mod m
    var e = exp

    while e > 0:
        if (e and 1) == 1:
            res = (cast[uint64](cast[int64](res) * cast[int64](b))) mod m
        b = (b * b) mod m
        e = e shr 1
    return res

# -------------------------------------------------------------
# 1. MILLER-RABIN TEST (Deterministic for all uint64)
# -------------------------------------------------------------
proc isPrimeMillerRabin*(n: uint64): bool =
    if n < 2: return false
    if n == 2 or n == 3: return true
    if (n and 1) == 0 or n mod 3 == 0: return false

    var d = n - 1
    var s = 0
    while (d and 1) == 0:
        d = d shr 1
        s += 1

        const bases = [2'u64, 3'u64, 5'u64, 7'u64, 11'u64, 13'u64, 17'u64, 19'u64, 23'u64, 29'u64, 31'u64, 37'u64]

        for a in bases:
            if a >= n: break

            var x = powerMod(a, d, n)
            if x == 1 or x == n - 1:
                continue

            var composite = true
            for _ in 0 ..< (s - 1):
                x = powerMod(x, 2, n)
                if x == n - 1:
                    composite = false
                    break

            if composite:
                return false

        return true

# -------------------------------------------------------------
# 2. SOLOVAY-STRASSEN TEST (Probabilistic, using the Jacobi symbol)
# -------------------------------------------------------------
proc isPrimeSolovayStrassen*(n: int, k: int = 20): bool =
    if n < 2: return false
    if n == 2: return true
    if (n and 1) == 0: return false

    for _ in 0 ..< k:
        let a = rand(2 .. (n - 1))
        let x = jacobi_symbol(a, n)
        if x == 0: return false

        # Euler's criterion : (a/n) ≡ a^((n-1)/2) mod n
        let modPower = powerMod(a.uint64, ((n - 1) div 2).uint64, n.uint64).int
        let jacobiMod = (x + n) mod n

        if modPower != jacobiMod:
            return false

    return true