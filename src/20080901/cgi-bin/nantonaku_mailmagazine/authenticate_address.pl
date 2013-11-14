#!/usr/bin/perl --

package main;

# -------------------------------------------------------
#    クラス＆モジュール定義
# -------------------------------------------------------

use class::writexml;
use class::plab;
use class::constants;

# -------------------------------------------------------
#    サブルーチン定義
# -------------------------------------------------------

sub callback_authentication_result_page {

	my $callbackmessage = $_[0];

	$\ = "\n"; ## 行末文字の設定

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>";
	print "<html xmlns='http://www.w3.org/1999/xhtml'>";
	print "<head>";
	print "<meta http-equiv='Content-Type' content='text/html; charset=shift-jis' />";
	print "<title>メールマガジン配信システム メールアドレス認証画面 認証結果</title>";
	print "</head>";
	print "";
	print "<body>";
	print "  <div align='center'>";
	print "    <table width='571' border='0'>";
	print "      <tr>";
	print "        <td>";
	print "          <div align='center'>";
	print "            <p>$callbackmessage</p>";
	print "          </div>";
	print "        </td>";
	print "      </tr>";
	print "    </table>";
	print "  </div>";
	print "</body>";
	print "</html>";

}

# -------------------------------------------------------
#    メイン処理
# -------------------------------------------------------

sub main {

	my %formdata = plab::getformdata();

	my $xmldoc = new writexml(constants::getMailAddressListWithPath);

	my $mailaddress = $formdata{"mailaddress"};

	my $callbackmessage = "";
	if( $xmldoc->putAuthentication($mailaddress) eq "true" ) {
		$callbackmessage = "認証されました。";
	} else {
		$callbackmessage = "認証されませんでした。";
	}

	&callback_authentication_result_page($callbackmessage);

}

&main;

# -------------------------------------------------------
