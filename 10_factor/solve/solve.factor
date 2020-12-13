USING: kernel assocs io math math.parser math.statistics prettyprint sequences sorting ;
IN: solve

: normalize-input ( seq -- seq ) natural-sort dup last 3 + suffix ;
: differentiate ( seq -- seq ) dup 0 prefix [ - ] 2map ;

: ntrib ( n -- n ) { 1 1 2 4 7 13 24 44 } nth ;

: solve-1 ( seq -- n ) histogram values product ;


: solve-2- ( prod sum seq -- n ) dup empty?
    [ 2drop ]
    [ unclip 1 =
        [ [ 1 + ] dip solve-2- ]
        [ -rot ntrib * 0 rot solve-2- ] if ]
    if ;

: solve-2 ( seq -- n ) 1 0 rot solve-2- ;


: main ( -- )
    lines [ string>number ] map
    normalize-input
    differentiate
    [ solve-1 . ] [ solve-2 . ] bi ;

MAIN: main
