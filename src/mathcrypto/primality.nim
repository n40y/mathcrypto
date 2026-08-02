## src/mathcrypto/primality.nim

import std/random
import ./jacobi

proc powerMod*(base, exp, m: uint64): uint64 =
    ## Computes `(base^exp) mod m` using binary exponentiation.
    ##
    runnableExamples:
      assert powerMod(2'u64, 10'u64, 1000'u64) == 24'u64
      assert powerMod(5'u64, 3'u64, 13'u64) == 8'u64
  
    var res = 1'u64
    var b = base mod m
    var e = exp
    while e > 0'u64:
      if (e and 1'u64) == 1'u64:
        res = (res * b) mod m
      e = e shr 1
      b = (b * b) mod m
    return res

proc isPrimeMillerRabin*(n: uint64): bool =
    ## Determines if `n` is prime using the Miller-Rabin algorithm.
    ##
    ## Deterministic for all 64-bit unsigned integers (`uint64`).
    ##
    runnableExamples:
      assert isPrimeMillerRabin(2'u64) == true
      assert isPrimeMillerRabin(104729'u64) == true
      assert isPrimeMillerRabin(561'u64) == false
  
    if n < 2'u64: return false
    if n == 2'u64 or n == 3'u64: return true
    if n mod 2'u64 == 0'u64: return false

    var d = n - 1'u64
    var s = 0'u64
    while d mod 2'u64 == 0'u64:
      d = d shr 1
      s += 1'u64

    const bases = [2'u64, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]

    for a in bases:
      if n <= a:
        break
      var x = powerMod(a, d, n)
      if x == 1'u64 or x == n - 1'u64:
        continue
      var composite = true
      for _ in 1 ..< s:
        x = powerMod(x, 2'u64, n)
        if x == n - 1'u64:
          composite = false
          break
      if composite:
        return false
    return true

proc isPrimeSolovayStrassen*(n: int, k: int = 20): bool =
    ## Determines if `n` is prime using `k` iterations of the Solovay-Strassen test.
    ##
    ## Probabilistic test based on Euler's criterion and the Jacobi symbol.
    ##
    runnableExamples:
      assert isPrimeSolovayStrassen(104729, k = 20) == true
      assert isPrimeSolovayStrassen(561, k = 20) == false
  
    if n < 2: return false
    if n == 2: return true
    if n mod 2 == 0: return false

    randomize()

    for _ in 0 ..< k:
      let a = rand(2 .. n - 1)
      let x = jacobiSymbol(a, n)
      if x == 0:
        return false

      let jacobiMod = (x mod n + n) mod n
      let modExp = powerMod(a.uint64, ((n - 1) div 2).uint64, n.uint64).int

      if jacobiMod != modExp:
        return false

    return true
