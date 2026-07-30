## src/mathcrypto/jacobi.nim

#[
Calcule le symbole de Jacobi (a / n)
Si n est un nombre premier, cela correspond au symbole de Legendre.
    
Préconditions:
    - n doit être un entier impair strictement positif (n >= 3, n % 2 != 0).
]#

proc jacobi_symbol*(a: int, n: int): int =
    var a = a
    var n = n

    if n <= 0 or (n and 1) == 0:
        raise newException(ValueError, "n must be positive odd integer.")

    a = a mod n
    var res = 1

    while a != 0:
        while (a and 1) == 0:
            a = a shr 1
            let nMod8 = n mod 8
            if nMod8 == 3 or nMod8 == 5:
                res = -res

        if (a mod 4 == 3) and (n mod 4 == 3):
            res = -res

        let temp = a
        a = n mod a
        n = temp
  
    if n == 1:
        return res

    return 0