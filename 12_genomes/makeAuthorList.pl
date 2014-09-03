#!/usr/bin/perl -w

open (AUTHORS, "emailsauthorlist-affiliations-30-Sep-2007.txt");

my %firstnamesCorresponding;
my %affiliationsCorresponding;

while ($line = <AUTHORS>) {
	
	if ($line =~ /\#?(.+)\s(\S+)\t<\S+>\t(\S+)/) {
		$firstname = $1;
		$lastname = $2;
		$fullname = "$2 $1";
		$affiliation = $3;
		$firstnamesCorresponding{$fullname}= $firstname;
#		$lastnamesCorresponding{$fullname}= $lastname;
		$affiliationsCorresponding{$fullname}= $affiliation;

#		print "$firstname\t$lastname\t$affiliation\n";
	}
	
	elsif ($line =~ /#AUTHOR LIST/ ) {
		last;
	}
	
	else {
		#print "line does not match expression: \n$line\n"
	}
}

my %firstnames;
my %affiliations;

while ($line = <AUTHORS>) {
	
	if ($line =~ /\#?(.+)\s(\S+)\t<\S+>\t(\S+)/) {

		$firstname = $1;
		$lastname = $2;
		$fullname = "$2 $1";
		$affiliation = $3;
		$firstnames{$fullname}= $firstname;
		$lastnames{$fullname}= $lastname;
		$affiliations{$fullname}= $affiliation;

#		print "$firstname\t$lastname\t$affiliation\n";
	}

	
	else {
		#print "line does not match expression: \n$line\n"
	}
}

print "#AUTHORS FOR CORRESPONDENCE\n";
foreach $fullname (sort keys %firstnamesCorresponding) {
	print "$firstnamesCorresponding{$fullname}\t$affiliationsCorresponding{$fullname}\n";
}

print "\n#AUTHOR LIST\n";
foreach $fullname (sort keys %firstnames) {
	print "$firstnames{$fullname} $lastnames{$fullname}\t$affiliations{$fullname}\n";
}