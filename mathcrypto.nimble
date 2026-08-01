# mathcrypto.nimble

task test, "Run all tests":
    exec "nim c -r --path:src tests/t_aes.nim"
    exec "nim c -r --path:src tests/t_euclidean.nim"
    exec "nim c -r --path:src tests/t_gf2.nim"
    exec "nim c -r --path:src tests/t_jacobi.nim"
    exec "nim c -r --path:src tests/t_primality.nim"

version       = "0.1.0"
author        = "n40y"
description   = "Cryptographic and number theory utilities"
license       = "MIT"
srcDir        = "src"

requires "nim >= 2.0.0"
