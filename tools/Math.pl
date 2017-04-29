#! perl

#全局数组
my @g_szArray = undef;
#数组个数
my $g_nCount = 0;
#和
my $g_nSum = 0;
#平均数
my $g_nAverage = 0;
#最大数
my $g_nMax = 0;
#最小数
my $g_nMin = 0;
#中位数
my $g_nMiddle = 0;
#标准差
my $g_nStandardDe = 0;
#方差
my $g_nVariance = 0;
#协方差
my $g_nCovariance = 0;

#多运算散列
my %g_hsMaths = ();

sub Math_Reset()
{
	#全局数组
	@g_szArray = undef;
	#数组个数
	$g_nCount = 0;
	#和
	$g_nSum = 0;
	#平均数
	$g_nAverage = 0;
	#最大数
	$g_nMax = 0;
	#最小数
	$g_nMin = 0;
	#中位数
	$g_nMiddle = 0;
	#标准差
	$g_nStandardDe = 0;
	#方差
	$g_nVariance = 0;
	#协方差
	$g_nCovariance = 0;
	
	%g_hsMaths = ();
}

sub Math_Init()
{
	(my $ArrayTmp) = @_;
	my $nMax = $ArrayTmp[0];
	my $nMin = $ArrayTmp[0];
	
	push @g_nArray, @$ArrayTmp;
	foreach $ArrayPos (@$ArrayTmp)
	{
		$g_nSum += $ArrayPos;
		$nMax = $_ if $_ > $nMax;
		$nMin = $_ if $_ < $nMin;
		
		$g_nCount++;
	}
	$g_nMax = $nMax;
	$g_nMin = $nMin;
}

sub Math_GetAverage()
{
	$g_nAverage = $g_nSum / $g_nCount;
}

sub Math_GetMiddle()
{
	$g_nMiddle = $g_nArray[$g_nCount / 2];
}

sub Math_GetMax()
{
	return $g_nMax;
}

sub Math_GetMin()
{
	return $g_nMin;
}

sub Math_GetSum()
{
	return $g_nSum;
}

sub Math_GetCount()
{
	return $g_nCount;
}

sub Math_GetStandardDe()
{

}

sub Math_GetVariance()
{
	
}

sub Math_GetCovariance()
{
	
}

sub Math_InsertHash()
{
	
}