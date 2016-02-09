var temp = prompt("Please enter a temperature!");

var x = function tempconvert (input) {
	var reg = /\d+/;
	
	if (input.match('/f/i') !== null) {
		var fahr = input.match('/f/i')
	} else if  (input.match('/c/i') !== null){
		var cel = input.match('/c/i')
		var cel = cel.
	}
	alert(cel + fahr);



	if (fahr[0].toLowerCase() =='f') {
		return (input.match(reg)-32)/1.8;
	} else if (cel[0].toLowerCase() =='c') {
		  return (input.match(reg)*1.8)+32;
	} 
	else {
		 return "Please add either a C or F to your input string (e.g. 65F or 12C) "
	}

}

document.write(x(temp));