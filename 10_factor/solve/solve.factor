USING: kernel assocs io math math.parser prettyprint sequences sorting ;
IN: solve

: read-int ( -- n ) readln dup f = [ ] [ string>number ] if ;
: read-input- ( seq -- seq ) read-int dup f = [ drop ] [ suffix read-input- ] if ;
: read-input ( -- seq ) { } read-input- ;

: normalize-input ( seq -- seq ) natural-sort dup last 3 + suffix ;

: differentiate ( seq -- seq ) dup 0 prefix [ - ] 2map ;

: split-head ( seq -- seq n ) dup rest swap first ;

: ~at ( assoc key -- n ) swap at ;

: ntrib ( n -- n ) { 1 1 2 4 7 13 24 44 } nth ;


: solve-1- ( assoc seq -- n ) dup empty?
    [ drop dup 1 ~at swap 3 ~at * ]
    [ split-head pick inc-at solve-1- ]
    if ;

: solve-1 ( seq -- n ) H{ } swap solve-1- ;


: solve-2- ( prod sum seq -- n ) dup empty?
    [ 2drop ]
    [ split-head 1 =
        [ swap 1 + swap solve-2- ]
        [ -rot ntrib * 0 rot solve-2- ] if ]
    if ;

: solve-2 ( seq -- n ) 1 0 rot solve-2- ;


: main ( -- )
    read-input
    normalize-input
    differentiate
    dup solve-1 swap solve-2 swap . . ;

MAIN: main