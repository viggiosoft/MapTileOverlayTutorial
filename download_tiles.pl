#!/usr/bin/perl -w

use lib '/Library/Perl/5.16';
use strict;
use LWP::UserAgent;
use Data::Dumper;

mkdir("tiles");

#&get_tiles([0..7],[0..7],3);
#&get_tiles([0..15],[0..15],4);
&get_tiles([0..31],[0..31],5);

##########

exit(0);

sub get_tiles() {
	my $x_ref = shift @_;
	my $y_ref = shift @_;
	my $z = shift;
	
	my $ua = LWP::UserAgent->new();
	if(not(-d "tiles/$z")) {
		mkdir "tiles/$z";
	}
	for my $x (@{$x_ref}) {
		if(not(-d "tiles/$z/$x")) {
			mkdir "tiles/$z/$x";
		}
		for my $y (@{$y_ref}) {
			my $url = "http://c.tile.openstreetmap.org/$z/$x/$y.png";
			print $url."\n";
			my $res = $ua->get($url);	
			if($res->code!=200) {
				print("Error loading $x/$y/$z\n");
				next;
			}
			open TILE,">tiles/$z/$x/$y.png";
			print TILE $res->decoded_content;
			close TILE;
		}
	}
}

