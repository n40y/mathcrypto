# src/mathcrypto/euclidean.nim

proc extendedGcd*(a, b: int64): (int64, int64, int64) =
    ## Computes the Extended Euclidean Algorithm for given integers `a` and `b`.
    ## Returns a tuple `(gcd, x, y)` such that `a * x + b * y = gcd(a, b)`.
    ## 
    runnableExamples:
        assert extendedGcd(240, 46) == (2'i64, -9'i64, 47'i64)
        assert extendedGcd(10, 0) == (10'i64, 1'i64, 0'i64)
    
    if b == 0:
        return (a, 1'i64, 0'i64)
    
    var (oldR, r) = (a, b)
    var (oldS, s) = (1'i64, 0'i64)
    var (oldT, t) = (0'i64, 1'i64)
    
    while r != 0:
        let quotient = oldR div r
        (oldR, r) = (r, oldR - quotient * r)
        (oldS, s) = (s, oldS - quotient * s)
        (oldT, t) = (t, oldT - quotient * t)

    return (oldR, oldS, oldT)

proc modInverse*(a, m: int64): int64 =
    ## Computes the modular multiplicative inverse of `a` modulo `m`.
    ## 
    ## Finds `x` such that `(a * x) mod m == 1`.
    ## Raises a `ValueError` if the inverse does not exist (i.e., `gcd(a, m) != 1`).
    ## 
    runnableExamples:
        assert modInverse(3, 11) == 4'i64
        assert modInverse(10, 17) == 12'i64
    
    let (g, x, _) = extendedGcd(a, m)
    if g != 1:
        raise newException(ValueError, "Modular inverse does not exist (gcd != 1)")
    return (x mod m + m) mod m
