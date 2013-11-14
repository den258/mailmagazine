#!/usr/bin/perl --

package main;

# -------------------------------------------------------
#    クラス定義
# -------------------------------------------------------

use class::plab;
use class::checkpassword;
use class::writexml;
use class::sendmail;
use class::constants;

use CGI;
use CGI::Session;

require "./module/mimew.pl";
require "./module/mimer.pl";

# -------------------------------------------------------
#    サブルーチン定義
# -------------------------------------------------------

sub callback_login_page {

	my $callback_massage = $_[0];

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>メールマガジン配信システム　ログイン画面</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>パスワードを入力して、ログインしてください</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/login_and_send_magazine.pl'>";
	print "    <p>$callback_massage</p>";
	print "    <p><input type='password' name='strPassword' size='30' maxlength='30'/></p>";
	print "    <p><input type='submit' value='ログイン' /></p>";
	print "  </form>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub callback_login_success_page {

	my $sessionid = @_[0];

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>メールマガジン配信システム　配信メール作成画面</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>配信する本文を入力し、確認ボタンを押してください。</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/login_and_send_magazine.pl'>";
	print "  <table width='760' border='0'>";
	print "    <tr>";
	print "      <td width='40'></td>";
	print "      <td width='720'></td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>件名:</td>";
	print "      <td style='text-align: left;'><input type='text' name='strSubject' size='125' maxlength='125' /></td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>本文:</td>";
	print "      <td style='text-align: left;'><textarea name='strContent' cols='90' rows='25'></textarea></td>";
	print "    </tr>";
	print "  </table>";
	print "    <p>";
	print "      <input type='hidden' name='strSessionId' value='$sessionid' />";
	print "      <input type='submit' value='確認' />";
	print "    </p>";
	print "  </form>";
	print "  <p>&nbsp;</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub callback_confirm_mail_page {

	my $sessionid = @_[0];

	my $session = CGI::Session->new(undef, $sessionid, {Directory=>'./session'});
	my $subject = $session->param('strSubject');
	my $content = $session->param('strContent');

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>メールマガジン配信システム　配信メール確認画面</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>送信ボタンを押してください。</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/login_and_send_magazine.pl'>";
	print "  <table width='760' border='1'>";
	print "    <tr>";
	print "      <td width='40'></td>";
	print "      <td width='720'></td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>件名:</td>";
	print "      <td style='text-align: left; vertical-align: top;'>$subject</td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>本文:</td>";
	print "      <td style='text-align: left; vertical-align: top;'><pre>$content</pre></td>";
	print "    </tr>";
	print "  </table>";
	print "    <p>";
	print "      <input type='hidden' name='strSessionId' value='$sessionid' />";
	print "      <input type='submit' value='送信' />";
	print "    </p>";
	print "  </form>";
	print "  <p>&nbsp;</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub callback_send_mail_success_page {

	my $sessionid = @_[0];

	my $xmldoc = new writexml(constants::getMailAddressListWithPath);
	my @addresslist = $xmldoc->getAddressList;

	my $session = CGI::Session->new(undef, $sessionid, {Directory=>'./session'});
	my $subject = $session->param('strSubject');
	my $content = $session->param('strContent');
	$session->close;

	for ($i = 0; $i < @addresslist; $i++) {
		$mail = new sendmail(constants::getMailMagazineSenderAddress, @addresslist[$i], mimeencode($subject), $content);
		$mail->sendnew();
	}

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>メールマガジン配信システム　メールマガジン配信完了画面</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>メールマガジンを配信しました。</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub callback_should_login_page {

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>メールマガジン配信システム　ログインエラー画面</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>ログインしてください。</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}


# -------------------------------------------------------
#    メイン処理
# -------------------------------------------------------

sub main {

	my %formdata = plab::getformdata;

	## フォームデータの退避
	my $sessionid = $formdata{"strSessionId"};
	my $password = $formdata{"strPassword"};
	my $subject = $formdata{"strSubject"};
	my $content = $formdata{"strContent"};

	if ($sessionid eq "") {
		$sessionid = undef;
	}

	## セッション、ログインが成功したという状態を保持するために使用する。
	my $cgi = new CGI;
	my $session = new CGI::Session(undef, $sessionid, {Directory=>'./session'});

	## ログインページの場合
	if ($password ne "") {

		if(checkpassword::isCorrectPassword($password) eq "true") {

			&callback_login_success_page($session->id);

		}else{

			&callback_login_page("パスワードが違います。");

		}

	## メール送信確認ページの場合
	} elsif($subject ne "" && $content ne "")  {

		$session->expire('+1m');
		$session->param('strSubject', $subject);
		$session->param('strContent', $content);
		$session->close;

		if ($sessionid ne undef) {

			&callback_confirm_mail_page($sessionid);

		} else {

			&callback_should_login_page;

		}

	} else {

		my $session_subject = $session->param('strSubject');
		my $session_content = $session->param('strContent');

		if ($session_subject ne "" && $session_content ne "") {

			&callback_send_mail_success_page($sessionid);

		} else {

			&callback_login_page("");

		}

	}

}

&main;

# -------------------------------------------------------
