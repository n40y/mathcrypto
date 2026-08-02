# tests/t_jacobi.nim

import std/unittest
import mathcrypto/jacobi

suite "Unit tests - Jacobi symbol":

  test "Quadratic residues and non-residues (classical cases)":
    check jacobiSymbol(2, 7) == 1
    check jacobiSymbol(5, 11) == 1   # 4^2 = 16 = 5 mod 11
    check jacobiSymbol(7, 11) == -1  # 7 est un non-résidu mod 11
    check jacobiSymbol(10, 13) == 1

  test "Case where a and n have a common factor (gcd > 1)":
    check jacobiSymbol(10, 15) == 0
    check jacobiSymbol(6, 21) == 0

  test "Limiting cases with a = 0 or a = 1":
    check jacobiSymbol(0, 7) == 0
    check jacobiSymbol(1, 7) == 1

  test "Exception raised for an invalid n (even or <= 0)":
    expect(ValueError):
      discard jacobiSymbol(2, 6)
    expect(ValueError):
      discard jacobiSymbol(2, -5)
