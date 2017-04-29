#! perl
use Digest::SHA qw(sha1_hex sha224_hex sha256_hex sha384_hex sha512_hex);
use Digest::MD5 qw(md5_hex);
use Digest::MD4 qw(md4_hex);
use Digest::MD2 qw(md2_hex);
use Time::HiRes qw(time alarm sleep);
use strict;
use Switch;

my @CHAR_Item = undef;

my @CHAR_Item_Word_L = ('a', 'b', 'c', 'd', 'e', 'f', 'g',  
					   # 0    1    2    3    4    5    6
				        'h', 'i', 'j', 'k', 'l', 'm', 'n',  
				       # 7    8    9    10   11   12   13
				        'o', 'p', 'q', 'r', 's', 't',    
                       # 14   15   16   17   18   19
				        'u', 'v', 'w', 'x', 'y', 'z');
				       # 20   21   22   23   24   25
my @CHAR_Item_Word_B = ('A', 'B', 'C', 'D', 'E', 'F', 'G',  
				       # 26   27   28   29   30   31   32
				        'H', 'I', 'J', 'K', 'L', 'M', 'N',
				       # 33   34   35   36   37   38   39
				        'O', 'P', 'Q', 'R', 'S', 'T',    
				       # 40   41   42   43   44   45
				        'U', 'V', 'W', 'X', 'Y', 'Z');      
				       # 46   47   48   49   50   51  
my @CHAR_Item_Number = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9'); 
				       # 52   53   54   55   56   57   58   59   60   61
my @CHAR_Item_Symbol = ('`', '\'', ',', '~', '!', '@', '#', ' ', '$', '%', 
						'^', '&', '*', '(', ')', '-', '_', '+', '=', '[', 
						']', '{', '}', '"', '|', '\\', '<', '>', '.', '/', '?');					   

my $Item_Count = undef;

my $HASH_Module = undef;

sub Reset_CHAR_Item()
{
	@CHAR_Item = undef;
	$Item_Count = 0;
	$HASH_Module = 0;
}

sub Set_CHAR_Item()
{
	my $i = 0;
	if (2 != ($#_ + 1))
	{
		print "param num [".($#_+1)."] error\n";
		return undef;
	}
	my $ItemConf = $_[0];
	$HASH_Module = $_[1];
	print "HASH_Module$HASH_Module\n";
	print "ItemConf@$ItemConf\n";
	my $CCCount = @$ItemConf;
	print "CCCount$CCCount\n";
	for($i = 0; $i < (@$ItemConf); $i++)
	{
		my @Charry_Temp = undef;
		if (0 == @$ItemConf[$i])
		{
			@Charry_Temp = @CHAR_Item_Word_L;
			$Item_Count += @CHAR_Item_Word_L;
			print "CHAR_Item_Word_L\n";
		}
		if (1 == @$ItemConf[$i])
		{
			@Charry_Temp = @CHAR_Item_Word_B;
			$Item_Count += @CHAR_Item_Word_B;
			print "CHAR_Item_Word_B\n";
		}
		if (2 == @$ItemConf[$i])
		{
			@Charry_Temp = @CHAR_Item_Number;
			$Item_Count += @CHAR_Item_Number;
			print "CHAR_Item_Number\n";
		}
		if (3 == @$ItemConf[$i])
		{
			@Charry_Temp = @CHAR_Item_Symbol;
			$Item_Count += @CHAR_Item_Symbol;
			print "CHAR_Item_Symbol\n";
		}
		if (0 == $i)
		{
			@CHAR_Item = @Charry_Temp;
		}
		else
		{
			push @CHAR_Item, @Charry_Temp;
		}
	}
	$Item_Count;
	
}

sub Get_Item_Count()
{
	return $Item_Count;
}

# 为了方便外部for int 以及管理分片
sub Int_to_ItemStr()
{
	my $ItemInt = $_[0];
	if( 1 >= $Item_Count)
	{
		print "Item_Count is error [$Item_Count]\n";
		return undef;
	}
	#print "$CHAR_Item[61] $ItemInt  $Item_Count\n";
	my $ItemStr = undef;
	my $Res_Mod = 0;
	if ($ItemInt >= $Item_Count)
	{
		while($ItemInt >= ($Item_Count))
		{
			$Res_Mod = $ItemInt % $Item_Count;
			$ItemStr = $CHAR_Item[$Res_Mod] . $ItemStr;
			#print "ItemStr $ItemStr\n";
			$ItemInt = int($ItemInt/$Item_Count);
			#print "ItemInt $ItemInt\n";
		}
		if (0 != $ItemInt)
		{
			$ItemStr = $CHAR_Item[($ItemInt - 1) % $Item_Count] . $ItemStr;
		}		
	}
	else
	{
		$ItemStr = $CHAR_Item[$ItemInt % $Item_Count] . $ItemStr; 
	}
	#print "Last $ItemStr\n";
	return $ItemStr;
}

# 目测不需要,实现也蛮复杂,罢工
# sub ItemStr_to_Int()
# {
	# my @ItemStr = $_[0];
	# if ( 1 >= $Item_Count)
	# {
		# print "Item_Count is error [$Item_Count]\n";
		# return undef;
	# }
	
	# my $ItemInt = undef;
	
	# while($#ItemStr >= 0)
	# {
		# $ItemInt = @ItemStr[0] 
	# }
# }

sub Simple_Hash()
{
	my $Src = $_[0];
	my $Dst = undef;
	
	switch($HASH_Module)
	{
		case "SHA_1"
		{
			$Dst = sha1_hex($Src);
		}
		
		case "SHA_224"
		{
			$Dst = sha224_hex($Src);
		}
		
		case "SHA_256"
		{
			$Dst = sha256_hex($Src);
		}
		
		case "SHA_384"
		{
			$Dst = sha384_hex($Src);
		}
		
		case "MD5"
		{
			$Dst = md5_hex($Src);
		}
		
		case "MD4"
		{
			$Dst = md4_hex($Src);
		}
		
		case "MD2"
		{
			$Dst = md2_hex($Src);
		}
		
		else
		{
			print "unknown hash module\n";
		}
		sleep(0.001);
		
	}
	return $Dst;
}

1;
sub Test_Int2ItemStr()
{
	my @conf = (0, 1, 2);
	my $Modluehas = "SHA_1";
	
	&Set_CHAR_Item(\@conf, $Modluehas);
	print &Int_to_ItemStr(1907057)."\n";
	
}

# &Test_Int2ItemStr();
# my $Test = 0121;
# my $Re = &Int_to_ItemStr($Test);

# print "$Re\n";
# my $Res = &Simple_Hash($Re);
# print "$Res\n";