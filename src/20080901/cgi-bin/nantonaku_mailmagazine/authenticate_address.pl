#!/usr/bin/perl --

package main;

# -------------------------------------------------------
#    �N���X�����W���[����`
# -------------------------------------------------------

use class::writexml;
use class::plab;
use class::constants;

# -------------------------------------------------------
#    �T�u���[�`����`
# -------------------------------------------------------

sub callback_authentication_result_page {

	my $callbackmessage = $_[0];

	$\ = "\n"; ## �s�������̐ݒ�

	print "Content-type: text/html; charset=shift_jis\n\n";
	print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>";
	print "<html xmlns='http://www.w3.org/1999/xhtml'>";
	print "<head>";
	print "<meta http-equiv='Content-Type' content='text/html; charset=shift-jis' />";
	print "<title>���[���}�K�W���z�M�V�X�e�� ���[���A�h���X�F�؉�� �F�،���</title>";
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
#    ���C������
# -------------------------------------------------------

sub main {

	my %formdata = plab::getformdata();

	my $xmldoc = new writexml(constants::getMailAddressListWithPath);

	my $mailaddress = $formdata{"mailaddress"};

	my $callbackmessage = "";
	if( $xmldoc->putAuthentication($mailaddress) eq "true" ) {
		$callbackmessage = "�F�؂���܂����B";
	} else {
		$callbackmessage = "�F�؂���܂���ł����B";
	}

	&callback_authentication_result_page($callbackmessage);

}

&main;

# -------------------------------------------------------
