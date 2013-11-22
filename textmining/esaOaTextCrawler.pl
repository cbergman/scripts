#!/usr/bin/perl

##########################
# Author: Casey M. Bergman
# esaOaTextCrawler.pl: A simple crawler to obtain Open Access full text 
# articles from journals published by the Ecological Society of America.
##########################
# Requires: HTML::TreeBuilder http://search.cpan.org/~jfearn/HTML-Tree-4.2/lib/HTML/TreeBuilder.pm
# Requires: HTML::FormatText http://search.cpan.org/~nigelm/HTML-Format-2.10/lib/HTML/FormatText.pm
##########################
# As of 5 Feb 2012, it is necessary to obtain permission to download ESA 
# content: http://www.esapubs.org/esapubs/permissions.htm
##########################
# Maximum number of permissible requests is 50 sessions every 10 minutes
##########################

use strict;
use warnings;
use HTML::TreeBuilder;
use HTML::FormatText;

my $esadirectory = "esa";

if (-d $esadirectory) { 
}
else { 
	`mkdir $esadirectory`;
}

if(!defined $ARGV[0]){
	print "Usage: esaOaTextCrawler.pl esa_journal\n";
	print "Help: esa_journal options are:\n";
	print "\tEcology: \'ecol\'\n"; 
	print "\tEcological monographs: \'emon\'\n";
	print "\tEcological applications: \'ecap\'\n";
	die "die: No ESA journal specified!\n";
}

#get journal name and download master table of contents
my $journal = $ARGV[0];
`wget http://www.esajournals.org/loi/$journal`;

#parse master TOC and get issue TOC
open (TOC, "$journal");
while(my $masterline = <TOC>) {
	if ($masterline =~ /(http:\/\/www.esajournals.org\/toc\/$journal\/\d+\/\d+)/) {
		my $issue = $1;
		print "getting $issue\n";
		`wget -q -O issue $issue`;
		
		#parse issue TOC and get OA articles
		open (ISSUE, "issue");
		while (my $issueline = <ISSUE>) {
			if ($issueline =~ /href="\/doi\/full\/(\S+)\/(\S+)\">Full/) {
				my $volume = $1;
				my $article = $2;
				$issueline = <ISSUE>;
				if ($issueline =~ /alt="open access"/) {
					print "http:\/\/www.esajournals.org\/doi\/full\/$volume\/$article\n";
				
					if ($article =~/\d\d-\d\d\d\d\.\d/) {
						`wget -O $article http:\/\/www.esajournals.org\/doi\/full\/$volume\/$article`;
						sleep 60;
						
						
						#parse article and output plain text 
						my $formatter = HTML::FormatText->new;
						my $tree = HTML::TreeBuilder->new;
						$tree->parse_file($article);					
						open TEMP, ">:utf8", "temp.txt";
						my $text = $formatter->format($tree);					
						print TEMP $text;
						close TEMP;
					
						#extract text between abstract and literature cited
						my $flag=0;
						open (TEMP, "temp.txt");
						open (OUT, ">$article.txt"); 
						while (my $textline = <TEMP>) {

							if ($textline =~ /^\s\s\sAbstract$/) {
								$flag=1;
							}

							if ($textline =~ /^\s\s\sLiterature Cited$/) {
								$flag=0;
							}
							
							if ($flag == 1) {
								print OUT $issueline;
							}

						}	
						close OUT;
						close TEMP;
						`mv $article.txt $esadirectory`;
						`mv $article $esadirectory`;
					}
				}
			}
		}
	}
}
