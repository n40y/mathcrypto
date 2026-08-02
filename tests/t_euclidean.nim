# tests/t_euclidean.nim

import std/unittest
import mathcrypto/euclidean

suite "Unit tests - Extended Euclidean Algorithm & Modular Inverse":

  test "Extended GCD - Basic coprime numbers":
    let (g, x, y) = extendedGcd(240'i64, 46'i64)
    check g == 2'i64
    # Vérification de l'identité de Bézout: a*x + b*y == gcd(a, b)
    check 240'i64 * x + 46'i64 * y == g

  test "Extended GCD - Edge case b = 0":
    let (g, x, y) = extendedGcd(10'i64, 0'i64)
    check g == 10'i64
    check x == 1'i64
    check y == 0'i64

  test "Extended GCD - Coprime integers with negative linear combination":
    let (g, x, y) = extendedGcd(35'i64, 12'i64)
    check g == 1'i64
    check 35'i64 * x + 12'i64 * y == 1'i64

  test "Modular Inverse - Valid inverses":
    check modInverse(3'i64, 11'i64) == 4'i64   # 3 * 4 = 12 = 1 mod 11
    check modInverse(10'i64, 17'i64) == 12'i64 # 10 * 12 = 120 = 1 mod 17
    check modInverse(7'i64, 13'i64) == 2'i64   # 7 * 2 = 14 = 1 mod 13

  test "Modular Inverse - Exception raised when gcd != 1":
    expect(ValueError):
      discard modInverse(6'i64, 9'i64)
    expect(ValueError):
      discard modInverse(10'i64, 20'i64)
