# tests/t_aes.nim

import std/unittest
import mathcrypto/aes

suite "Unit tests - AES-128 Block Cipher":

  test "AES-128 Encryption & Decryption (NIST SP 800-38A Vector)":
    # Clé de 128 bits (16 octets à 0)
    let key: Key128 = [
      0x00'u8, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
      0x08'u8, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    ]
    let plaintext: array[16, byte] = [
      0x00'u8, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
      0x88'u8, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF
    ]
    let expectedCiphertext: array[16, byte] = [
      0x69'u8, 0xC4, 0xE0, 0xD8, 0x6A, 0x7B, 0x04, 0x30,
      0xD8'u8, 0xCD, 0xB7, 0x80, 0x70, 0xB4, 0xC5, 0x5A
    ]

    let expKey = expandKey(key)
    let ciphertext = encryptBlock(plaintext, expKey)

    check ciphertext == expectedCiphertext

    let decrypted = decryptBlock(ciphertext, expKey)
    check decrypted == plaintext

  test "AES-128 Zero-Block Identity":
    let key: Key128 = [0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let pt: array[16, byte] = [0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    let expKey = expandKey(key)
    let ct = encryptBlock(pt, expKey)
    let decrypted = decryptBlock(ct, expKey)

    check decrypted == pt
