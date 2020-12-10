USING: kernel combinators generalizations assocs io math math.parser prettyprint sequences sorting ;
IN: solve

: read-int ( -- n ) readln dup f = [ drop 0 ] [ string>number ] if ;
: read-input- ( seq -- seq ) read-int dup 0 = [ drop ] [ suffix read-input- ] if ;
: read-input ( -- seq ) { } read-input- ;

: normalize-input ( seq -- seq ) natural-sort dup last 3 + suffix ;

: differentiate ( seq -- seq ) dup 0 prefix [ - ] 2map ;

: split-head ( seq -- seq n ) dup first swap rest swap ;

: solve-1- ( assoc seq -- n ) dup empty?
    [ drop dup 1 swap at swap 3 swap at * ]
    [ split-head pick inc-at solve-1- ]
    if ;

: solve-1 ( seq -- n ) normalize-input differentiate H{ } swap solve-1- ;

: main ( -- ) read-input solve-1 . ;

MAIN: main
