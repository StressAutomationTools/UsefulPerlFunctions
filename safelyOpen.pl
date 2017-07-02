use warnings;
use strict;

sub safelyOpen{
	#prevents files from getting overwritten by checking first if a file with the 
	#same name already exists. If it does, a warning will be printed and the 
	#program will exit.
	my $file = $_[0];
	if(-e $file){
		print $file." already exists.\n";
		print "To protect the file from being overwritten, the program will now exit.\n";
		exit;
	}
	elsif(not $file){
		print "No filename was provided.\n";
		print "As no file could be created, the program will now exit\n";
		exit;
	}
	else{
		open(my $filehandle, ">", $file) or print "File could not be opened.\n" and die;
		return $filehandle;
	}
}

sub safelyOpenDraft{
	#expected file name .*_d\d+\..*
	#prevents files from getting overwritten by checking first if a file with the 
	#same name already exists. If it does, the draft version will be incremented until
	#an available file is found
	my $file = $_[0];
	if($file =~ m/(.*_)d(\d+)(\..*)/i){
		my $start = $1;
		my $end = $3;
		my $version = $2;
		while(-e $start."d".$version.$end){
			$version++;
		}
		open(my $filehandle, ">", $start."d".$version.$end) or print "File could not be opened.\n" and die;
		return $filehandle;
	}
	else{
		print "File does not conform to nameing convention. File could not be opened.\n";
		print "As no file could be created, the program will now exit\n";
		exit;
	}
}

sub testSafelyOpen{
	#test case to validate sub works as expected.
	#my $fh = safelyOpen(""); #test case 1, no file name provided
	#my $fh = safelyOpen("/TestFile.txt"); #test case 2, writing to a protected area (should not be run as root)
	{#test case 3, open file, write line, try to overwrite file
		my $fh = safelyOpen("TestFile.txt"); 
		print $fh "First line in file\n";
		$fh = safelyOpen("TestFile.txt");
	}
}

sub testSafelyOpenDraft{
	my $fh = safelyOpenDraft("TestFile_d1.bdf");
	print $fh "Test1";
	$fh = safelyOpenDraft("TestFile_d1.bdf");
	print $fh "Test2";
	$fh = safelyOpenDraft("TestFile_D1.bdf");
	print $fh "Test3";
	$fh = safelyOpenDraft("TestFile_d1.bdf");
	print $fh "Test4";
	$fh = safelyOpenDraft("TestFile.bdf");
}

1;
