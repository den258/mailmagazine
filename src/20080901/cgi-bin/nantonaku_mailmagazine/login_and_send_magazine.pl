#!/usr/bin/perl --

package main;

# -------------------------------------------------------
#    �N���X��`
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
#    �T�u���[�`����`
# -------------------------------------------------------

sub callback_login_page {

	my $callback_massage = $_[0];

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>���[���}�K�W���z�M�V�X�e���@���O�C�����</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>�p�X���[�h����͂��āA���O�C�����Ă�������</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/login_and_send_magazine.pl'>";
	print "    <p>$callback_massage</p>";
	print "    <p><input type='password' name='strPassword' size='30' maxlength='30'/></p>";
	print "    <p><input type='submit' value='���O�C��' /></p>";
	print "  </form>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub callback_login_success_page {

	my $sessionid = @_[0];

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>���[���}�K�W���z�M�V�X�e���@�z�M���[���쐬���</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>�z�M����{������͂��A�m�F�{�^���������Ă��������B</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/login_and_send_magazine.pl'>";
	print "  <table width='760' border='0'>";
	print "    <tr>";
	print "      <td width='40'></td>";
	print "      <td width='720'></td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>����:</td>";
	print "      <td style='text-align: left;'><input type='text' name='strSubject' size='125' maxlength='125' /></td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>�{��:</td>";
	print "      <td style='text-align: left;'><textarea name='strContent' cols='90' rows='25'></textarea></td>";
	print "    </tr>";
	print "  </table>";
	print "    <p>";
	print "      <input type='hidden' name='strSessionId' value='$sessionid' />";
	print "      <input type='submit' value='�m�F' />";
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

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>���[���}�K�W���z�M�V�X�e���@�z�M���[���m�F���</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>���M�{�^���������Ă��������B</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/login_and_send_magazine.pl'>";
	print "  <table width='760' border='1'>";
	print "    <tr>";
	print "      <td width='40'></td>";
	print "      <td width='720'></td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>����:</td>";
	print "      <td style='text-align: left; vertical-align: top;'>$subject</td>";
	print "    </tr>";
	print "    <tr>";
	print "      <td style='text-align: left; vertical-align: top;'>�{��:</td>";
	print "      <td style='text-align: left; vertical-align: top;'><pre>$content</pre></td>";
	print "    </tr>";
	print "  </table>";
	print "    <p>";
	print "      <input type='hidden' name='strSessionId' value='$sessionid' />";
	print "      <input type='submit' value='���M' />";
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

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>���[���}�K�W���z�M�V�X�e���@���[���}�K�W���z�M�������</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>���[���}�K�W����z�M���܂����B</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub callback_should_login_page {

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
	print "<html>";
	print "<head>";
	print "  <meta http-equiv='Content-Type' content='text/html; charset=shift_jis'>";
	print "  <title>���[���}�K�W���z�M�V�X�e���@���O�C���G���[���</title>";
	print "</head>";
	print "";
	print "<body>";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>���O�C�����Ă��������B</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}


# -------------------------------------------------------
#    ���C������
# -------------------------------------------------------

sub main {

	my %formdata = plab::getformdata;

	## �t�H�[���f�[�^�̑ޔ�
	my $sessionid = $formdata{"strSessionId"};
	my $password = $formdata{"strPassword"};
	my $subject = $formdata{"strSubject"};
	my $content = $formdata{"strContent"};

	if ($sessionid eq "") {
		$sessionid = undef;
	}

	## �Z�b�V�����A���O�C�������������Ƃ�����Ԃ�ێ����邽�߂Ɏg�p����B
	my $cgi = new CGI;
	my $session = new CGI::Session(undef, $sessionid, {Directory=>'./session'});

	## ���O�C���y�[�W�̏ꍇ
	if ($password ne "") {

		if(checkpassword::isCorrectPassword($password) eq "true") {

			&callback_login_success_page($session->id);

		}else{

			&callback_login_page("�p�X���[�h���Ⴂ�܂��B");

		}

	## ���[�����M�m�F�y�[�W�̏ꍇ
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
