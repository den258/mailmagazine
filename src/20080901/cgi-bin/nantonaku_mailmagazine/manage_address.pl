#!/usr/bin/perl --

package main;

# -------------------------------------------------------
#    �N���X�����W���[����`
# -------------------------------------------------------

use class::writexml;
use class::sendmail;
use class::plab;
use class::constants;

use Email::Valid;

require "./module/mimew.pl";
require "./module/mimer.pl";

# -------------------------------------------------------
#    �T�u���[�`����`
# -------------------------------------------------------

sub callback_result_page {

	my $callback_string = $_[0];

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>";
	print "<html xmlns='http://www.w3.org/1999/xhtml'>";
	print "<head>";
	print "<meta http-equiv='Content-Type' content='text/html; charset=shift-jis' />";
	print "<title>���[���}�K�W���z�M�V�X�e�� �z�M�惁�[���A�h���X�̓o�^�E������ʂ̌���</title>";
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

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>";
	print "<html xmlns='http://www.w3.org/1999/xhtml'>";
	print "<head>";
	print "<meta http-equiv='Content-Type' content='text/html; charset=shift_jis' />";
	print "<title>���[���}�K�W���z�M�V�X�e�� �z�M�惁�[���A�h���X�̓o�^�E�������</title>";
	print "</head>";
	print "";
	print "<body>";
	print "";
	print "<div align='center'>";
	print "  <p>&nbsp;</p>";
	print "  <p>���[���A�h���X�̓o�^�E�������s�����Ƃ��ł��܂��B</p>";
	print "  <form action='/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/manage_address.pl'>";
	print "    <p>";
	print "      <input type='text' name='strEMailAddress' size='50' maxlength='50'/><br/>";
	print "    </p>";
	print "    <p>";
	print "      <input type='submit' name='btnSubmit' value='�o�^' />&nbsp;";
	print "      <input type='submit' name='btnSubmit' value='����' />";
	print "    </p>";
	print "  </form>";
	print "  <p>���̃y�[�W�͓����s�E�q��Ďx���ۂ̈ϑ��ɂ��u�����c�������@�l�Ȃ�ƂȂ��̂ɂ�v���^�c���Ă��܂�</p>";
	print "</div>";
	print "</body>";
	print "</html>";

}

sub send_authentication_mail {

	my $address = $_[0];

	my $mail = new sendmail(
			constants::getMailMagazineSenderAddress,
			$address,
			mimeencode("���[���A�h���X�̔F�؃��[���ł��B"),
			"\n".
			"�Ȃ�ƂȂ��̂ɂ탁�[���}�K�W���̔z�M��Ƃ��āA".$address."���o�^����܂����B\n".
			"���[���}�K�W���̔z�M����]�����̂ł���΁A���̃����N���N���b�N���A\n".
			"���[���A�h���X��F�؂��Ă��������B\n".
			"\n".
			"http://".constants::getHostName."/".constants::getCgiBinDerectory."/".constants::getMailmagazinePackageDerectory."/authenticate_address.pl?mailaddress=".$address."\n".
			"\n"  );

	$mail->sendnew();

}

# -------------------------------------------------------
#    ���C������
# -------------------------------------------------------

sub main {

	my %formdata = plab::getformdata();
	
	my $xmldoc = new writexml(constants::getMailAddressListWithPath);
	
	my $type = $formdata{"btnSubmit"};
	my $address = $formdata{"strEMailAddress"};

	if ($type eq "�o�^") {
		if (Email::Valid->address($address)) {
			if ($xmldoc->isAddressExists($address) eq "false") {
				$xmldoc->putAddress($address);
				&send_authentication_mail($address);
				&callback_result_page(
					"���͂��ꂽ���[���A�h���X�ɔF�؃��[���𑗐M���܂����B<br/>".
					"���[���N���C�A���g(Outlook, Eudora)�Ȃǂ��N�����A���[������M���Ă��������B<br/>".
					"��M�������[���̖{�����̃z�[���y�[�W�A�h���X���N���b�N���Ă��������B");
			} else {
				&callback_result_page("���͂��ꂽ���[���A�h���X�́A���ɓo�^����Ă邽�ߓo�^�ł��܂���B");
			}
		} else {
			&callback_result_page("���͂��ꂽ������́A���[���A�h���X�̌`���Ƃ��Đ������Ȃ��悤�ł��B");
		}
	} else {
		if ($type eq "����") {
			if ($xmldoc->isAddressExists($address) eq "true") {
				$xmldoc->delAddress($address);
				&callback_result_page("�w�����ꂽ���[���A�h���X�́A�폜����܂����B");
			} else {
				&callback_result_page("�w�����ꂽ���[���A�h���X�́A�o�^����Ă��܂���B");
			}
		} else {
			&callback_address_manage_page;
		}
	}

}

&main;

# -------------------------------------------------------

1;

