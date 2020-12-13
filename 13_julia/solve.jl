function parse_bus((idx, bus))
    if bus != "x"
        return (offset=idx-1, id=parse(Int128, bus))
    end
    return missing
end


function readinput()
    n = parse(Int, readline(stdin))
    bus_parts = split(readline(stdin), ",")
    parsed = parse_bus.(enumerate(bus_parts))
    n, collect(skipmissing(parsed))
end


# stolen from https://rosettacode.org/wiki/Chinese_remainder_theorem#Julia
function chineseremainder(n::Array, a::Array)
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end


function solve_1(n, buses)
    a, b = minimum(map(b -> (b.id - n % b.id, b.id), buses))
    a * b
end


function solve_2(buses)
    modulos = map(b -> b.id, buses)
    remainders = map(b -> b.id - b.offset, buses)
    chineseremainder(modulos, remainders)
end


n, buses = readinput()
println(solve_1(n, buses))
println(solve_2(buses))
