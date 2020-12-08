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


let rec solve1 (program: Program) acc ip history =
    if Set.contains ip history then
        acc
    else
        let h = Set.add ip history
        match program.[ip] with
        | (Command.Nop, _) -> solve1 program acc (ip + 1) h
        | (Command.Acc, v) -> solve1 program (acc + v) (ip + 1) h
        | (Command.Jump, v) -> solve1 program acc (ip + v) h


let rec solve2 (program: Program) acc ip skipped history =
    if Set.contains ip history then
        None // halts
    elif ip >= program.Length then
        Some(acc) // terminates
    else
        let h = Set.add ip history

        // try including this jump, if halts, try excluding it
        let jump =
            fun v ->
                match solve2 program acc (ip + v) skipped h with
                | None -> if skipped < 0 then (solve2 program acc (ip + 1) ip h) else None
                | result -> result

        let nop =
            fun () -> solve2 program acc (ip + 1) skipped h

        match program.[ip] with
        | (Command.Nop, _) -> nop ()
        | (Command.Acc, v) -> solve2 program (acc + v) (ip + 1) skipped h
        | (Command.Jump, v) -> if ip = skipped then nop () else jump v


let program = Seq.toArray (readProgram ())
let sol1 = solve1 program 0 0 Set.empty
let sol2 = (solve2 program 0 0 -1 Set.empty).Value
printfn "%d %d" sol1 sol2
