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

       01 pos-t            pic 9(8).
       01 pos-b            pic 9(8).
       01 pos-l            pic 9(8).
       01 pos-r            pic 9(8).

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

       perform varying idx1 from 2 by 1 until idx1 > 139
           perform varying idx2 from 2 by 1 until idx2 > 139
               if puzzle-input(idx1)(idx2:1) = "A"
                   subtract 1 from idx1 giving pos-t
                   add 1 to idx1 giving pos-b
                   subtract 1 from idx2 giving pos-l
                   add 1 to idx2 giving pos-r

                   if puzzle-input(pos-t)(pos-l:1) = 'M' and
                      puzzle-input(pos-t)(pos-r:1) = 'M' and
                      puzzle-input(pos-b)(pos-r:1) = 'S' and
                      puzzle-input(pos-b)(pos-l:1) = 'S'
                       add 1 to accum
                   end-if

                   if puzzle-input(pos-t)(pos-l:1) = 'S' and
                      puzzle-input(pos-t)(pos-r:1) = 'M' and
                      puzzle-input(pos-b)(pos-r:1) = 'M' and
                      puzzle-input(pos-b)(pos-l:1) = 'S'
                       add 1 to accum
                   end-if

                   if puzzle-input(pos-t)(pos-l:1) = 'S' and
                      puzzle-input(pos-t)(pos-r:1) = 'S' and
                      puzzle-input(pos-b)(pos-r:1) = 'M' and
                      puzzle-input(pos-b)(pos-l:1) = 'M'
                       add 1 to accum
                   end-if

                   if puzzle-input(pos-t)(pos-l:1) = 'M' and
                      puzzle-input(pos-t)(pos-r:1) = 'S' and
                      puzzle-input(pos-b)(pos-r:1) = 'S' and
                      puzzle-input(pos-b)(pos-l:1) = 'M'
                       add 1 to accum
                   end-if
               end-if
           end-perform
       end-perform.

       display accum.

       stop run.
