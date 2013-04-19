#!/usr/bin/env perl

use strict;
use warnings;
use XML::Simple;
use FindBin qw/$RealBin/;

# adaptec utilite
my $arcconf = "$RealBin/arcconf";

# get device id and SMART Attribute from command attribute
my ($id, $attribute) = @ARGV;
unless ($id) {
	print "Usage: $0 <device id> [SMART Attribute]\n\t" .
		"\tdefaut SMART Attribute - 0xE7";
}

# defaut SMART Attribute
$attribute = '0xE7' unless ($attribute);


my $xml;

# read GETSMARTSTATS
open ARC, "$arcconf GETSMARTSTATS 1 |" or die "Can't open process $arcconf: $!\n";
while (<ARC>) {
	next unless /^</;
	$xml .= $_;
}
close ARC;

# XML to hash
my $smart = XMLin($xml) or die "Can't read XML: $!\n";
print $smart->{PhysicalDriveSmartStats}->{$id}->{Attribute}->{$attribute}->{normalizedCurrent};
