## Advent of Code 2020 - Polyglot Edition

This year I all of a sudden got an idea of trying to solve the Advent of Code challenge in 25 different languages.
I didn't know that [few people](#other-peoples-attempts) already did or tried to do this before.
Below are the rants about my experience with each of the languages I chose.

Few generic consideration:

 - it makes sense to start with the languages you're familiar the least, because the task complexity tends to grow
 - some languages are better for some puzzles due to their features
 - the goal is not just solve the puzzle, but to get the sense of the language and try to write idiomatic code
 - extra points for reaching the maximum logic reuse between the 2 parts of each puzzle

I estimated my knowledge of each language by 0 to 4 scale, roughly meaning:

 - 0: little to no knowledge
 - 1: did something small occasionally
 - 2: spent some time using or deliberately learning it
 - 3: used at work before, but time passes
 - 4: full proficency

### Other People's Attempts

 * [Izzy Miller](https://github.com/izzystardust/advent-solutions) (2016)
 * [Thomas ten Katte](https://github.com/ttencate/aoc2016) (2016)
 * [Benjamin Kraft](https://github.com/benjaminjkraft/aoc2017) (2017)
 * [Oleg Yamnikov](https://github.com/yamnikov-oleg/adventofcode2017) (2017)
 * [Laurence Woodman](https://techtinkering.com/articles/advent-of-code-2018-25-days-25-languages/) (2018)
 * [Roza Gutiérrez](https://m.signalvnoise.com/my-polyglot-advent-of-code/) (2019)
 * [Ágocsi-Kiss Bence](https://github.com/akbence/adventofcode2020) (2020)
 * [MisterInSayne](https://github.com/MisterInSayne/AdventOfCode2020) (2020)
 * [Will Killian](https://github.com/willkill07/AdventOfCode2020) (2020)
 * [Justin Hill](https://github.com/hiljusti/adventofcode-solutions) (2020)

### Languages

 | Day | Language  | Knowledge | Puzzle | Solution |
 | --- | ---       | ---       | ---    | ---      |
 | 1   | [Erlang](#day-1-erlang)   | 2 | [Report Repair](https://adventofcode.com/2020/day/1)       | [Link](01_erlang/solve.escript)  |
 | 2   | [Prolog](#day-2-prolog)   | 1 | [Password Philosophy](https://adventofcode.com/2020/day/2) | [Link](02_prolog/solve.pl)  |
 | 3   | [Clojure](#day-3-clojure) | 2 | [Toboggan Trajectory](https://adventofcode.com/2020/day/3) | [Link](03_clojure/src/day03/core.clj) |
 | 4   | [AWK](#day-4-awk)         | 1 | [Password Processing](https://adventofcode.com/2020/day/4) | [Link](04_awk/solve.awk) |
 | 5   | [Z80 assembly](#day-5-z80-assembly) | 1 | [Binary Boarding](https://adventofcode.com/2020/day/5) | [Link](05_z80/solve.asm) |
 | 6   | [Nim](#day-6-nim)         | 0 | [Custom Customs](https://adventofcode.com/2020/day/6)   | [Link](06_nim/solve.nim) |
 | 7   | [Raku](#day-7-raku)       | 0 | [Handy Haversack](https://adventofcode.com/2020/day/7)  | [Link](07_raku/solve.pl6) |
 | 8   | [F#](#day-8-f)            | 0 | [Handheld Halting](https://adventofcode.com/2020/day/8) | [Link](08_fsharp/solve.fsx) |
 | 9   | [Pascal](#day-9-pascal)   | 2 |  [Encoding Error](https://adventofcode.com/2020/day/9)  | [Link](09_pascal/solve.pas) |
 | 10  | [Factor](#day-10-factor)  | 0 | [Adapter Array](https://adventofcode.com/2020/day/10)    | [Link](10_factor/solve/solve.factor) |
 | 11  | [x86 assembly](#day-11-x86-assembly) | 1 | [Seating System](https://adventofcode.com/2020/day/11) | [Link](11_x86/solve.asm) |
 | 12  | [Ruby](#day-12-ruby)      | 1 | [Rain Risk](https://adventofcode.com/2020/day/12)       | [Link](12_ruby/solve.rb)  |
 | 13  | [Julia](#day-13-julia)    | 0 | [Shuttle Search](https://adventofcode.com/2020/day/13)  | [Link](13_julia/solve.jl) |
 | 14  | [Rust](#day-14-rust)      | 1 | [Docking Data](https://adventofcode.com/2020/day/14)    | [Link](14_rust/solve/src/main.rs)  |
 | 15  | [Scratch](#day-15-mit-scratch) | 1 | [Rambunctious Recitation](https://adventofcode.com/2020/day/15) | [Link](https://scratch.mit.edu/projects/464039643/) |
 | 16  | [C++](#day-16-c)           | 3 | [Ticket Translation](https://adventofcode.com/2020/day/16) | [Link](16_cpp/solve.cpp) |
 | 17  | [Haskell](#day-17-haskell) | 2 | [Conway Cubes](https://adventofcode.com/2020/day/17)    | [Link](17_haskell/Solve.hs) |
 | 18  | [C](#day-18-c)             | 2 | [Operation Order](https://adventofcode.com/2020/day/18) | [Link](18_c/solve.c) |
 | 19  | [JavaScript](#day-19-javascript) | 4 | [Monster Messages](https://adventofcode.com/2020/day/19) | [Link](19_js/solve.js) |
 | 20  | [Scala](#day-20-scala)     | 1   | [Jurassic Jigsaw](https://adventofcode.com/2020/day/20)  | [Link](20_scala/solve.scala) |
 | 21  | [Dart](#day-21-dart)       | 2   | [Allergen Assessment](https://adventofcode.com/2020/day/21) | [Link](21_dart/solve.dart) |
 | 22  | [Elixir](#day-22-elixir)   | 0   | [Crab Combat](https://adventofcode.com/2020/day/22)   | [Link](22_elixir/solve.exs) |
 | 23  | [Go](#day-23-go)           | 4   | [Crab Cups](https://adventofcode.com/2020/day/23)     | [Link](23_go/solve.go) |
 | 24  | [Zig](#day-24-zig)         | 0   | [Lobby Layout](https://adventofcode.com/2020/day/24)  | [Link](24_zig/solve.zig) |
 | 25  | [Octave](#day-25-octave)   | 0   | [Combo Breaker](https://adventofcode.com/2020/day/25) | [Link](25_octave/solve.m) |


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

As for the puzzle, it can be brute-forced, but the recursive search can be way faster if the array is
sorted beforehand.

[Solution](01_erlang/solve.escript) | [Up](#languages)


### Day 2: Prolog

_Site_: https://www.swi-prolog.org/ (the implementation I used)

_Knowledge_: 1

_Puzzle_: [Password Philosophy](https://adventofcode.com/2020/day/2). Match strings against the rules.

Prolog is one of the languages they taught is in the Uni and since then I tried to use it for some small projects.
Still, the paradigm shift from function calling to pattern matching is challenging every time. A very nice brain exercise.
The puzzle had to do with validating the passwords according to certain rules, and pattern matching is a great tool for such tasks.

[Solution](02_prolog/solve.pl) | [Up](#languages)


### Day 3: Clojure

_Site_: https://clojure.org/

_Knowledge_: 2

_Puzzle_: [Toboggan Trajectory](https://adventofcode.com/2020/day/3). Traverse a two-dimensional array according to the rules.

I'm in love-hate relations with Clojure. I love it when I write, and I hate it when I have to read it.
In this particular puzzle Clojure's coolest features, such as persistent data structures, concurrency abstractions,
metaprogramming etc cannot be demonstrated. But `loop-recur` and short `#(...)`-lambda syntax are cool.

[Solution](03_clojure/src/day03/core.clj) | [Up](#languages)


### Day 4: AWK

_Site_: http://www.awklang.org/

_Knowledge_: 1

_Puzzle_: [Password Processing](https://adventofcode.com/2020/day/4). Validate strings with fields.

AWK is a small DSL language whose main habitat is between the pipes in text-processing one-liners. So I decided it was
worth trying to pay it some respect by writing more than one line for a change. Worked just fine and easy, though
I am not sure how idiomatic is the code.

[Solution](04_awk/solve.awk) | [Up](#languages)


### Day 5: Z80 assembly

_Site_: https://esolangs.org/wiki/Z80golf (the emulator I used)

_Knowledge_: 1

_Puzzle_: [Binary Boarding](https://adventofcode.com/2020/day/5). Decode ticket numbers and find a vacant seat.

ZX-Spectrum was my first computer and I still spend some time watching other people streaming games on it.
I have not touched Z80 assembly since I was 15, so when I saw an easy to use Z80 emulation, I just had to try it.
It was luck that this puzzle was essentially about binary numbers processing, and I am sort of proud
to have squeezed the core solution in less than 60 lines of assembly code. 40 more lines are printing the result
as decimals, which I mostly copy-pasted. An oh my I completely forgot how limited the instruction set is.

[Solution](05_z80/solve.asm) | [Up](#languages)


### Day 6: Nim

_Site_: https://nim-lang.org/

_Knowledge_: 0

_Puzzle_: [Custom Customs](https://adventofcode.com/2020/day/6). Unions and intersections of sets.

Disclaimer: I had no idea about Nim before and this is going to be a subjective first impression. I realize,
that most of the features that Nim advertises cannot appear in a 50-lines snippet and I think I'll give it another
try someday. But currently it feels that the authors were pulling all the features they enjoy most
and I am failing to see the common idea behind the language and the library, which leaves the eclectic impression of
[Homer Simpson's car](https://static.wikia.nocookie.net/simpsons/images/0/05/TheHomer.png). And oh God, it's case-insensitive.
Moreover, it ignores underscores in names, so it doesn't know a snake from a camel, if you see, what I mean.

[Solution](06_nim/solve.nim) | [Up](#languages)


### Day 7: Raku

_Site_: https://raku.org/

_Knowledge_: 0

_Puzzle_: [Handy Haversack](https://adventofcode.com/2020/day/7). Parse and traverse a tree-like structure.

Forget what I said about Nim's being eclectic. Now, this is the proper Frankenstein's monster that evolved
from a once ubiquitous domain-specific language. I recall using Perl more than a decade ago, and I don't remember liking it
with its `$variable` `@name` `%prefixes`, automagically created variables and million ways to do the same simple
things, which may be good when you write, but may suck when you read. As for Perl 6, I have never seen it before.
Few days ago I learned that Perl 6 was renamed to Raku long ago, that's how little I know about it.
It certainly was worth trying, especially because tools to build grammars and parsers are embedded into the language,
which is an interesting concept. But other than that, this is way too far from what I'm used to.

[Solution](07_raku/solve.pl6) | [Up](#languages)


### Day 8: F#

_Site_: https://fsharp.org/

_Knowledge_: 0

_Puzzle_: [Handheld Halting](https://adventofcode.com/2020/day/8). Emulate and fix a program in a tiny language.

I have almost never tried F# before, since I had very little business with .Net. Wikipedia mentions F# among
dialects of OcaML, which doesn't tell me a lot, because I have not used it either. At the first glance it's
what I would expect from a functional language, no surprises, neither good nor bad.

[Solution](08_fsharp/solve.fsx) | [Up](#languages)


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

[Solution](09_pascal/solve.pas) | [Up](#languages)


### Day 10: Factor

_Site_: https://factorcode.org/

_Knowledge_: -1

_Puzzle_: [Adapter Array](https://adventofcode.com/2020/day/10). Count combinations in array.

I had at least some idea about the languages I used in the previous days, but this one was a total surprise.
I had very little experience with stack-based languages, so it feels very alien.
This thing really made my rusty cogs turn. A nice thing about Factor is its static checks that
verify how the stack is used. For example, if a function is declared as

    : my-func ( x y -- z ) ...

it means that it's expected to consume two topmost values on the stack, and put one instead.
(It's also ok just to consume one, so that the math adds up.) For example, the following function are valid:

    : my-func ( x y -- z ) 3 * swap dup * +             ;  ! z = x^2 + 3*y

    : my-func ( x y -- z ) 2dup > [ drop ] [ nip ] if  ;  ! z = max(x, y)

but this one is not:

    : my-func ( x y -- z ) * 3 ;  ! leaves two values on the stack instead of declared one


While doing this exercise I was able to try higher-level constructs, such as currying and filters,
but didn't try Factor's flavour of object-oriented programming and metaprogramming, so will definitely
get back to it someday.
To be honest, being busy struggling with the language, I failed to find the solution
for the second part fully myself, so I got a hint about "tribonacci numbers" at reddit.
But even then it wasn't the easiest coding in my life.

_Update_: After I published the solution on /r/adventofcode, /u/chunes made a
[really nice review](https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfnl8wi?utm_source=share&utm_medium=web2x&context=3)
and suggested how I can improve the code. I applied most of his suggestions, and left some
until the time when I can fully understand them.

[Solution](10_factor/solve/solve.factor) | [Up](#languages)


### Day 11: x86 assembly

_Knowledge_: 1

_Puzzle_: [Seating System](https://adventofcode.com/2020/day/11). A modified Conway's Game of Life.

The puzzle looked like a perfect match for assembly, and the first part was quite easy, but the second one took me a while.
The hardest thing was not the logic per se, but unifying the both parts and reusing the code.
In the end I was able to find the approach where both parts stand just two lines apart.
For each cell there's a "scanner" that checks its surroundings.
In the case of the second part, the scanner expands until it finds a seat in each direction.

[Solution](11_x86/solve.asm) | [Up](#languages)


### Day 12: Ruby

_Knowledge_: 1

_Site_: https://www.ruby-lang.org/

_Puzzle_: [Rain Risk](https://adventofcode.com/2020/day/12). Navigate points on a plane

After struggle with assembly I wanted something relaxing yet new, so Ruby it is. The puzzle is very easy, too.

[Solution](12_ruby/solve.rb) | [Up](#languages)


### Day 13: Julia

_Knowledge_: 0

_Site_: https://julialang.org/

_Puzzle_: [Shuttle Search](https://adventofcode.com/2020/day/13). Congruences.


The first part of the puzzle looked so easy, that it was tempting to try something like
[Scratch](https://scratch.mit.edu/) with it. I remembered that it was the day 13 already, so it's not
supposed to be that simple.
So I decided to take a sneak peek, and wrote a Python one-liner for it. It turned out that the second part
is not quite as trivial, though three words crossed my mind immediately:
[Chinese Remainder Theorem](https://en.wikipedia.org/wiki/Chinese_remainder_theorem). The schedules constraints
form a system of congruences, and the algorithm is known.

So, Julia it is. Never tried it before. It's supposed to be really good and fast at things
where Python+Numpy is usually the first option these days. Inspired by R, Matlab and Python on one hand,
and Lisp on the other hand.
Being mainly purposed for scientific computations, Julia has powerful built-in array operations
and features like [broadcasting](https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting), when you can
convert an operation on scalars to an operation on arrays literally with a single dot.
There are also cool higher-level features like multiple method dispatch and powerful
metaprogramming (code is data, too, like in Lisp), but, unfortunately, in the final version of the solution
none of those things found any use.
My plan is to try Julia with [cryptopals challenge](https://cryptopals.com/) someday.

Oh yes, and Julia indexes the arrays starting from `1`, which I guess is supposed
to emphasize its scientific purpose.

[Solution](13_julia/solve.jl) | [Up](#languages)


### Day 14. Rust

_Knowledge_: 1

_Site_: https://www.rust-lang.org/

_Puzzle_: [Docking Data](https://adventofcode.com/2020/day/14). Bit mask manipulations.

Oh my, oh my, finally I did Rust. Was looking forward to it. I believe, Rust is the most
ambitious programming lanugage of the past decade. It's supposed to be better at everything C++
is good at, only faster, safer, more expressive and without the legacy of C.
But, like C++, it's not an easy language I'd just play with occasionally for some small things.
Ownership and borrowing, type system, lifetimes - all takes time to understand.
The good news is that the documentation is awesome and the community is friendly. Even the compiler
errors look friendly. I did some of the aforementioned cryptopals challenges in Rust before,
so had some idea what to expect.

I'm not proud of my puzzle solution, but looks good enough for starters.
There's a lot of bit manipulations, which could be done more elegant.
I enjoyed implementing the floating bits logic with an iterator, though. If I paid more attention
to the text of the puzzle (bit manipulations rules changed in the second part), I'd waste less time.

[Solution](14_rust/solve/src/main.rs) | [Up](#languages)


### Day 15. MIT Scratch

_Knowledge_: 1

_Site_: https://scratch.mit.edu/

_Puzzle_: [Rambunctious Recitation](https://adventofcode.com/2020/day/15) (now, that's a new word). Numeric sequences.

Scratch is a very simple toy language that's supposed to teach kids how to program.
You compose blocks of code into syntax trees to make sprites do funny things.
To be honest, I am not sure how good this idea is, I mean not the idea of teaching kids, but the approach.
In fact, Scratch is mainly focused on syntax, and syntax is not the most challenging or interesting part of programming.
So once you get quite familiar with it, which is quite soon, the environment will get in your way.
But the intention of making programming look less intimidating is nice.

The puzzle is quite trivial, the only roadblock was that Scratch doesn't have dictionaries / hashmaps / whatever you call'em
(there are [extensions](https://scratch.mit.edu/discuss/topic/330289/), though). So I had to replace a dict with a
pre-allocated list of 2000 values. Solving the first part without artificial delays takes a couple of minutes.
The second part is obviously out of question, so I quickly hacked it with Python :)

[Solution](https://scratch.mit.edu/projects/464039643/) | [Up](#languages)


### Day 16. C++

_Knowledge_: 3

_Site_: https://isocpp.org/

_Puzzle_: [Ticket Translation](https://adventofcode.com/2020/day/16). Constraint resolution.

I don't know what I can tell about C++. It's C++. Who doesn't love its friendly error messages:

    /usr/include/c++/10.2.0/bits/stl_iterator.h: In instantiation of ‘std::back_insert_iterator<_Container>& std::back_insert_iterator<_Container>::operator=(typename _Container::value_type&&) [with _Container = std::set<std::__cxx11::basic_string<char> >; typename _Container::value_type = std::__cxx11::basic_string<char>]’:
    /usr/include/c++/10.2.0/bits/stl_algo.h:4313:12:   required from ‘_OIter std::transform(_IIter, _IIter, _OIter, _UnaryOperation) [with _IIter = __gnu_cxx::__normal_iterator<const constraint*, std::vector<constraint> >; _OIter = std::back_insert_iterator<std::set<std::__cxx11::basic_string<char> > >; _UnaryOperation = solve2(const input&)::<lambda(auto:5&)>]’
    solve.cpp:48:60:   required from here
    /usr/include/c++/10.2.0/bits/stl_iterator.h:622:13: error: ‘class std::set<std::__cxx11::basic_string<char> >’ has no member named ‘push_back’
    622 |  container->push_back(std::move(__value));
        |  ~~~~~~~~~~~^~~~~~~~~

I mean, if you see a language that can get away with stuff like that, it must be a great language, right?
I did some professional development in it like 10 years ago, but these days C++ is like those statues from Doctor Who.
When you blink, it moves forward. I cannot say I enjoyed this short reunion with C++, but, after all, pain is just weakness leaving your body.

The puzzle is conceptually simple, but took some time to debug. For some reason I find reasoning about tabular data challenging.

[Solution](16_cpp/solve.cpp) | [Up](#languages)


### Day 17. Haskell

_Knowledge_: 2

_Site_: https://www.haskell.org/

_Puzzle_: [Conway Cubes](https://adventofcode.com/2020/day/17). Multi-dimensional Conway's Game of Life.

Current solution works in ~14 sec for both parts for me, I'm out of ideas what else I can improve.
After realising (not without a [hint](https://www.reddit.com/r/adventofcode/comments/keqsfa/2020_day_17_solutions/gg54nnv?utm_source=share&utm_medium=web2x&context=3)),
how to visit less cells it went there down from 25 seconds.
At this point, the solution is nearly identical to the one linked above, cannot spot any difference.
Will revisit it later.

(_update_: ahah, I was running it with `runhaskell` all along, after compiling it completes in less than 2s)

[Solution](17_haskell/Solve.hs) | [Up](#languages)


### Day 18. C

_Knowledge_: 2

_Site_: https://www.iso.org/standard/74528.html

_Puzzle_: [Operation Order](https://adventofcode.com/2020/day/18). Expression parsing.

I know, this puzzle allows for some smart tricks. For example, few Reddit people
[used](https://www.reddit.com/r/adventofcode/comments/kfeldk/2020_day_18_solutions/gg87w89?utm_source=share&utm_medium=web2x&context=3)
Julia's ability of overloading the operations. I guess, you could do a similar thing in Python, just a bit more verbose.
But does a boy get a chance to implement the [shunting-yard algorithm](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)
every day? I remember doing that in C as a student, so it awakes nostalgic memories.
So, here we go, this is a simplified implementation of it, that instead of producing Reverse Polish notation
just evaluates the expression on the fly. One of my favorite algorithms, actually. Operation precedence is provided
as a function argument.

[Solution](18_c/solve.c) | [Up](#languages)


### Day 19. JavaScript

_Knowledge_: 4

_Puzzle_: [Monster Messages](https://adventofcode.com/2020/day/19). Grammars and regular expressions.

My first impulse was to generate a grammar using parser combinators in e.g. Scala, but then I was like _wait a sec_...
The grammar in the first part is easily converted into a regular expression.
So, I did it with JavaScript, a.k.a JS a.k.a ECMAScript, the ugly duckling of programming languages.
It used to be horrible, but ES6 already looks decent for its purposes. I don't feel like bitching
about JS anymore: first, it's boring and unoriginal, and second - it's the language number one, just deal with it.
I chose it just because it doesn't really matter what language to use to generate regexps (though with Perl or PHP
it could be more elegant due to recursive regexps, and yes I realize I've just used "PHP" and "elegant" in the same sentence).

As I said, the first part was straightforward, but in the second, you'll have to deal with sequences
like `a{n}b{n}` for any `n >= 1` which cannot be done without recursive regexps (see above).
So I just used a `|`-combination of `ab`, `a{2}b{2}`, `a{3}b{3}` and `a{4}b{4}`
which was enough for my case.

[Solution](19_js/solve.js) | [Up](#languages)

### Day 20. Scala

_Knowledge_: 1

_Site_: https://www.scala-lang.org/

_Puzzle_: [Jurassic Jigsaw](https://adventofcode.com/2020/day/20). A jigsaw puzzle and pattern matching.

Oh. My. God. It's less than 150 lines, but I'm exhausted. I ended up solving the second part in imperative style,
and not ashamed. I guess, now I can see how it can be done functionally, but definitely, not today.
I wish I could blame Scala, but it (and the IDE) was quite helpful with all the autocompletions and type hints.
Still, I'm not sure about Scala, I mean, too much stuff happen implicitly, and all the type annotations
are sometimes more cryptic than in C++. And forget about using it without an IDE (I tried Metals for VS Code,
but at some point autocompletion refused to work, so I resorted to installing good old IntelliJ Idea).

The good news is that I revisited [symmetry groups](https://en.wikipedia.org/wiki/Symmetry_group), and
that was fun.

[Solution](20_scala/solve.scala) | [Up](#languages)

### Day 21. Dart

_Knowledge_: 2

_Site_: https://dart.dev/

_Puzzle_: [Allergen Assessment](https://adventofcode.com/2020/day/21). Constraints resolution.

Dart was supposed to replace Javascript in browsers, then it was essentially dead,
and recently it rose from its grave to become the language of [Flutter](https://flutter.dev/).
I don't always develop mobile apps, but when I do, I use Dart. It resembles TypeScript a lot,
except it's not burdened with the JS legacy, like `this`, and has some nice features like streams.
On the other hand, TS is able to use all the JS code, which is _a lot_ of code.

The puzzle is essentially the same as on the [day 16](#day-16-c), just differently worded, so the solution is identical.

[Solution](21_dart/solve.dart) | [Up](#languages)


### Day 22. Elixir

_Knowledge_: 0

_Site_: https://elixir-lang.org/

_Puzzle_: [Crab Combat](https://adventofcode.com/2020/day/22). Lists and recursion.

Elixir is Erlang in Ruby's clothes. The puzzle is all about recursive list processing, so
a functional language is a no-brainer choice. But all the coolest features, like metaprogramming,
polymorphism, and concurrency remained unexplored. Well, someday... The only remark so far:
having to use `fun.()` syntax for variable-bound functions feels a bit awkward.

[Solution](22_elixir/solve.exs) | [Up](#languages)


### Day 23. Go

_Knowledge_: 4

_Site_: https://golang.org/

_Puzzle_: [Crab Cups](https://adventofcode.com/2020/day/23). Linked Lists with a twist.

So, the first part is a trap. I did it in the most obvious way, so had to start over. The challenge
of the second part is that you have to both move values inside a list (where a linked list is a nice choice) and search for values in it
(where it's not). Not without a hint, I recalled that things often become simpler when you deal with adjacent integer values...
I won't spoil too much here, see the code.

As for Go, it's a good example of how you can focus on solving problems you need to get solved instead of following
all the hype trends and do just fine. I really like their stance of implementing just those feature they are really sure they need.
And it's simple. You learn it in a week or so, and then: where's the advanced part? Advanced Go is to keep using Go
in the most simple and straightforward way. This is the way.

[Solution](23_go/solve.go) | [Up](#languages)


### Day 24. Zig

_Knowledge_: 0

_Site_: https://ziglang.org/

_Puzzle_: [Lobby Layout](https://adventofcode.com/2020/day/24). Hexagonal Game of Life.

Never heard of Zig before, but then I saw people doing
[this](https://github.com/fyrchik/aoc2020zig) or the [previous](https://github.com/andrewrk/advent-of-code) AoC in it. Let's see what it [promises](https://ziglang.org/#Small-simple-language):

  > Focus on debugging your application rather than debugging your programming language knowledge.

You son of a bitch, I'm in! And, I must say, this was the most interesting discovery of this entire challenge.
Memory management, type system, `comptime`s, error handling - all looks quite fresh. The language is still in its cradle, so
the docs, examples and stdlib are a bit sparse sometimes, but it's already enormous amount of work for 4 years.
Those Zig AoC repos above and stdlib code also helped to understand few basic principles faster.
5/5, will definitely try again.

The puzzle is yet another Game of Life variation, but was also of educational value,
at least, I learned about different [coordinate systems](https://www.redblobgames.com/grids/hexagons/#coordinates)
for hexagonal grids.

[Solution](24_zig/solve.zig) | [Up](#languages)


### Day 25. Octave

_Knowledge_: 0

_Site_: https://www.gnu.org/software/octave/

_Puzzle_: [Combo Breaker](https://adventofcode.com/2020/day/25). Diffie-Hellman key exchange.

I decided to try Octave because I expected a scientific package to have more powerful tools for algebra, but no.
Big integers? Better try Python. Modular exponentiation, at least? All by hands.

Anyway, yay, I have done this, and the challenge is complete! I had a lot of fun, and see you next year!

[Solution](25_octave/solve.m) | [Up](#languages)