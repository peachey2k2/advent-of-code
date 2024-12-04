       identification division.
       program-id. AdventOfCode.

       environment division.
       input-output section.
       file-control
           select input-file assign to "../input.txt"
           organization is line sequential.

       data division. 
       file section.
       fd input-file.
       01 input-record     pic x(140).

       working-storage section.
       01 input-dims       pic 9(8) value 140.
       01 puzzle.
           05 puzzle-input occurs 140 times pic x(140).
       01 idx1             pic 9(8) value zeros.
       01 idx2             pic 9(8) value zeros.

       01 pos1m            pic 9(8).
       01 pos1a            pic 9(8).
       01 pos1s            pic 9(8).
       01 pos2m            pic 9(8).
       01 pos2a            pic 9(8).
       01 pos2s            pic 9(8).

       01 accum            pic 9(8) value zeros.

       01 eof-flag         pic x value 'n'.

       procedure division.
       open input input-file
       perform until eof-flag = 'y' or idx1 >= input-dims
           read input-file into input-record
               at end
                   move 'y' to eof-flag
               not at end
                   add 1 to idx1
                   move input-record to puzzle-input(idx1)
           end-read
       end-perform
       close input-file.

       perform varying idx1 from 1 by 1 until idx1 > input-dims
           perform varying idx2 from 1 by 1 until idx2 > input-dims
               if puzzle-input(idx1)(idx2:1) = "X"
                   if idx1 > 3
                       subtract 1 from idx1 giving pos1m
                       subtract 1 from pos1m giving pos1a
                       subtract 1 from pos1a giving pos1s
                       if puzzle-input(pos1m)(idx2:1) = 'M' and
                          puzzle-input(pos1a)(idx2:1) = 'A' and
                          puzzle-input(pos1s)(idx2:1) = 'S'
                           add 1 to accum
                       end-if
                       if idx2 > 3
                           subtract 1 from idx2 giving pos2m
                           subtract 1 from pos2m giving pos2a
                           subtract 1 from pos2a giving pos2s
                           if puzzle-input(pos1m)(pos2m:1) = 'M' and
                              puzzle-input(pos1a)(pos2a:1) = 'A' and
                              puzzle-input(pos1s)(pos2s:1) = 'S'
                               add 1 to accum
                           end-if
                       end-if
                   end-if
                   if idx2 > 3
                       subtract 1 from idx2 giving pos2m
                       subtract 1 from pos2m giving pos2a
                       subtract 1 from pos2a giving pos2s
                       if puzzle-input(idx1)(pos2m:1) = 'M' and
                          puzzle-input(idx1)(pos2a:1) = 'A' and
                          puzzle-input(idx1)(pos2s:1) = 'S'
                           add 1 to accum
                       end-if
                       if idx1 < 138
                           add 1 to idx1 giving pos1m
                           add 1 to pos1m giving pos1a
                           add 1 to pos1a giving pos1s
                           if puzzle-input(pos1m)(pos2m:1) = 'M' and
                              puzzle-input(pos1a)(pos2a:1) = 'A' and
                              puzzle-input(pos1s)(pos2s:1) = 'S'
                               add 1 to accum
                           end-if
                       end-if
                   end-if
                   if idx1 < 138
                       add 1 to idx1 giving pos1m
                       add 1 to pos1m giving pos1a
                       add 1 to pos1a giving pos1s
                       if puzzle-input(pos1m)(idx2:1) = 'M' and
                          puzzle-input(pos1a)(idx2:1) = 'A' and
                          puzzle-input(pos1s)(idx2:1) = 'S'
                           add 1 to accum
                       end-if
                       if idx2 < 138
                           add 1 to idx2 giving pos2m
                           add 1 to pos2m giving pos2a
                           add 1 to pos2a giving pos2s
                           if puzzle-input(pos1m)(pos2m:1) = 'M' and
                              puzzle-input(pos1a)(pos2a:1) = 'A' and
                              puzzle-input(pos1s)(pos2s:1) = 'S'
                               add 1 to accum
                           end-if
                       end-if
                   end-if
                   if idx2 < 138
                       add 1 to idx2 giving pos2m
                       add 1 to pos2m giving pos2a
                       add 1 to pos2a giving pos2s
                       if puzzle-input(idx1)(pos2m:1) = 'M' and
                          puzzle-input(idx1)(pos2a:1) = 'A' and
                          puzzle-input(idx1)(pos2s:1) = 'S'
                           add 1 to accum
                       end-if
                       if idx1 > 3
                           subtract 1 from idx1 giving pos1m
                           subtract 1 from pos1m giving pos1a
                           subtract 1 from pos1a giving pos1s
                           if puzzle-input(pos1m)(pos2m:1) = 'M' and
                              puzzle-input(pos1a)(pos2a:1) = 'A' and
                              puzzle-input(pos1s)(pos2s:1) = 'S'
                               add 1 to accum
                           end-if
                       end-if
                   end-if
               end-if
                       
                       
           end-perform
       end-perform.

       display accum.

       stop run.
