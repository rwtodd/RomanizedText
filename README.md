#  Romanized Text

A Swift library/cli-program to convert romanized text to unicode.

Currently it supports:

* a version of greek betacode
* a version of hebrew romanization often used in the late 19th century

## CLI program

The cli program, `unromanize` takes one argument for the language to use ("hebrew" or "greek").
When running, it just pulls lines from stdin and converts them.  Giving an empty line will
print a key to the romanization scheme.

## Other Versions

Elsewhere in my github repositories I have versions of this library in perl, ruby, python, and C.
Yeah, I'm a little strange like that.

