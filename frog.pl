#!/usr/bin/env perl
use v5.24.0;

# load module from current dir
use File::Basename;
use lib dirname (__FILE__);
# load our module
use Average;

my $WIDTH = 10;
my $PRINT = 1000;

my $avg = new Average();
my $counter = 0;

say('0123456789A');
while(1) {
	$counter += 1;
	$counter = 0 if ($counter == $PRINT);

	my $location = $WIDTH;
	my $jumps_count = 0;
	while ($location > 0) {
		my $jump = 1 + int(rand($location));
		$jumps_count += 1;
		$location -= $jump;
		print('*'.' 'x($jump - 1)) if (!$counter);
	}
	$avg->add($jumps_count);
	printf('*   %d   Average: %.9f over %d tests'."\n", $jumps_count, $avg->value(), $avg->count()) if (!$counter);
}
