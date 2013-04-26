#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw/$RealBin/;

my $config = '/etc/zabbix/zabbix_agentd.conf';
my $line = "UserParameter=ssdlive_num_,sudo $RealBin/ssdlive.pl _num_";

unless (-e $config) {
	my $c = '/etc/zabbix_agentd.conf';
	if (-e $c) {
		$config = $c;
	} else {
		die "Can't find zabbix config\n";
	}
}

unless ($ARGV[0]) {
	print "Usage: $0 <device num> [device num] [device num] ..\n";
	exit;
}

my $test = `cat $config`;
open CFG, ">>", $config or die "Can't open $config:$!\n";
print CFG "\n";

foreach (@ARGV) {
	my $l = $line;
	$l =~ s/_num_/$_/g;
	my ($ll) = split(/,/, $l);
	if ($test =~ /$ll/) {
		print "$ll exist in config\n";
		exit;
	}
	print CFG $l . "\n";
}
close CFG;

open SUDO, ">> /etc/sudoers" or die "Can't open sudoers file: $!\n";
print SUDO "\n# For zabbix SSD monitoring\n";
print SUDO "zabbix ALL=(ALL) NOPASSWD: /usr/local/share/adaptec/ssdlive.pl\n";
close SUDO;

