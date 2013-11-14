
package sendmail;

use Net::SMTP;
use Net::POP3;
use Encode qw/decode encode/;

sub new{

	# 暗黙のうちに引き渡されるクラス名を受け取る
	my $class = shift;
	
	# 無名ハッシュのリファレンスを作成
	my $self = {
		from_address => shift,
		to_address => shift,
		subject => shift,
		body_plain_text => shift,
	};

	# bless したオブジェクトリファレンスを返す
	return bless $self, $class;

}

sub getdate {

	$ENV{'TZ'} = "JST-9";

	($sec,$min,$hour,$mday,$mon,$year,$wday) = localtime(time);

	@week = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
	@month = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	$d = sprintf("%s, %d %s %04d %02d:%02d:%02d +0900 (JST)",

	$week[$wday],$mday,$month[$mon],$year+1900,$hour,$min,$sec);

	return $d;

} 

sub sendnew {

	my $self = shift;

	$pop = Net::POP3->new(
		'ns2.noahnet.jp'
	);

	if($pop->login('satou_jun\@noahnet.jp', 'satou') >= 0) {
		$pop->quit;
	} 

	$smtp = Net::SMTP->new(
		"ns2.noahnet.jp"
	);

	$smtp->mail($self->{from_address});
	$smtp->to($self->{to_address});

	$smtp->data();
	$smtp->datasend("Date:".&getdate."\n");
	$smtp->datasend("From:".$self->{from_address}."\n");
	$smtp->datasend("To:".$self->{to_address}."\n");
	$smtp->datasend("Subject:".$self->{subject}."\n");
	$smtp->datasend("Content-Transfer-Encoding: 7bit\n");
	$smtp->datasend("Content-Type: text/plain;charset=\"iso-2022-jp\"\n\n");
	$smtp->datasend("\n");
	$smtp->datasend(encode('ISO-2022-JP', decode('shiftjis', $self->{body_plain_text}))."\n");
	$smtp->dataend();

	$smtp->quit;

}

return true;
