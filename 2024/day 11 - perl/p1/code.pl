#!/usr/bin/perl
use strict;
use warnings;


sub iterate {
    my @current = @_;
    my @next = ();

    for my $stone (@current) {
        my $len = length($stone);
        if ($stone+0 == 0) {
            push(@next, 1);
        } elsif ($len % 2 == 0) {
            push(@next, substr($stone, 0, $len/2)+0, substr($stone, $len/2)+0);
        } else {
            push(@next, $stone*2024);
        }
    }
    return @next;
}

open(my $file, '<', '../input.txt') or die "Could not open input file $!";
my $line = <$file>;
close($file);
chomp($line);
my @stones = split / /, $line;

for my $i (1..25) {
    @stones = iterate(@stones);
}

my $len = scalar(@stones);
print "$len\n";