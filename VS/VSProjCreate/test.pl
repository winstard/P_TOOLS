#! perl
push(@INC, "E:/practice/test");
require "VSProjCreate/templt_proj.pl";
require "MyRandom.pl";

sub MakeProjID()
{
	my $Proj_ID = MyRandom(8).
		"-".
		MyRandom(4).
		"-".
		MyRandom(4).
		"-".
		MyRandom(4).
		"-".
		MyRandom(12);
}
my %tmp = (

		'SolutionProj_ID' => MakeProjID,
		'SolutionProj_Name' => 'KMGServer',
		'SolutionProj_Path' => 'KMGServer\KMGServer.vcproj',
		'SolutionProj_Guid' => MakeProjID

);


$filenn = "> F:/";
my $text = &GetWholeProject_Text(\%tmp);
open(SLN, $filenn) || die("Could not open file");

print SLN $text;
close(SLN);


print "password = ", &MakeProjID()