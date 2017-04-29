#! perl

sub ReadFile()
{
	(my $FileContext, my $FilesPath) = @_;
	
	foreach my $FilePath(@$FilesPath)
	{
		open(SRC, $FilePath) || return("Could not open file $FilePath");
		
		push @$FileContext, <SRC>;
		close(SRC);
	}
}

sub WriteFile()
{
	(my $FilePath, my $FileContext) = @_;
	
	open(DST, ">$FilePath") || return("Could not open file $FilePath");
	
	foreach my $line(@$FileContext)
	{
		print DST $line;
	}
	close(DST);
}