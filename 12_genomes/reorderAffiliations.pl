#!/usr/bin/perl -w

open (AUTHORS, "authorlist-affiliations-30-Sep-2007.txt");
open (AFFILIATIONS, "affiliations-30-Sep-2007.txt");

my %affiliationCodes;
while ($line = <AFFILIATIONS>) {
	
	if ($line =~ /(\d+)\t(.+)$/) {

		$code = $1;
		$affiliation = $2;
		$affiliationCodes{$code}=$affiliation;
		
	}
	else {
		print "$line\n"
	}
	
}

my $counter=1;
my %seenAffiliations;

while ($line = <AUTHORS>) {
	
	if ($line =~ /(.+)\t(\S+)/) {

		$name = $1;
		$code = $2;
		
		if ($code =~ /(\d+),(\d+)/) {
			
			if (exists $seenAffiliations{$1} && exists $seenAffiliations{$2}) {
			
			}
			
			elsif (exists $seenAffiliations{$1} && ! exists $seenAffiliations{$2}) {
			
				$seenAffiliations{$2}=$counter;
				$counter++;
			
			}			
			
			elsif (! exists $seenAffiliations{$1} && exists $seenAffiliations{$2}) {
				
				$seenAffiliations{$1}=$counter;
				$counter++;
				
			}			
			
			else {
				$seenAffiliations{$1}=$counter;
				$counter++;
				$seenAffiliations{$2}=$counter;
				$counter++;
			}
			#print "$name\t$seenAffiliations{$1}".",$seenAffiliations{$2}\t$affiliationCodes{$1}\t$affiliationCodes{$2}\n";
			print "$name\t$seenAffiliations{$1}".",$seenAffiliations{$2}\n";

		}
		else {
			if (exists $seenAffiliations{$code}) {
			}
			else {
				$seenAffiliations{$code}=$counter;
				$counter++;
			}		
			#print "$name\t$seenAffiliations{$code}\t$affiliationCodes{$code}\n";
			print "$name\t$seenAffiliations{$code}\n";

		}

		#$affiliation = $affiliationCodes{$code};
		#print "$name\t$counter\t$affiliation\n";
		#$counter++;
	}
	else {
		print "$line\n"
	}
	
}

my %newAffiliations;
foreach $oldcode (sort keys %seenAffiliations) {
	$newAffiliations{$seenAffiliations{$oldcode}} = $affiliationCodes{$oldcode};
#	$string = "$seenAffiliations{$oldcode}\t$affiliationCodes{$oldcode}\n";
#	push (@not_sorted, $string);
	#print "$seenAffiliations{$oldcode}\t$affiliationCodes{$oldcode}\n";
	#print "$oldcode\t$seenAffiliations{$oldcode}\n";
}

#@sorted = sort { $a <=> $b } @not_sorted ;
#foreach $element (@sorted) {
#	print "$element";
#}	


print "\nAFFILIATIONS\n\n";
foreach $newcode (sort { $a <=> $b } keys %newAffiliations) {
	print "$newcode\t$newAffiliations{$newcode}\n"
	
#	$seenAffiliations{$oldcode}\t$affiliationCodes{$oldcode}\n";
	#print "$oldcode\t$seenAffiliations{$oldcode}\n";
}


