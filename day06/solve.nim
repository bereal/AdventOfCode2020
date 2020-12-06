proc readGroup(all: var set[char], common: var set[char]): bool =
    var line: string
    common = {'a'..'z'}
    all = {}

    while readLine(stdin, line):
        if len(line) == 0:
            return true

        var cur: set[char]
        for c in line:
            incl(cur, c)
        common = common * cur
        all = all + cur

    return len(all) > 0


var common, all: set[char]
var countAll = 0
var countCommon = 0
while readGroup(all, common):
    countAll += len(all)
    countCommon += len(common)

echo countAll
echo countCommon