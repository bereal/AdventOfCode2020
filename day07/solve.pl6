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

    rule no-other { 'no' <.ws> 'other' <.ws> 'bags' }
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
    # build hash bag name -> bags may be contained it
    my %graph;
    for @bags -> $bag {
        for $bag.content.keys -> $name {
            if %graph{$name}:exists {
                %graph{$name}.push($bag.description);
            } else {
                %graph{$name} = @[$bag.description];
            }
        }
    }
    return %graph;
}

sub solve1(@bags) {
    my %graph = build-reverse-graph @bags;
    my %seen;
    my @queue;

    @queue.push("shiny gold");

    while @queue.elems {
        my $cur = @queue.pop;
          if %graph{$cur}:exists {
            for %graph{$cur} -> @new {
                for @new -> $i {
                    if %seen{$i}:!exists {
                        @queue.push($i);
                        %seen{$i} = 1;
                    }
                }
            }
        }
    }
    return %seen.keys.elems;
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
