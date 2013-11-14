#!/usr/bin/perl --

package main;

# -------------------------------------------------------
#    クラス＆モジュール定義
# -------------------------------------------------------

use class::writexml;
use class::sendmail;
use class::plab;
use class::constants;

use Email::Valid;

require "./module/mimew.pl";
require "./module/mimer.pl";

# -------------------------------------------------------
#    サブルーチン定義
# -------------------------------------------------------

sub callback_result_page {

	my $callback_string = $_[0];

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>";
	print "<html xmlns='http://www.w3.org/1999/xhtml'>";
	print "<head>";
	print "<meta http-equiv='Content-Type' content='text/html; charset=shift-jis' />";
	print "<title>メールマガジン配信システム 配信先メールアドレスの登録・解除画面の結果</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align=\"center\">";
	print "<p>&nbsp;</p>";
	print "<p>$callback_string</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}


sub callback_address_manage_page {

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>";
	print "<html xmlns='http://www.w3.org/1999/xhtml'>";
	print "<head>";
	print "<meta http-equiv='Content-Type' content='text/html; charset=shift_jis' />";
	print "<title>メールマガジン配信システム 配信先メールアドレスの登録・解除画面</title>";
	print "</head>";
	print "";
	print "<body>";
	print "";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>メールアドレスの登録・解除を行うことができます。</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/manage_address.pl'>";
	print "    <p>";
	print "      <input type='text' name='strEMailAddress' size='50' maxlength='50'/><br/>";
	print "    </p>";
	print "    <p>";
	print "      <input type='submit' name='btnSubmit' value='登録' />&nbsp;";
	print "      <input type='submit' name='btnSubmit' value='解除' />";
	print "    </p>";
	print "  </form>";
	print "  <p>このページは日光市・子育て支援課の委託により「特定非営利活動法人なんとなくのにわ」が運営しています</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub send_authentication_mail {

	my $address = $_[0];

	my $mail = new sendmail(
			constants::getMailMagazineSenderAddress,
			$address,
			mimeencode("メールアドレスの認証メールです。"),
			"\n".
			"なんとなくのにわメールマガジンの配信先として、".$address."が登録されました。\n".
			"メールマガジンの配信を希望されるのであれば、次のリンクをクリックし、\n".
			"メールアドレスを認証してください。\n".
			"\n".
			"http://".constants::getHostName."/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/authenticate_address.pl?mailaddress=".$address."\n".
			"\n"  );

	$mail->sendnew();

}

# -------------------------------------------------------
#    メイン処理
# -------------------------------------------------------

sub main {

	my %formdata = plab::getformdata();
	
	my $xmldoc = new writexml(constants::getMailAddressListWithPath);
	
	my $type = $formdata{"btnSubmit"};
	my $address = $formdata{"strEMailAddress"};

	if ($type eq "登録") {
		if (Email::Valid->address($address)) {
			if ($xmldoc->isAddressExists($address) eq "false") {
				$xmldoc->putAddress($address);
				&send_authentication_mail($address);
				&callback_result_page(
					"入力されたメールアドレスに認証メールを送信しました。<br/>".
					"メールクライアント(Outlook, Eudora)などを起動し、メールを受信してください。<br/>".
					"受信したメールの本文内のホームページアドレスをクリックしてください。");
			} else {
				&callback_result_page("入力されたメールアドレスは、既に登録されてるため登録できません。");
			}
		} else {
			&callback_result_page("入力された文字列は、メールアドレスの形式として正しくないようです。");
		}
	} else {
		if ($type eq "解除") {
			if ($xmldoc->isAddressExists($address) eq "true") {
				$xmldoc->delAddress($address);
				&callback_result_page("指示されたメールアドレスは、削除されました。");
			} else {
				&callback_result_page("指示されたメールアドレスは、登録されていません。");
			}
		} else {
			&callback_address_manage_page;
		}
	}

}

&main;

# -------------------------------------------------------

1;

