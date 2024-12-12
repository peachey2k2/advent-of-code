#!/usr/bin/perl
use strict;
use warnings;

sub increment {
    my ($map, $stone, $count) = @_;
    if (exists $map->{$stone}) {
        $map->{$stone} += $count;
    } else {
        $map->{$stone} = $count;
    }
}

sub iterate {
    my %current = @_;
    my %next = ();

    while (my ($stone, $count) = each %current) {
        my $len = length($stone);
        if ($stone+0 == 0) {
            increment(\%next, $stone+1, $count);
        } elsif ($len % 2 == 0) {
            increment(\%next, substr($stone, 0, $len/2)+0, $count);
            increment(\%next, substr($stone, $len/2)+0, $count);
        } else {
            increment(\%next, $stone*2024, $count);
        }
    }
    return %next;
}

open(my $file, '<', '../input.txt') or die "Could not open input file $!";
my $line = <$file>;
close($file);
chomp($line);
my @list = split / /, $line;

my %stones = ();
for my $stone (@list) {
    increment(\%stones, $stone, 1);
}

for my $i (1..75) {
    %stones = iterate(%stones);
}

my $accum = 0;
foreach my $count (values %stones) {
    $accum += $count;
}
print "$accum\n";