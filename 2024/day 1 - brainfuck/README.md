## Notes
basically we need to sort 2 arrays and compare each index, then add the diff to a total.
this would be easy if we were using literally any other language

1) get the input
    - direct user input with `+[,>+]` should do
    - has exactly 14k characters, almost half our array

2) order the nums
    - luckily the data is aligned really well, easy to iterate through
    - 5 digits, 3 spaces, 5 more digits and 1 newline
    - we have to in-place sort because the input is too big for us
    - probably bubble sort since it's hard for us to move the pointer around too much
    - maybe need an intermediate language so i don't have to spam thousands of the same character

3) get the diff
    - we'll iterate through each pair
    - need to use multiple bytes to compute the total
    - perhaps calculate each digit seperately
    - each digit, 25 at a time to prevent overflows (1000->40->2->1)
    - need to take their absolute values