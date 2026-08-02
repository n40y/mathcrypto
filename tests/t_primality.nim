# src/mathcrypto/primality.nim

import std/unittest
import std/random
import mathcrypto/primality

suite "Unit tests - Primality":

  test "Miller-Rabin – Fundamental Prime Numbers":
    check isPrimeMillerRabin(2'u64) == true
    check isPrimeMillerRabin(3'u64) == true
    check isPrimeMillerRabin(5'u64) == true
    check isPrimeMillerRabin(7'u64) == true

  test "Miller-Rabin – Large prime numbers":
    check isPrimeMillerRabin(104729'u64) == true # 10 000e nombre premier
    check isPrimeMillerRabin(1299709'u64) == true # 100 000e nombre premier

  test "Miller-Rabin – Composite numbers and edge cases":
    check isPrimeMillerRabin(0'u64) == false
    check isPrimeMillerRabin(1'u64) == false
    check isPrimeMillerRabin(4'u64) == false
    check isPrimeMillerRabin(15'u64) == false
    check isPrimeMillerRabin(561'u64) == false # Nombre de Carmichael (pseudopremier de Fermat)

  test "Solovay-Strassen – Primality testing":
    randomize()
    check isPrimeSolovayStrassen(7, k = 10) == true
    check isPrimeSolovayStrassen(104729, k = 10) == true
    check isPrimeSolovayStrassen(15, k = 10) == false
    check isPrimeSolovayStrassen(561, k = 10) == false