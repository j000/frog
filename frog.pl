#!/usr/bin/env perl
use v5.24.0;

# load module from current dir
use File::Basename;
use lib dirname (__FILE__);
# load our module
use Average;

use Parallel::ForkManager;

use constant WIDTH => 10;
use constant PRINT => 100_000;

sub simulate {
	my $flag = 1;
	my $avg = new Average();
	my $counter = 0;

	local $SIG{INT} = sub {
		$flag = 0;
	};

	say('0123456789A');
	while($flag) {
		$counter += 1;
		$counter = 0 if ($counter == PRINT);

		my $location = WIDTH;
		my $jumps_count = 0;
		while ($location > 0) {
			my $jump = int(rand($location));
			$jumps_count += 1;
			$location -= $jump + 1;
			print('*'.' 'x$jump) if (!$counter);
		}
		$avg->add($jumps_count);
		printf('*   %d   Average: %.9f over %d tests'."\n", $jumps_count, $avg->value(), $avg->count()) if (!$counter);
	}
	printf('Average: %.9f over %d tests'."\n", $avg->value(), $avg->count());
	return $avg;
}


my $forks = shift;
if ($forks) {
	print "Forking up to $forks at a time\n";
	my %results;
	my $pm = Parallel::ForkManager->new($forks);
	$pm->run_on_finish( sub {
		my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
		my $i = $data_structure_reference->{input};
		$results{$i} = $data_structure_reference->{result};
	});

	# ignore ctrl+c
	local $SIG{INT} = 'IGNORE';

	DATA_LOOP:
    foreach (1 .. $forks) {
        my $pid = $pm->start and next DATA_LOOP;
        my $res = simulate();
        $pm->finish(0, {
				result => $res,
				input => $_
			});
    }
    $pm->wait_all_children;

	my $sum = 0;
	my $count = 0;
	foreach my $i (keys %results) {
		$sum += $results{$i}->sum();
		$count += $results{$i}->count();
	}
	printf('Result: %.7f over %d iterations'."\n", $sum/$count, $count);
} else {
	simulate();
}
