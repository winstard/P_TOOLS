#! perl

use strict;
use MIME::Base64;

$0 =~ /(.+)\\.+/;  
my $CurrentPath = $1;
$0 =~ /.+\\(.+)/;
my $CurrentFile = $1;
my $result = undef;
print "$CurrentPath\\$CurrentFile\n";

sub Hex2Str()
{
	my $HexDst = shift;
	
}

sub Decode()
{
	my $StrSrc = shift;
	my $filename = ">>".$CurrentPath.'\\'.$CurrentFile;
	open(DST, $filename) || die("Could not open file".$filename);
	print "filename $filename\n";
	my $StrDst = decode_base64($StrSrc);
	print DST "\n\n\$result =\":\\\n    $StrDst \";";
	
	close(DST);	
	unlink($filename);
}

sub Decode_Hex()
{
	my $StrSrc = shift;
	my $filename = ">>".$CurrentPath.'\\'.$CurrentFile;
	open(DST, $filename) || die("Could not open file".$filename);
	my $Dst = decode_base64($StrSrc);
	my @DDst = split(//, $Dst);	
	my $StrDst = undef;
	foreach my $Item(@DDst)
	{
		$StrDst .= sprintf("%02x", ord($Item));
	}

	print DST "\n\n\$result =\":\\\n    $StrDst \";";
	
	close(DST);	
	unlink($filename);
}

sub Encode()
{
	my $StrSrc = shift;
	my $filename = ">>".$CurrentPath.'\\'.$CurrentFile;
	open(DST, $filename) || die("Could not open file".$filename);
	
	my $StrDst = encode_base64($StrSrc);
	$StrDst =~ s/(\n)//eg;
	print DST "\n\n\$result =\":\\\n$StrDst \";";
	
	close(DST);	
	unlink($filename);
}

sub Encode_Hex()
{
	my $Src = shift;
	my $filename = ">>".$CurrentPath.'\\'.$CurrentFile;
	open(DST, $filename) || die("Could not open file".$filename);
	my @SSrc = split(//, $Src);
	if (0 != (@SSrc % 2))
	{
		die("Input string length isn't match\n");
	}
	my $SSrcLen = @SSrc / 2;
	my $I = 0;
	my $StrSrc = undef;
	while ($I < $SSrcLen)
	{
		my $Item = $SSrc[$I * 2].$SSrc[$I * 2 + 1];
		$I ++;
		$StrSrc .= chr(hex(int($Item)));
	}
	my $StrDst = encode_base64($StrSrc);
	$StrDst =~ s/(\n)//eg;
	print DST "\n\n\$result =\":\\\n$StrDst \";";
	
	close(DST);	
	unlink($filename);
}
my $Src = '1234';

&Encode($Src);
#&Decode($Src);
