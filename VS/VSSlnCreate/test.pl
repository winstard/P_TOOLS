#! perl
push(@INC, "E:/practice/test");
require "VSSlnCreate/templt_sln.pl";
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
my @tmp = (
	{
		'SolutionProj_ID' => MakeProjID,
		'SolutionProj_Name' => 'KMGServer',
		'SolutionProj_Path' => 'KMGServer\KMGServer.vcproj',
		'SolutionProj_Guid' => MakeProjID
	},
	{
		'SolutionProj_ID' => '2150E333-8FDC-42A3-9474-1A3956D46DE8',
		'SolutionProj_Name' => 'Solution Items',
		'SolutionProj_Path' => 'Solution Items',
		'SolutionProj_Guid' => '4BB35295-85E0-4858-9D56-2179B84E3E99'
	}
);


$filenn = "> F:/a.sln";
my $text = &GetWholeSolution_Text(\@tmp);
open(SLN, $filenn) || die("Could not open file");

print SLN $text;
close(SLN);


print "password = ", &MakeProjID()