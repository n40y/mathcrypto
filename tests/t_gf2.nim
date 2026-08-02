# tests/t_gf2.nim

import std/unittest
import mathcrypto/gf2

suite "Unit tests - GF(2) & GF(2^8) Polynomial Arithmetic":

  test "Polynomial Multiplication in Z2[X]":
    # (X² + X + 1) * (X + 1) = X³ + 1  => 7 * 3 = 9
    check polyMulZ2(7'u, 3'u) == 9'u
    # 0 * X = 0
    check polyMulZ2(0'u, 5'u) == 0'u

  test "Polynomial Reduction in Z2[X]":
    # 9 mod (X³ + X + 1) [0x0B] -> 2
    check polyModZ2(9'u, 0x0B'u) == 2'u
    # Réduction par défaut (0x11B - Polynôme réducteur AES)
    check polyModZ2(0x11B'u) == 0'u

  test "Galois Field GF(2^8) Multiplication (AES Poly 0x11B)":
    # Vecteur standard de validation AES : 0x57 * 0x83 = 0xC1
    check gf28Mul(0x57'u, 0x83'u) == 0xC1'u
    # Élément neutre
    check gf28Mul(0xAF'u, 1'u) == 0xAF'u
    # Multiplication par zéro
    check gf28Mul(0xFF'u, 0'u) == 0'u
