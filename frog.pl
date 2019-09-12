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
	if ($counter == $PRINT) {
		$counter = 0;
	}

	my $location = $WIDTH;
	my $jumps_count = 0;
	while ($location > 0) {
		print('*') if (!$counter);
		my $jump = 1 + int(rand($location));
		$jumps_count += 1;
		$location -= $jump;
		print(' 'x($jump - 1)) if (!$counter);
	}
	$avg->add($jumps_count);
	print('*'.' 'x3) if(!$counter);
	print($jumps_count.' 'x3) if(!$counter);
	printf('Average: %.9f',$avg->value()) if(!$counter);
	say(' over '.$avg->count().' attempts') if(!$counter);
}
