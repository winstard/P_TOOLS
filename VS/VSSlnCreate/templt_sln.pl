#! perl
my $SolutionVersion = "\
Microsoft Visual Studio Solution File, Format Version 10.00\
# Visual Studio 2008
";

my $SolutionText;

sub SolutionInsertProj
{
	(my $SolutionProj) = @_;
	my $SolutionProj_Tmp = 
"Project(\"{$SolutionProj->{SolutionProj_ID}}\") = \"$SolutionProj->{SolutionProj_Name}\", \"$SolutionProj->{SolutionProj_Path}\", \"{$SolutionProj->{SolutionProj_Guid}}\"
EndProject
";

	if ($SolutionProj->{SolutionProj_Path} =~ m/\.vcproj$/)
	{
		&SolunInsertGlobalSection_ProjectConfig($SolutionProj->{SolutionProj_Guid});
	}
	
	$SolutionText .= $SolutionProj_Tmp;
	
}

sub GetSolutionText()
{
	$SolutionText;
}

my $Global_Text = 
"Global";


my $GlobalSection_SoluntionConfig_Text = 
"\n\tGlobalSection(SolutionConfigurationPlatforms) = preSolution".
"\n\t\tDebug|Win32 = Debug|Win32".
"\n\t\tRelease|Win32 = Release|Win32";

sub SolunInsertGlobalSection_SoluntionConfig()
{
	(my $GlobalSection_SoluntionConfig_config) = @_;
	$GlobalSection_SoluntionConfig_Text;	
}

sub GetGlobalSection_SoluntionConfig()
{
	$GlobalSection_SoluntionConfig_Text .= 
	"\n\tEndGlobalSection";
	
	$GlobalSection_SoluntionConfig_Text;
}

my $GlobalSection_ProjConfig_Text = 
"\n\tGlobalSection(ProjectConfigurationPlatforms) = postSolution";

sub SolunInsertGlobalSection_ProjectConfig()
{
	(my $GlobalSection_SolutionProj_Guid) = @_;

	my $GlobalSection_Tmp = 
	"\n\t\t{$GlobalSection_SolutionProj_Guid}.Debug|Win32.ActiveCfg = Debug|Win32".
	"\n\t\t{$GlobalSection_SolutionProj_Guid}.Debug|Win32.Build.0 = Debug|Win32".
	"\n\t\t{$GlobalSection_SolutionProj_Guid}.Release|Win32.ActiveCfg = Release|Win32".
	"\n\t\t{$GlobalSection_SolutionProj_Guid}.Release|Win32.Build.0 = Release|Win32";
	
	$GlobalSection_ProjConfig_Text .= $GlobalSection_Tmp;
}

sub GetGlobalSection_ProjectConfig()
{
	$GlobalSection_ProjConfig_Text .=
	"\n\tEndGlobalSection";
	
	$GlobalSection_ProjConfig_Text;
}


my $GlobalSection_SolutionProperties_Text =
"\n\tGlobalSection(SolutionProperties) = preSolution";

sub SolutionInsertGlobalSection_SolutionProperties()
{
	(my $GlobalSection_SolutionProperties_Config) = @_;
	
	$GlobalSection_SolutionProperties_Text .= 
	"\n\t\tHideSolutionNode = FALSE";
	
	$GlobalSection_SolutionProperties_Text ;
}

sub GetGlobalSection_SolutionProperties()
{
	$GlobalSection_SolutionProperties_Text .=
	"\n\tEndGlobalSection";
	
	$GlobalSection_SolutionProperties_Text;
}

sub GetGlobal_Text()
{
	(my @GlobalSection_SolutionProj_Guids) = @_;
	{
		&SolunInsertGlobalSection_SoluntionConfig();
		$Global_Text .= &GetGlobalSection_SoluntionConfig();
	}
	
	{
		$Global_Text .= &GetGlobalSection_ProjectConfig();
	}
	
	{
		&SolutionInsertGlobalSection_SolutionProperties();
		$Global_Text .= &GetGlobalSection_SolutionProperties();
	}
	
	$Global_Text .= "\nEndGlobal";
}



sub GetWholeSolution_Text()
{
	(my $SolutionTmp) = @_;
	my $i = 0;
	my @Proj_Guids;
	my $SolutionText = $SolutionVersion;
	foreach $ProjTmp(@$SolutionTmp)
	{
		&SolutionInsertProj($ProjTmp);		
	}

	$SolutionText .= &GetSolutionText();
	
	$SolutionText .= &GetGlobal_Text();
	
	$SolutionText;
}
