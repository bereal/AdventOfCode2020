class Bag {
    has Str $.description;
    has Map $.content;
}

grammar BagGrammar {
    token TOP { <sentence> '.' }

    rule sentence {
        <bag> <.ws> 'contain' <.ws> <list>
    }

    rule bag { <feature> <.ws> <feature> <.ws> <.bagKW> }
    rule list { [<bag-amount>* % <.separator> | <no-other> ] }
    rule bag-amount { <number> <.ws> <bag> }

    token no-other { 'no' <.ws> 'other' <.ws> 'bags' }
    token bagKW { [ bag | bags ] }
    token feature { <:alpha>+ }
    token separator { <.ws> ',' <.ws> }
    token number { \d+ }
}

class BagActions {
    method list       ($/) { make $<no-other> ?? @[] !! $<bag-amount>.map({.made}) }
    method bag        ($/) { make $<feature>.join(" ") }
    method bag-amount ($/) { make $<bag>.made => ($<number> ?? $<number>.made !! 0) }
    method number     ($/) { make $/.Int }

    method sentence ($/) {
        make Bag.new(
            description => $<bag>.made,
            content => Map.new($<list>.made)
        );
    }
    method TOP ($/) { make $<sentence>.made }
}

sub read-bags {
    return lines().map({ BagGrammar.parse($_, actions => BagActions).made });
}

sub build-reverse-graph(@bags) {
    # build hash bag name -> bags it may be contained in
    my %graph;
    for @bags -> $bag {
        for $bag.content.keys -> $name {
            if %graph{$name}:exists {
                %graph{$name}.push($bag.description);
            } else {
                %graph{$name} = [$bag.description];
            }
        }
    }
    return %graph;
}

sub solve1(@bags) {
    my %graph = build-reverse-graph @bags;
    my $seen = SetHash.new;
    my @queue = ["shiny gold"];

    while @queue.elems {
        my $cur = @queue.pop;
        for (%graph{$cur} || []) -> @parents {
            for @parents {
                if !$seen{$_} {
                    @queue.push($_);
                    $seen.set($_);
                }
            }
        }
    }
    return $seen.elems;
}

sub solve2(@bags) {
    my %byname = Map.new(@bags.map({ $_.description => $_ }));

    sub recur($current) {
        my $count = 1;
        if %byname{$current}:exists {
            for %byname{$current}.content.kv -> $name, $c {
                $count += $c * recur($name);
            }
        }
        return $count;
    }

    return recur("shiny gold") - 1;
}

my @bags = read-bags;
say(solve1 @bags);
say(solve2 @bags);
