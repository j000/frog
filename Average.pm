#!/usr/bin/env perl

use v5.24.0;

package Average;

sub new {
	my $class = shift;
	my $self = {
		_count => 0,
		_avg => 0.0,
	};
	bless $self, $class;
	return $self;
}

sub add {
	my $self = shift;
	my $current = shift;
	$self->{_count} += 1;
	$self->{_avg} += ($current - $self->{_avg}) / $self->{_count};
}

sub value {
	my $self = shift;
	return $self->{_avg};
}

sub count {
	my $self = shift;
	return $self->{_count};
}

1;
