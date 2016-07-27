#!/usr/bin/perl

# Takes a nucleotide sequence, a oligonucleotide size and a Tm value and reports the oligonucleotides with the given(or higher) Tm values. Employs oligotm of Primer3 and BioPerl.
# Useful when designing primers with specific Tm values.

use strict;
use warnings;
use Bio::SeqIO;

# get the name of the fasta file
my $fastafile = shift;

print "primer length:\t";
my $primerlength = <>;

print "target Tm:\t";
my $targettm = <>;

my $input = Bio::SeqIO->new(
                            -file   => $fastafile,
                            -format => 'Fasta',
                            );
                                                    
                                                       
while (my $query = $input->next_seq) {
	my $processcount = 0;
	my $querytitle = $query->id;
	my $querylength = $query->length;
	my $subseqstart = 0;
	my $subseqend = 0;
		while ($processcount <= $querylength-$primerlength) {
			$processcount++;
			my $subseqstart = $processcount; 
			my $subseqend = $subseqstart+$primerlength-1;
			my $seqstr = $query->subseq($subseqstart,$subseqend);
			my $tm=`oligotm -tp 1 -sc 1 $seqstr`;
				if ($tm >= $targettm) {
					print "$querytitle\t$subseqstart\t$subseqend\t$seqstr\t$tm\n";
	 	}
	 }	
}
