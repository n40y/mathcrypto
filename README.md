# mathcrypto

[![Nim](https://img.shields.io/badge/Nim-2.0%2B-yellow.svg)](https://nim-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Nimble Package](https://img.shields.io/badge/Nimble-mathcrypto-informational.svg)](https://github.com/n40y/mathcrypto)

## Description

A lightweight, efficient, and dependency-free Nim library providing core mathematical and cryptographic utilities, including modular arithmetic, Jacobi symbol computation, and robust primality testing algorithms.

---

## Features

- **Jacobi Symbol (`jacobi_symbol`)**: Fast computation of $(a / n)$ using bitwise optimizations.
- **Miller-Rabin Primality Test (`isPrimeMillerRabin`)**: **Deterministic** primality verification for all 64-bit integers (`uint64`) using known minimal deterministic bases.
- **Solovay-Strassen Primality Test (`isPrimeSolovayStrassen`)**: Probabilistic primality test based on Euler's criterion and the Jacobi symbol.
- **Modular Exponentiation (`powerMod`)**: Efficient $O(\log e)$ modular exponentiation for 64-bit unsigned integers.
- **Zero External Dependencies**: Pure Nim stdlib implementation (`std/random`, `std/unittest`).
- **Nimble Ready**: Fully compliant with Nimble package layout standards.

---

## Project Structure

```text
mathcrypto/
├── src/
│   ├── mathcrypto.nim        # Main export module
│   └── mathcrypto/
│       ├── jacobi.nim        # Jacobi symbol algorithm
│       └── primality.nim     # PowerMod, Miller-Rabin, & Solovay-Strassen
├── tests/
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

Import *mathcrypto* to access all cryptographic and mathematical procedures in your project:

```python
import mathcrypto

# 1. Compute Jacobi Symbol (a / n)
let j1 = jacobi_symbol(2, 7)    # Returns  1 (2 is a quadratic residue mod 7)
let j2 = jacobi_symbol(7, 11)   # Returns -1 (7 is a quadratic non-residue mod 11)
let j3 = jacobi_symbol(10, 15)  # Returns  0 (gcd(10, 15) > 1)

echo "Jacobi (2/7): ", j1

# 2. Primality Testing with Miller-Rabin (Deterministic for uint64)
let p1 = isPrimeMillerRabin(104729'u64) # 10,000th prime -> true
let p2 = isPrimeMillerRabin(561'u64)    # Carmichael number -> false

echo "Is 104729 prime? ", p1
echo "Is 561 prime? ", p2

# 3. Probabilistic Primality Testing with Solovay-Strassen
let p3 = isPrimeSolovayStrassen(104729, k = 20) # Returns true
echo "Solovay-Strassen (104729): ", p3
```


## API Reference

*mathcrypto/jacobi*
**proc jacobi_symbol*(a: int, n: int): int**
Calculates the Jacobi symbol $(a / n)$.

* Precondition: *n* must be a positive odd integer ($n > 0$, $n \equiv 1 \pmod 2$).

* Returns: *1*, *-1*, or *0*.

* Raises: *ValueError* if *n* is even or non-positive.


*mathcrypto/primality*
**proc powerMod*(base, exp, m: uint64): uint64**
Computes $(base^{exp}) \pmod m$ using binary exponentiation.


**proc isPrimeMillerRabin*(n: uint64): bool**
Determines if *n* is prime using the Miller-Rabin algorithm.

* Deterministic for all *uint64* values by testing against bases *[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]*.

**proc isPrimeSolovayStrassen*(n: int, k: int = 20): bool**
Determines if *n* is prime using $k$ iterations of the Solovay-Strassen probabilistic test.


## Running Tests

Execute the full suite of unit tests using Nimble:
```bash
nimble test
```

All test files located under *tests/* (*t_jacobi.nim*, *t_primality.nim*) will be automatically compiled and executed.


## License

This project is licensed under the MIT License. See the LICENSE file for details.
