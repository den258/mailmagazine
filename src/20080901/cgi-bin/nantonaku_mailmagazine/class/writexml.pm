
package writexml;

use XML::DOM;
use Time::localtime;
use Time::Format qw(%time %strftime %manip);

sub new{

	# �Öق̂����Ɉ����n�����N���X�����󂯎��
	my $class = shift;
	
	# �����n�b�V���̃��t�@�����X���쐬
	my $self = {
		filename_with_path => @_,
	};

	# bless �����I�u�W�F�N�g���t�@�����X��Ԃ�
	return bless $self, $class;

}

sub getAddressList {

	my $self = shift;

	local @AddressList;

	my $dom_parser = new XML::DOM::Parser;
	my $doc = $dom_parser->parsefile( $self->{filename_with_path} );
	my $elements  = $doc->getElementsByTagName("emailaddress");	

	for (my $i = 0; $i < $elements->getLength; $i++) {

		local $address = $elements->item($i)->getAttribute("address");
		local $authentication = $elements->item($i)->getAttribute("authentication");

		if ($authentication eq "did") {
			push(@AddressList, $address);
		}

	}

	return @AddressList;

}

sub putAddress {

	my $self = shift;

	my ($Address) = @_;

	my $dom_parser = new XML::DOM::Parser;
	my $doc = $dom_parser->parsefile( $self->{filename_with_path} );
	my $root  = $doc->getDocumentElement("addresslist");
	my $element = $doc->createElement("emailaddress");

	$time{$format};
	$element->setAttribute("address", $Address);
	$element->setAttribute("timestamp", $time{'yyyy/mm/dd hh:mm:ss.mmm'});
	$element->setAttribute("authentication", "didn\'t");

	$root->appendChild($element);

	&writexml($self->{filename_with_path}, $doc->toString);

}

sub putAuthentication {

	my $self = shift;

	my ($argAddress) = @_;

	my $dom_parser = new XML::DOM::Parser;
	my $doc = $dom_parser->parsefile( $self->{filename_with_path} );
	my $elements  = $doc->getElementsByTagName("emailaddress");

	$returnvalue = "false";

	for (my $i = 0; $i < $elements->getLength; $i++) {

		my $element = $elements->item($i);
		my $address = $element->getAttributeNode("address")->getValue;

		if ($address eq $argAddress) {
			$auth = $element->getAttributeNode("authentication");
			$auth->setValue("did");
			$returnvalue = "true";
			last;
		}

	}

	&writexml($self->{filename_with_path}, $doc->toString);

	return $returnvalue;

}

sub isAddressExists {

	my $self = shift;

	my ($argAddress) = @_;

	my $dom_parser = new XML::DOM::Parser;
	my $doc = $dom_parser->parsefile( $self->{filename_with_path} );
	my $elements  = $doc->getElementsByTagName("emailaddress");	

	for (my $i = 0; $i < $elements->getLength; $i++) {

		my $element = $elements->item($i);
		my $address = $element->getAttribute("address");

		if ($address eq $argAddress) {
			return "true";
		}

	}

	return "false";

}

sub delAddress {

	my $self = shift;

	my ($argAddress) = @_;

	my $dom_parser = new XML::DOM::Parser;
	my $doc = $dom_parser->parsefile( $self->{filename_with_path} );
	my $elements  = $doc->getElementsByTagName("emailaddress");	

	for (my $i = 0; $i < $elements->getLength; $i++) {

		my $element = $elements->item($i);
		my $address = $element->getAttribute("address");

		if ($address eq $argAddress) {
			$element->getParentNode()->removeChild($element);
		}

	}

	&writexml($self->{filename_with_path}, $doc->toString);

}

sub writexml {

	my ($filepath, $docstring) = @_;

	# ������u�� XML �f�[�^�̐��`���s���B
	#    <emailaddress �̑O�� \t ��}������B�_�u��͏�������B
	#    /> �̌�� \n ��}������B�_�u��͏�������B
	$_ = $docstring;
	s/></>\n</g;
	s/<emailaddress/\t<emailaddress/g;
	s/\t\t/\t/g;

	open ( OUT, ">".$filepath );
	print  OUT $_;
	close( OUT );

}

return true;

1;

