open System.Text.RegularExpressions

type Command =
    | Nop = 0
    | Jump = 1
    | Acc = 2


type Program = (Command * int) array

let parseCommand s =
    let m =
        Regex(@"(nop|jmp|acc) ((\+|\-)?\d+)").Match(s)

    let (g1, g2) = m.Groups.[1].Value, m.Groups.[2].Value

    let command =
        match g1 with
        | "nop" -> Command.Nop
        | "jmp" -> Command.Jump
        | "acc" -> Command.Acc

    (command, g2 |> int)

let rec readProgram () =
    seq {
        let line = System.Console.ReadLine()
        if line <> null then
            yield parseCommand line
            yield! readProgram ()
    }


type ProgramState = (Program * int * int * Set<int>)

let nop (ps: ProgramState) =
    match ps with
    | (p, acc, ip, history) -> (p, acc, ip + 1, Set.add ip history)

let jump (ps: ProgramState) v: ProgramState =
    match ps with
    | (p, acc, ip, history) -> (p, acc, ip + v, Set.add ip history)

let acc (ps: ProgramState) v: ProgramState =
    match ps with
    | (p, acc, ip, history) -> (p, acc + v, ip + 1, Set.add ip history)

let halts (ps: ProgramState) =
    match ps with
    | (_, _, ip, history) -> Set.contains ip history

let terminates (ps: ProgramState) =
    match ps with
    | (p, _, ip, _) -> ip >= p.Length

let curAcc (ps: ProgramState) =
    match ps with
    | (_, acc, _, _) -> acc

let curCommand (ps: ProgramState) =
    match ps with
    | (p, _, ip, _) -> (ip, p.[ip])

let start (p: Program): ProgramState = (p, 0, 0, Set.empty)


let rec solve1 (ps: ProgramState): int =
    if halts ps then
        curAcc ps
    else
        let (_, cmd) = curCommand ps
        match cmd with
        | (Command.Nop, _) -> solve1 (nop ps)
        | (Command.Acc, v) -> solve1 (acc ps v)
        | (Command.Jump, v) -> solve1 (jump ps v)


let rec solve2 (ps: ProgramState) skipped =
    if halts ps then
        None
    elif terminates ps then
        Some(curAcc ps)
    else
        let (ip, cmd) = curCommand ps

        // try including this jump, if halts, try excluding it
        let doJump =
            fun v ->
                match solve2 (jump ps v) skipped with
                | None -> if skipped < 0 then (solve2 (nop ps) ip) else None
                | result -> result

        let doNop = fun () -> solve2 (nop ps) skipped

        match cmd with
        | (Command.Nop, _) -> doNop ()
        | (Command.Acc, v) -> solve2 (acc ps v) skipped
        | (Command.Jump, v) -> if ip = skipped then doNop () else doJump v


let program = Seq.toArray (readProgram ())
let sol1 = solve1 (start program)
let sol2 = (solve2 (start program) -1).Value
printfn "%d %d" sol1 sol2
