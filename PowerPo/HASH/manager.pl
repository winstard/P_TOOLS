#! perl

use threads;
use Thread::Semaphore;

$0 =~ /(.+)\\.+/;  
my $CurrentPath = $1;
$0 =~ /.+\\(.+)/;
my $CurrentFile = $1;
print "$CurrentPath\\$CurrentFile\n";
push(@INC, $CurrentPath);
require "hash.pl";

my $Max_Str_Len = 0;
my $Min_Str_Len = 0;

my $Threads_Num = 4;
my $Semaphore = new Thread::Semaphore($Threads_Num);
sub Hash_Config()
{
	(my $Hash_Item, my $Hash_Module) = @_;
	print "Hash_Item[@$Hash_Item], Hash_Module[$Hash_Module]\n";
	
	&Set_CHAR_Item($Hash_Item, $Hash_Module);
}

sub Calc_Count()
{
	my $i = 0;
	my $Count = 0;
	my $Item_Count = &Get_Item_Count();
	print "Item_Count $Item_Count\n";
	for($i = $Min_Str_Len; $i <= $Max_Str_Len; $i++)
	{
		$Count += $Item_Count ** $i;
		print "Count $Count\n";
		print "Min_Str_Len $Min_Str_Len\t Max_Str_Len $Max_Str_Len\n";
	}
	
	return $Count;
}

sub Calc_Start_Num()
{
	my $Item_Count = &Get_Item_Count();
	
	return ( $Item_Count ** ($Min_Str_Len - 1));
}

sub Set_Str_Len()
{
	(my $Min_Len, my $Max_Len) = @_;
	
	if ($Max_Len < $Min_Len ||
		$Min_Len < 0)
	{
		print "error params in Set_Str_Len\n";
		return undef;
	}
	
	$Max_Str_Len = $Max_Len;
	$Min_Str_Len = $Min_Len;	
}

sub Multiple_Hash()
{
	(my $IntStart, my $Count, my $Dst, my $ID, my $Semaphore) = @_;
	
	my $i = 0;
	$Semaphore->down();
	for($i = 0; $i < $Count; $i++)
	{
		my $Int_Tmp = $IntStart + $i;
		my $Src_Str = &Int_to_ItemStr($Int_Tmp);
		my $Src = &Simple_Hash($Src_Str);
		if (&$Dst($Src))
		{
			print "##############################\n";
			print "$ID $Int_Tmp $Src_Str => Success\n";
			$Semaphore->up();
			return 1;
		}
	}
	$Semaphore->up();
	return undef;
}

sub Main()
{
	(my $Conf) = @_;
	my $Hash_Config_Tmp = %$Conf{"Hash_Config"};
	my $Hash_Module = %$Conf{"Hash_Module"};
	my $Min_Len = %$Conf{"Min_Len"};
	my $Max_Len = %$Conf{"Max_Len"};
	&Hash_Config($Hash_Config_Tmp, $Hash_Module);
	&Set_Str_Len($Min_Len, $Max_Len);
	
	my $Count = &Calc_Count();
	my $Start = &Calc_Start_Num();
	my $Dst = %$Conf{"Dst_Str"};
	my $i = 0;
	print "Min_Len $Min_Len\n";
	print "Max_Len $Max_Len\n";
	print "Start $Start\n";
	print "Count $Count\n";
	if ($Count >= ($Threads_Num))
	{
		my @Thread;

		my $Count_Tmp = int($Count / ($Threads_Num ** ($i + 1)));
		for ($i = 0; $i < ($Threads_Num - 1); $i++)
		{			
			my $Start_Tmp = $Start + $i * $Count_Tmp;
			$Thread[$i] = threads->new(\&Multiple_Hash, $Start_Tmp, $Count_Tmp, $Dst, $i, $Semaphore);
		}
		
		my $Start_Last = $Start + $i * $Count_Tmp;
		my $Count_Last = $Count - $i * $Count_Tmp;
		$Thread[$i] = threads->new(\&Multiple_Hash, $Start_Last, $Count_Last, $Dst, $i, $Semaphore);
		$i++;
		sleep(1);
		while ($i)
		{
			my $jj = 0;
			$Semaphore->down();
			#循环判断线程是否退出
			foreach my $SimThread(@Thread)
			{
				$jj ++;
				#线程句柄是否为空 / 是否已释放
				if ($SimThread)
				{
					#线程已完成
					if ($SimThread->is_joinable())
					{
						$i--;
						print "is_joinable\n";
						
						#线程结果
						if ($SimThread->join())
						{
							$SimThread = undef;
							last;
						}
						$SimThread = undef;
					}
				}
			}
			if ($jj < ($#Thread + 1))
			{
				print "jj $jj, Thread$#Thread\n";
				last;
			}
			print "haha\n";
		}
		
		#关闭所有线程
		foreach my $SimThread(@Thread)
		{
			if ($SimThread)
			{
				$SimThread->detach();
			}
		}
	}		
	else
	{
		&Multiple_Hash($Start, $Count, $Dst, 1, $Semaphore);
	}
}

my @Hash_Config = (0, 1, 2);
my $CallBack_Fun = \&Cmp_Str;
my %Config = (
	"Hash_Config" => \@Hash_Config,
	"Hash_Module" => "MD4",
	"Min_Len" => 4,
	"Max_Len" => 4,
	"Dst_Str" => $CallBack_Fun, #"as"
);

sub Cmp_Str()
{
	my $Src = $_[0];
	if ($Src =~ /^feb2320b786cfb90a3190d6dfc5e66a7/)
	{
		return 1;
	}
	return undef;
}

&Main(\%Config);