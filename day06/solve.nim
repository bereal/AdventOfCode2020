import sequtils
import strformat


type Group = tuple
    all: int
    common: int

proc `+`(g1: Group, g2: Group): Group =
    (g1.all + g2.all, g1.common + g2.common)


const letters = {'a'..'z'}

iterator readGroups: Group =
    var line: string
    var common = letters
    var all: set[char] = {}

    while readLine(stdin, line):
        if len(line) == 0:
            yield (len(all), len(common))
            common = letters
            all = {}
            continue

        var cur: set[char]
        for c in line:
            incl(cur, c)

        common = common * cur
        all = all + cur

    if len(all) > 0:
        yield (len(all), len(common))


var g: Group = foldl(toSeq(readGroups), a + b)
echo fmt"{g.all} {g.common}"