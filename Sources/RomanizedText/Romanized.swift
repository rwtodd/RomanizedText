import RegexBuilder

let hebrewTransTable: [String:String] = [   // transliteration table
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

let hebNiqqudRx = ChoiceOf {
    Regex {
        ";"
        Optionally(.anyOf(";37_"))
    }
    One(.anyOf("1237_*\\`"))
}

let hebInferredFinalRx = Regex {
    ChoiceOf { "K"; "M"; "N"; "P"; "Tz" }
    Lookahead {
        ZeroOrMore(hebNiqqudRx,.possessive)
        ChoiceOf {
            One(.word.inverted)
            Anchor.endOfSubjectBeforeNewline
        }
    }
}

let hebTransliterationRx = Regex {
    Capture {
        ("A"..."Z")
        ZeroOrMore(.anyOf("fhilrvz"), .possessive)
    }
    Capture {
        Optionally(hebNiqqudRx, .possessive)
    }
    Capture {
        Optionally(hebNiqqudRx, .possessive)
    }
}

func hebDefLookup(_ sub: Substring) -> String {
    let s = String(sub)
    return hebrewTransTable[s, default: s]
}

/// Return a new String with any romanized Hebrew converted into Hebrew letters.
/// | letters | letters | letters | letters |
/// | ------- | -------- | -------- | ------- |
/// |  A  = aleph |  B  = beth |   G  = gimel  |   D  = dalet |
/// | H  = heh  |   V  = vav   |  Z  = zayin   | Ch = chet  |
/// | T  = teth  |   I  = yod   |  K  = kaf   |  L  = lamed |
/// | M  = mem  |  N  = nun  | S  = samekh | O  = ayin |
/// | P  = peh   |  Tz = tzaddi  | Q  = qoph   |  R  = resh |
/// |Sh = shin   | Th = tav | | |
///
/// | Ligatures |
/// |---------|
/// | Ii = yod-yod |
/// | Vi = vav-yod |
/// | Vv = vav-vav |
///
/// | niqqud | niqqud |
/// | ------ | ------- |
/// | ;  = Sh'va   |             \*  = Dagesh |
/// | \\ =  Kubutz     |        \`  = Holam |
/// | 1  = Hiriq         |       2  = Zeire |
/// | 3  = Segol        |        ;3 = Reduced Segol |
/// | \_  = Patach       |        ;\_ = Reduced Patach |
/// | 7  = Kamatz       |        ;7 = Reduced Kamatz |
/// | Shl = Shin dot left |      Shr = Shin dot right |
///
/// (Use ;; to escape an actual semicolon)
///
/// Letters which can be final can take a 'f' or 'i' prefix to
/// force the interpretation to be 'final' or 'initial'... otherwise
/// a letter at the end of a word is considered final.
///
/// - Parameter str: the input string
/// - Returns: The Hebrew-ized string
public func unromanizeHebrew(_ str: some StringProtocol) -> String {
    // first, add automatic final letters
    var hebrew = String(str)
    hebrew.replace(hebInferredFinalRx) { match in
        match.0 + "f"
    }
    hebrew.replace(hebTransliterationRx) { match in
        hebDefLookup(match.1) + hebDefLookup(match.2) + hebDefLookup(match.3)
    }
    return hebrew
}

// GREEK SECTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let grkTransTable : [String:String] = [
  "*A": "\u{0391}", "A": "\u{03b1}", //alpha
  "*B": "\u{0392}", "B": "\u{03b2}", //beta
  "*C": "\u{039e}", "C": "\u{03be}", //xi
  "*D": "\u{0394}", "D": "\u{03b4}", //delta
  "*E": "\u{0395}", "E": "\u{03b5}", //epsilon
  "*F": "\u{03a6}", "F": "\u{03c6}", //phi
  "*G": "\u{0393}", "G": "\u{03b3}", //gamma
  "*H": "\u{0397}", "H": "\u{03b7}", //eta
  "*I": "\u{0399}", "I": "\u{03b9}", //iota
  "*K": "\u{039a}", "K": "\u{03ba}", //kappa
  "*L": "\u{039b}", "L": "\u{03bb}", //lambda
  "*M": "\u{039c}", "M": "\u{03bc}", //mu
  "*N": "\u{039d}", "N": "\u{03bd}", //nu
  "*O": "\u{039f}", "O": "\u{03bf}", //omicron
  "*P": "\u{03a0}", "P": "\u{03c0}", //pi
  "*Q": "\u{0398}", "Q": "\u{03b8}", //theta
  "*R": "\u{03a1}", "R": "\u{03c1}", //rho
  "*S": "\u{03a3}", "S": "\u{03c3}", //sigma, medial sigma
  "*S1": "\u{03a3}", "S1": "\u{03c3}", //sigma, medial sigma
  "*S2": "\u{03a3}", "S2": "\u{03c2}", //sigma, final sigma
  "*S3": "\u{03f9}", "S3": "\u{03f2}", //lunate sigma
  "*T": "\u{03a4}", "T": "\u{03c4}", //tau
  "*U": "\u{03a5}", "U": "\u{03c5}", //upsilon
  "*V": "\u{03dc}", "V": "\u{03dd}", //digamma
  "*W": "\u{03a9}", "W": "\u{03c9}", //omega
  "*X": "\u{03a7}", "X": "\u{03c7}", //Chi
  "*Y": "\u{03a8}", "Y": "\u{03c8}", //Psi
  "*Z": "\u{0396}", "Z": "\u{03b6}", //Zeta
  // accents
  ")": "\u{0313}", //smooth breathing
  "(": "\u{0314}", //rough breathing
  "/": "\u{0301}", //acute
  "=": "\u{0342}", //circumflex (maybe use 302???)
  "\\": "\u{0300}", //grave
  "+": "\u{0308}", //diaeresis
  "|": "\u{0345}", //iota subscript
  "&": "\u{0304}", //macron
  "\'": "\u{0306}", //breve
  "?": "\u{0323}", //dot below
]

