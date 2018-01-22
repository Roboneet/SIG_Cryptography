var format = '\\'+ 'x' + '__'

function add_padding(text, width){
	var n = calc_padding_width(text, width);
	var unit = generate_padding_unit(n);
	var str = text;
	for(var i = 0; i< n; i++){
		str += unit;
	}
	return str;
}

function calc_padding_width(text, width){
	var len  = text.length;
	
	var rem = len%width;
	
	return (rem)?(width - rem): rem;
}

function generate_padding_unit(n){
	return format.replace('__', ('0'+n.toString()).slice(-2));  //pseudo code
}

console.log(add_padding("YELLOW SUBMARINE", 20))