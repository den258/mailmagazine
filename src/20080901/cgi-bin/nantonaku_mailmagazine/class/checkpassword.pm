
package checkpassword;

use class::constants;
use XML::DOM;

sub isCorrectPassword {

	local $arg_evaluating_password = @_[0];
	local $dom_parser = new XML::DOM::Parser;
	local $doc = $dom_parser->parsefile( constants::getSettingFileWithPath );
	local $elements  = $doc->getElementsByTagName("password");	

	for (local $i = 0; $i < $elements->getLength; $i++) {

		local $correct_password = $elements->item($i)->getAttribute("value");

		if ($correct_password eq $arg_evaluating_password) {
			return "true";
		}

	}

	return "false";

}

return true;
