//
//  main.swift
//
//
//  Created by Richard Todd on 4/4/24.
//
import RomanizedText
import Foundation

func usage() -> Never {
    print("""
          Usage: unromanize hebrew
                 unromanize greek
          """)
    exit(EXIT_FAILURE)
}

func doHeb(_ i: String) {
    guard !i.isEmpty else {
        print("""
  A  = aleph   B  = beth    G  = gimel    D  = dalet
  H  = heh     V  = vav     Z  = zayin    Ch = chet
  T  = teth    I  = yod     K  = kaf      L  = lamed
  M  = mem     N  = nun     S  = samekh   O  = ayin
  P  = peh     Tz = tzaddi  Q  = qoph     R  = resh
  Sh = shin    Th = tav

  Ligatures:
  Ii = yod-yod   Vi = vav-yod     Vv = vav-vav

  Niqqud:
  ;  = Sh'va                *  = Dagesh
  \\ =  Kubutz              `  = Holam
  1  = Hiriq                2  = Zeire
  3  = Segol                ;3 = Reduced Segol
  _  = Patach               ;_ = Reduced Patach
  7  = Kamatz               ;7 = Reduced Kamatz
  Shl = Shin dot left       Shr = Shin dot right
  """)
        return
    }

    let u = unromanizeHebrew(i)
    print(u)
    let html = u.unicodeScalars.map { scalar in
        scalar.value < 255 ?  String(scalar) : "&#x\(String(scalar.value, radix: 16, uppercase: false));"
    }.joined()
    print("{{hebrew text|\(html)}}")
}

func doGrk(_ i: String) {
    guard !i.isEmpty else {
        print("""
  *A/A  alpha         *B/B  beta
  *C/C  xi            *D/D  delta
  *E/E  epsilon       *F/F  phi
  *G/G  gamma         *H/H  eta
  *I/I  iota          *K/K  kappa
  *L/L  lambda        *M/M  mu
  *N/N  nu            *O/O  omicron
  *P/P  pi            *Q/Q  theta
  *R/R  rho           *S/S  sigma
  S1    medial sigma  S2  final sigma
  *S3/S3 lunate sigma *T/T  tau
  *U/U  upsilon       *V/V  digamma
  *W/W  omega         *X/X  Chi
  *Y/Y  Psi           *Z/Z  Zeta
  
  Accents:
  )  smooth breathing (  rough breathing
  /  acute            =  circumflex
  \\  grave            +  diaeresis
  |  iota subscript   &  macron
  '  breve            ?  dot below
  """)
        return
    }
    print(unromanizeGreek(i))
}

let language = if CommandLine.argc == 2 { CommandLine.arguments[1] } else { "help" }

let lfunc : ((String) -> Void) = switch(language) {
case "hebrew": doHeb
case "greek": doGrk
default: usage()
}

while true {
    print("Input (blank for help)>", terminator: " ")
    guard let theInput = readLine() else { print(); break }
    lfunc(theInput)
}
