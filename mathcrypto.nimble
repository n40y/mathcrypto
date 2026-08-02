# mathcrypto.nimble

version       = "0.1.0"
author        = "n40y"
description   = "Lightweight, efficient, and dependency-free cryptographic and mathematical utilities in pure Nim."
license       = "MIT"
srcDir        = "src"

requires "nim >= 2.0.0"

task test, "Run the full test suite":
  exec "nim c -r --path:src tests/t_aes.nim"
  exec "nim c -r --path:src tests/t_euclidean.nim"
  exec "nim c -r --path:src tests/t_gf2.nim"
  exec "nim c -r --path:src tests/t_jacobi.nim"
  exec "nim c -r --path:src tests/t_primality.nim"
