import sequtils
import strformat


type GroupCount = tuple
    all: int
    common: int

proc `+`(g1: GroupCount, g2: GroupCount): GroupCount =
    (g1.all + g2.all, g1.common + g2.common)


type Group = tuple
    all: set[char]
    common: set[char]

proc `*`(g1: Group, g2: Group): Group =
    (g1.all + g2.all, g1.common * g2.common)

proc parseLine(line: string): Group =
    var s: set[char]
    for c in line:
        incl(s, c)
    return (s, s)


const emptyGroup: Group = ({}, {'a'..'z'})

iterator readGroups: GroupCount =
    var line: string
    var groups: seq[Group] = @[]

    proc summarize(): GroupCount =
        let g = foldl(groups, a * b, emptyGroup)
        return (len(g.all), len(g.common))

    while readLine(stdin, line):
        if len(line) == 0:
            yield summarize()
            setLen(groups, 0)
            continue

        groups.add(parseLine(line))

    if len(groups) > 0:
        yield summarize()


var g: GroupCount = foldl(toSeq(readGroups), a + b)
echo fmt"{g.all} {g.common}"