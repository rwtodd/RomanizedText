import RegexBuilder

/*
Romanized Hebrew library

RomanizedHebrew converts the romanization menthod used by the
English occultists of the 19th and 20th centuries. It is as follows:

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
      ;; = escape an actual semicolon

Letters which can be final can take a 'f' or 'i' prefix to
force the interpretation to be 'final' or 'initial'... otherwise
a letter at the end of a word is considered final.
*/

let transTable: [String:String] = [   // transliteration table
  // aleph, beth, gimel, dalet
  "A" : "\u{05d0}", "B" : "\u{05d1}", "G" : "\u{05d2}", "D" : "\u{05d3}",
  // heh, vav, zain, cheth
  "H" : "\u{05d4}", "V" : "\u{05d5}", "Z" : "\u{05d6}", "Ch" : "\u{05d7}",
  // tayt, yod, kaf_final, kaf, kaf_initial
  "T" : "\u{05d8}", "I" : "\u{05d9}", "Kf" : "\u{05da}", "K" : "\u{05db}",  "Ki" : "\u{05db}",
  // lamed, mem_final, mem, mem_initial, nun_final
  "L" : "\u{05dc}", "Mf" : "\u{05dd}", "M" : "\u{05de}", "Mi" : "\u{05de}", "Nf" : "\u{05df}",
  // nun, samekh, ayin, peh_final
  "N" : "\u{05e0}", "Ni" : "\u{05e0}", "S" : "\u{05e1}", "O" : "\u{05e2}", "Pf" : "\u{05e3}",
  // peh, peh_initial, tzaddi_final, tzaddi, tzaddi_initial
  "P" : "\u{05e4}", "Pi" : "\u{05e4}", "Tzf" : "\u{05e5}", "Tz" : "\u{05e6}", "Tzi" : "\u{05e6}",
  // qoph, resh, shin, tav
  "Q" : "\u{05e7}",  "R" : "\u{05e8}", "Sh" : "\u{05e9}", "Th" : "\u{05ea}",
  // Ligatures
  // doube-yod, double-vav, vav-yod
  "Ii" : "\u{05f2}", "Vv" : "\u{05f0}", "Vi" : "\u{05f1}",
  // niqqud
  ";;" : ";",      // escape an actual semicolon
  ";" : "\u{05b0}",  // Sh"va
  ";3" : "\u{05b1}", // Reduced Segol
  ";_" : "\u{05b2}", // Reduced Patach
  ";7" : "\u{05b3}", // Reduced Kamatz
  "1" : "\u{05b4}",  // Hiriq
  "2" : "\u{05b5}",  // Zeire
  "3" : "\u{05b6}",  // Segol
  "_" : "\u{05b7}",  // Patach
  "7" : "\u{05b8}",  // Kamatz
  "*" : "\u{05bc}",  // Dagesh
  "\\" : "\u{05bb}", // Kubutz
  "`" : "\u{05b9}",  // Holam
  "Shl" : "\u{05e9}\u{05c2}", // Shin dot left
  "Shr" : "\u{05e9}\u{05c1}"  // Shin dot right
]

let NIQQUD = ChoiceOf {
    Regex {
        ";"
        Optionally(.anyOf(";37_"))
    }
    One(.anyOf("1237_*\\`"))
}

let INFERRED_FINAL = Regex {
    ChoiceOf { "K"; "M"; "N"; "P"; "Tz" }
    Lookahead {
        ZeroOrMore(NIQQUD,.possessive)
        ChoiceOf {
            One(.word.inverted)
            Anchor.endOfSubjectBeforeNewline
        }
    }
}

let TRANSLITERATE = Regex {
    Capture {
        ("A"..."Z")
        ZeroOrMore(.anyOf("fhilvz"), .possessive)
    }
    Capture {
        Optionally(NIQQUD, .possessive)
    }
    Capture {
        Optionally(NIQQUD, .possessive)
    }
}

func defLookup(_ sub: Substring) -> String {
    let s = String(sub)
    return transTable[s, default: s]
}

public func unromanizeHebrew(_ str: some StringProtocol) -> String {
    // first, add automatic final letters
    var hebrew = String(str)
    hebrew.replace(INFERRED_FINAL) { match in
        match.0 + "f"
    }
    hebrew.replace(TRANSLITERATE) { match in
        defLookup(match.1) + defLookup(match.2) + defLookup(match.3)
    }
    return hebrew
}
