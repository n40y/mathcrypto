# mathcrypto

[![Nim](https://img.shields.io/badge/Nim-2.0%2B-yellow.svg)](https://nim-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Nimble Package](https://img.shields.io/badge/Nimble-mathcrypto-informational.svg)](https://github.com/n40y/mathcrypto)

## Description

A lightweight, efficient, and dependency-free Nim library providing core mathematical and cryptographic utilities, including modular arithmetic, Jacobi symbol computation, and robust primality testing algorithms.

---

## Features

- **Extended Euclidean Algorithm (`extendedGcd` & `modInverse`)**: Extended GCD returning Bezout coefficients and modular multiplicative inverse computation for 64-bit signed integers (`int64`).
- **AES-128 Primitives (`aes`)**: Full implementation of AES-128 encryption and decryption blocks (`encryptBlock`, `decryptBlock`), key schedule expansion (`expandKey`), and individual state transformations (`subBytes`, `shiftRows`, `mixColumns`, etc.).
- **Galois Field & Polynomial Arithmetic (`gf2`)**: Binary polynomial multiplication (`polyMulZ2`), modular reduction (`polyModZ2`), and multiplication in _GF(2⁸)_ / AES (`gf28Mul`).
- **Jacobi Symbol (`jacobiSymbol`)**: Fast computation of _(a / n)_ using bitwise optimizations.
- **Miller-Rabin Primality Test (`isPrimeMillerRabin`)**: **Deterministic** primality verification for all 64-bit integers (`uint64`) using known minimal deterministic bases.
- **Solovay-Strassen Primality Test (`isPrimeSolovayStrassen`)**: Probabilistic primality test based on Euler's criterion and the Jacobi symbol.
- **Modular Exponentiation (`powerMod`)**: Efficient _O(log e)_ modular exponentiation for 64-bit unsigned integers.
- **Zero External Dependencies**: Pure Nim stdlib implementation (`std/bitops`, `std/random`).
- **Nimble Ready**: Fully compliant with Nimble package layout standards and automated doctests (`runnableExamples`).
---

## Project Structure

```text
mathcrypto/
├── src/
│   ├── mathcrypto.nim        # Main export module
│   └── mathcrypto/
│       ├── aes.nim           # AES-128 encryption/decryption primitives & key schedule
│       ├── euclidean.nim     # Extended Euclidean Algorithm & Modular Inverse
│       ├── gf2.nim           # Polynomial arithmetic over Z₂[X] & GF(2⁸)
│       ├── jacobi.nim        # Jacobi symbol algorithm
│       └── primality.nim     # PowerMod, Miller-Rabin, & Solovay-Strassen
├── tests/
│   ├── t_aes.nim             # Unit tests for AES primitives
│   ├── t_euclidean.nim       # Unit tests for Extended GCD and mod inverse
│   ├── t_gf2.nim             # Unit tests for Polynomial Arithmetic
│   ├── t_jacobi.nim          # Unit tests for Jacobi symbol
│   └── t_primality.nim       # Unit tests for primality testing
├── LICENSE                   # MIT License
├── mathcrypto.nimble         # Package manifest
└── README.md
```

## Installation

### Via Nimble (Direct Remote URL)

Install the library directly from GitHub using Nimble:

```bash
nimble install https://github.com/n40y/mathcrypto.git
```

### Local Development Setup

Clone the repository and install it locally:
```bash
git clone https://github.com/n40y/mathcrypto.git

cd mathcrypto

nimble develop
```


## Usage

Import *_mathcrypto_* to access all cryptographic and mathematical procedures in your project:

```nim
import mathcrypto
import std/[strutils, sequtils]

# 1. Extended GCD & Modular Inverse
let (g, x, y) = extendedGcd(240'i64, 46'i64) # Returns (2, -9, 47)
let inv       = modInverse(3'i64, 11'i64)    # Returns 4

echo "gcd(240, 46) = ", g, " = 240*(", x, ") + 46*(", y, ")"
echo "3^-1 mod 11 = ", inv

# 2. AES-128 Encryption & Decryption
let key: Key128 = [0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
let expKey      = expandKey(key)
let pt: array[16, byte] = [0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

let ct      = encryptBlock(pt, expKey)
let decrypted = decryptBlock(ct, expKey)

assert decrypted == pt
echo "AES Ciphertext: ", ct.mapIt(it.toHex(2)).join()

# 3. Compute Jacobi Symbol (a / n)
let j1 = jacobiSymbol(2, 7)    # Returns  1 (2 is a quadratic residue mod 7)
let j2 = jacobiSymbol(7, 11)   # Returns -1 (7 is a quadratic non-residue mod 11)

echo "Jacobi (2/7): ", j1

# 4. Primality Testing (Miller-Rabin)
let p1 = isPrimeMillerRabin(104729'u64) # 10,000th prime -> true
let p2 = isPrimeMillerRabin(561'u64)    # Carmichael number -> false

echo "Is 104729 prime? ", p1

# 5. Binary Polynomials & GF(2⁸) Arithmetic
let prod = polyMulZ2(7, 3)     # (X² + X + 1) * (X + 1) = X³ + 1 -> 9
let gf   = gf28Mul(0x57, 0x83) # AES multiplication -> 0xC1

echo "GF(2^8) 0x57 * 0x83 = 0x", gf.toHex
```


## API Reference

# **_mathcrypto/euclidean_**

_proc extendedGcd*(a, b: int64): (int64, int64, int64)_ \
Computes the Extended Euclidean Algorithm for **a** and **b**. Returns **(gcd, x, y)** such that **a * x + b * y = gcd(a, b)**.

_proc modInverse*(a, m: int64): int64_ \
Computes the modular multiplicative inverse of **a** modulo **m** ( a^{-1} (mod m) ). Raises **ValueError** if _gcd(a, m) != 1_.


# **_mathcrypto/aes_**

_proc expandKey*(key: Key128): ExpandedKey_ \
Expands a 128-bit key into 176 bytes required for AES-128 (11 round keys).

_proc encryptBlock*(plaintext: array[16, byte], expandedKey: ExpandedKey): array[16, byte]_ \
Encrypts a single 16-byte block using AES-128.

_proc decryptBlock*(ciphertext: array[16, byte], expandedKey: ExpandedKey): array[16, byte]_ \
Decrypts a single 16-byte block using AES-128.


# **_mathcrypto/jacobi_**

_proc jacobiSymbol*(a: int, n: int): int_ \
Calculates the Jacobi symbol **_(a / n)_**.

* Precondition: **n** must be a positive odd integer (**n > 0**, **n = 1 (mod 2)**).

* Returns: **1**, **-1**, or **0**.

* Raises: *ValueError* if **n** is even or non-positive.


# **_mathcrypto/primality_**

_proc powerMod*(base, exp, m: uint64): uint64_ \
Computes **(base^{exp}) (mod m)** using binary exponentiation.


_proc isPrimeMillerRabin*(n: uint64): bool_ \
Determines if **n** is prime using the Miller-Rabin algorithm.

* Deterministic for all **uint64** values by testing against bases **_[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]_**.

_proc isPrimeSolovayStrassen*(n: int, k: int = 20): bool_ \
Determines if **n** is prime using **k** iterations of the Solovay-Strassen probabilistic test.


# **_mathcrypto/gf2_**

_func polyMulZ2(a, b: uint): uint*_ \
Multiplies two polynomials **A(X)** and **B(X)** over **Z₂[X]**.

_func polyModZ2(r: uint, m: uint = 0x11B): uint*_ \
Reduces polynomial **r** modulo **m** over **Z₂[X]** (defaults to **0x11B**, the AES irreducible polynomial).

_func gf28Mul(a, b: uint, m: uint = 0x11B): uint*_ \
Multiplies two elements in the finite field **(2⁸)** modulo the irreducible polynomial **m**.


## Running Tests

Execute the full suite of unit tests using Nimble:
```bash
nimble test
```

All test files located under *_tests/_* (*_t_jacobi.nim_*, *_t_primality.nim_*) will be automatically compiled and executed.


## License

This project is licensed under the MIT License. See the LICENSE file for details.
