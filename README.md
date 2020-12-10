## Advent of Code 2020 - Polyglot Edition

This year I all of a sudden got an idea of trying to solve the Advent of Code challenge in 25 different languages.
I didn't know that few people already did or tried to do this before.
Below are the rants about my experience with each of the languages I chose.

Few generic consideration:

 - it makes sense to start with the languages you're familiar the least, because the task complexity tends to grow
 - some languages are better for some puzzles due to their features
 - the goal is not just solve the puzzle, but to get the sense of the language and try to write idiomatic code

I estimated my knowledge of each language by 0 to 4 scale, roughly meaning:

 - 0: little to no knowledge
 - 1: did something small occasionally
 - 2: spent some time using or deliberately learning it
 - 3: used at work before, but time passes
 - 4: full proficency


### Day 1: Erlang

_Site_: https://erlang.org

_Knowledge_: 2

_Puzzle_: [Report Repair](https://adventofcode.com/2020/day/1). Finding numbers with the given sum in a list.

I don't really know why I chose it for the first day, just something that came to my mind first.
Solving simple puzzles in Erlang may be an enternaining and useful exercise, but they don't demonstrate the reason it exists well.
Erlang was created to develop huge distributed telecommunication system, so the language itself is just an interface
to the powerful virtual machine. Outside of the context when you need to handle 100500 kilorequests per millisecond
and handle nuclear explosions in the datacenter gracefully it looks like an old dynamically-typed functional language
with weird Prolog-like syntax. Which it is, but I still like it, and it matches the day 1 puzzle just well.
Unfortunately, I've never had a real use case for it.


### Day 2: Prolog

_Site_: https://www.swi-prolog.org/ (the implementation I used)

_Knowledge_: 1

_Puzzle_: [Password Philosophy](https://adventofcode.com/2020/day/2). Match strings against the rules.

Prolog is the languages they taught is in the Uni and since that I tried to use it for some small projects.
Still, the paradigm shift from function calling to pattern matching is challenging every time. A very nice brain exercise.
The puzzle had to do with validating the passwords according to certain rules, and pattern matching is a great tool for such tasks.


### Day 3: Clojure

_Site_: https://clojure.org/

_Knowledge_: 2

_Puzzle_: [Toboggan Trajectory](https://adventofcode.com/2020/day/3). Traverse a two-dimensional array according to the rules.

I'm in love-hate relations with Clojure. I love it when I write, and I hate it when I have to read it.
In this particular puzzle Clojure's coolest features, such as persistent data structures, concurrency abstractions,
metaprogramming etc cannot be demonstrated. But `loop-recur` and short `#(...)`-lambda syntax are cool.


### Day 4: AWK

_Knowledge_: 1

_Puzzle_: [Password Processing](https://adventofcode.com/2020/day/4). Validate strings with fields.

AWK is a small DSL language whose main habitat is between the pipes in text-processing one-liners. So I decided it was
worth trying to pay it some respect by writing more than one line for a change. Worked just fine and easy, though
I am not sure how idiomatic is the code.


### Day 5: Z80 assembly

_Site_: https://esolangs.org/wiki/Z80golf (the emulator I used)

_Knowledge_: 2

_Puzzle_: [Binary Boarding](https://adventofcode.com/2020/day/5). Decode ticket numbers and find a vacant seat.

ZX-Spectrum was my first computer and I still spend some time watching other people streaming games on it.
I have not touched Z80 assembly since I was 15, so when I saw an easy to use Z80 emulation, I just had to try it.
It was luck that this puzzle was essentially about binary numbers processing, and I am sort of proud
to have squeezed the core solution in less than 60 lines of assembly code. 40 more lines are printing the result
as decimals, which I mostly copy-pasted. An oh my I completely forgot how limited the instruction set is.


### Day 6: Nim

_Site_: https://nim-lang.org/

_Knowledge_: 0

_Puzzle_: [Custom Customs](https://adventofcode.com/2020/day/6). Unions and intersections of sets.

Disclaimer: I had no idea about Nim before and this is going to be a subjective first impression. I realize,
that most of the features that Nim advertises cannot appear in a 50-lines snippet and I think I'll give it another
try someday. But currently it feels that the authors were pulling all the features they enjoy most
and I am failing to see the common idea behind the language and the library, which leaves the eclectic impression of
[Homer Simpson's car](https://static.wikia.nocookie.net/simpsons/images/0/05/TheHomer.png). And oh God, it's case-insensitive.
Moreover, it ignores underscores in names, so `snake == camel`, if you see, what I mean.


### Day 7: Raku

_Site_: https://raku.org/

_Knowledge_: 0

_Puzzle_: [Handy Haversack](https://adventofcode.com/2020/day/7). Parse and traverse a tree-like structure.

Forget what I said about Nim's being eclectic. Now, this is the proper Frankenstein's monster that evolved
from a domain-specific language. I recall using Perl more than a decade ago, and I don't remember liking it
with its `$variable` `@name` `%prefixes`, automagically created variables and million ways to do the same simple
things, which may be good when you write, but may suck when you read. As for Perl 6, I have never seen it before.
Few days ago I learned that Perl 6 was renamed to Raku long ago, that's how little I know about it.
It certainly was worth trying, especially because tools to build grammars and parsers are embedded into the language,
which is an interesting concept. But other than that, this is way too far from what I'm used to.


### Day 8: F#

_Site_: https://fsharp.org/

_Knowledge_: 0

_Puzzle_: [Handheld Halting](https://adventofcode.com/2020/day/8). Emulate and fix a program in a tiny language.

I have almost never tried F# before, since I had very little business with .Net. Wikipedia mentions F# among
dialects of OcaML, which doesn't tell me a lot, because I have not used it either. At the first glance it's
what I would expect from a functional language, no surprises, neither good nor bad.


### Day 9: Pascal

_Site_: https://www.freepascal.org/

_Knowledge_: 2-

_Puzzle_: [Encoding Error](https://adventofcode.com/2020/day/9). Search in arrays.

Pascal and occasionally Delphi were my main languages in 1996-1999, and I wanted
to refresh my memories. I think I'd rather have Pascal remain in my memory a nice and friendly
language, with which I wrote my first linked lists etc, but during this exercise everything
in it seemed so awkward and backward, that I'll hardly want to touch it again.
I didn't even bother to polish the code or look for a more elegant solution
(I don't think there's much to improve though). Sorry, old friend, you didn't age well.


### Day 10: Factor

_Site_: https://factorcode.org/

_Knowledge_: -1

_Puzzle_: [Adapter Array](https://adventofcode.com/2020/day/10). Count combinations in array.

I had at least some idea about the languages I used in the previous days, but this one was a total surprise.
I had very little experience with stack-based languages, so it feels very alien.
This thing really made my rusty cogs turn. The best thing about Factor is its static checks that
prevent you from doing something too stupid and spend hours in debug. While doing this exercise I
was able to try higher-level constructs, such as currying and filters, but didn't try Factor's
flavour of object-oriented programming and metaprogramming, so will definitely get back to it someday.
To be honest, being busy struggling with the language, I failed to find the solution for the second part
fully myself, so I got a hint about "tribbonacci numbers" at reddit. But even then it wasn't the easiest
coding in my life.