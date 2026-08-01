## src/mathcrypto/jacobi.nim

proc jacobi_symbol*(a: int, n: int): int =
  ## Calculates the Jacobi symbol `(a / n)`.
  ##
  ## `n` must be a positive odd integer (`n > 0` and `n mod 2 != 0`).
  ##
  ## Returns:
  ## - `1` if `a` is a quadratic residue modulo `n`
  ## - `-1` if `a` is a quadratic non-residue modulo `n`
  ## - `0` if `gcd(a, n) > 1`
  ##
  ## runnableExamples:
  ##  assert jacobi_symbol(2, 7) == 1
  ##  assert jacobi_symbol(7, 11) == -1
  ##  assert jacobi_symbol(10, 15) == 0
  if n <= 0 or n mod 2 == 0:
    raise newException(ValueError, "n must be a positive odd integer")

  var aVal = a mod n
  if aVal < 0:
    aVal += n

  var nVal = n
  var resultVal = 1

  while aVal != 0:
    while aVal mod 2 == 0:
      aVal = aVal div 2
      let nMod8 = nVal mod 8
      if nMod8 == 3 or nMod8 == 5:
        resultVal = -resultVal

    swap(aVal, nVal)

    if aVal mod 4 == 3 and nVal mod 4 == 3:
      resultVal = -resultVal

    aVal = aVal mod nVal

  if nVal == 1:
    return resultVal
  else:
    return 0
