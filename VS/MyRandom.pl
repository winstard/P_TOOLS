#! perl

my $SimpleBaseStr = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9";

my $RandomTmp = 1;
sub MyRandom{
	my $password;
	my $_rand;
	my $password_length = $_[0];
    if (!$password_length) {
        $password_length = 10;
    }
	my @chars = split(" ", $SimpleBaseStr);
	
	for (my $i=0; $i < $password_length ;$i++) 
	{
		$_rand = int(rand 36);
		$password .= $chars[$_rand];
	}
	$RandomTmp = $password;
	return $password;
}