let graccRx = One(.anyOf("()/=\\+|&'?"))

let sigmaFinalRx = Regex {
    Local {
        "S"
    }
    Lookahead {
            ZeroOrMore(graccRx, .possessive)
            ChoiceOf {
                One(.word.inverted)
                Anchor.endOfSubjectBeforeNewline
            }
    }
}

let greekTokenxRx = Regex {
    Capture {
        Optionally(.possessive) {
            "*"
        }
    }
    Capture {
        ZeroOrMore(graccRx,.possessive)
    }
    Capture {
        Local {
            Regex {
                ("A"..."Z")
                Optionally(.anyOf("123"))
            }
        }
    }
    Capture {
        ZeroOrMore(graccRx,.possessive)
    }
}

func grkDefLookup(_ s: some StringProtocol) -> String {
    let key = String(s)
    return grkTransTable[key, default: key]
}

///  Convert betacode a string in romanized betacode  to unicode greek.
///
/// | letters | letters |
/// | ------- | -------- |
/// | \*A/A  alpha    |     \*B/B  beta |
/// | \*C/C  xi         |   \*D/D  delta |
/// | \*E/E  epsilon |   \*F/F  phi |
/// | \*G/G  gamma   |     \*H/H  eta |
/// | \*I/I  iota   |       \*K/K  kappa |
/// | \*L/L  lambda   |    \*M/M  mu |
/// | \*N/N  nu    |      \*O/O  omicron |
/// | \*P/P  pi     |       \*Q/Q  theta |
/// | \*R/R  rho    |       \*S/S  sigma |
/// | S1    medial sigma |  S2  final sigma |
/// | \*S3/S3 lunate sigma |  \*T/T  tau |
/// | \*U/U  upsilon  |    \*V/V  digamma |
/// | \*W/W  omega  |   \*X/X  Chi |
/// | \*Y/Y  Psi     |      \*Z/Z  Zeta |
///
///  | accents | accents |
///  |-----------|-------------|
///  | )  smooth breathing | (  rough breathing |
///  | /  acute    |        =  circumflex |
///  | \\  grave    |        +  diaeresis |
///  |  \|  iota subscript |  &  macron |
///  | '  breve    |        ?  dot below |
///
public func unromanizeGreek(_ str: some StringProtocol) -> String {
    // first, add automatic final letters
    var greek = String(str)
    greek.replace(sigmaFinalRx, with: "S2")
    greek.replace(greekTokenxRx) { match in
        grkDefLookup(match.1 + match.3) +
        (match.2 + match.4).map { grkDefLookup(String($0)) }.joined()
    }
    return greek
}
