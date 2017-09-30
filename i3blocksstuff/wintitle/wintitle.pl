#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

binmode(STDOUT, ":utf8");

my ($len, $ratio) = @ARGV;
$len = 40 if (not defined $len);
$ratio = '3:1' if (not defined $ratio);

my @ratio = split /:/, $ratio;

my $wtitle = `xdotool getactivewindow getwindowname`;
$wtitle = `echo "$wtitle" | iconv -f utf8 -t utf8`;
chomp $wtitle; chomp $wtitle;
if (length($wtitle) > $len) {
    my $begin = int($len * $ratio[0]/($ratio[0]+$ratio[1]));
    my $end = int($len * $ratio[1]/($ratio[0]+$ratio[1]));
    my $wtlen = length($wtitle);
    my ($wtbeg, $wtend) = (substr($wtitle, 0, $begin), substr($wtitle, $wtlen-$end, $wtlen-1));
    $wtitle = $wtbeg . '…' . $wtend; 
}
print $wtitle;
