/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

function calcClick(what) {
	var resTxt	= $('#calculatorResult').html();
	var resNr	= Number($('#calculatorResult').html());
	var calcHist = $('#calculatorHistory').html();
	
	if (what == 'result') {
		if (resNr != 0) {
			$('#calculatorHistory').html(calcHist+resTxt);
			$('#calculatorResult').html('');
		}
		
		var r = $('#calculatorHistory').html();
		if (r.indexOf('%') > 0) {
			if (r.lastIndexOf("-") > 0) {
				var rp = r.substring(r.lastIndexOf("-")+1,r.lastIndexOf("%"));
				
				var rx = r.replace('-'+rp+'%', '');
				var res = 0;
				eval('res = '+rx+';');
				
				r = res+'*'+rp+'/100';
				eval('r = '+r+';');
				var r = res+'-'+r;
				
			} else if (r.lastIndexOf("+") > 0) {
				var rp = r.substring(r.lastIndexOf("+")+1,r.lastIndexOf("%"));
				
				var rx = r.replace('+'+rp+'%', '');
				var res = 0;
				eval('res = '+rx+';');
				
				r = r.replace('+'+rp+'%', '+(('+res+'/100)*'+rp+')'); 
			}
			
		}
		
		var result = 'NaN';
		eval('result = '+r+';');
		if (result >= 0) {
			$('#calculatorResult').html(result);
		} else {
			$('#calculatorResult').html('ERROR');
		}
		$('#calculatorHistory').html('');
		
		
	} else if (typeof what === 'number') {
		if (resTxt == '0') { resTxt = ''; }
		if (resTxt.length < 9) {
			$('#calculatorResult').html(resTxt+what);
		}
		
	} else if (what == false) {
		if (resTxt == '0') {
			$('#calculatorHistory').html('');
		}
		$('#calculatorResult').html('0');
		
	} else if (what == 'rmlast') {
		var nw = resTxt.substr(0, resTxt.length - 1);
		if (nw.length == 0) {
			nw = '0';
		}
		$('#calculatorResult').html(nw);
		
	} else if (what == 'invert') {
		var nr = resNr - (resNr*2);
		if (resNr >= 0) { nr = resNr * -1; }
		$('#calculatorResult').html(nr);
		
	} else if (what == '%' || what == '/' || what == '*' || what == '-' || what == '+') {
		var last = Number(resTxt.substr(resTxt.length - 1));
		if (typeof last === 'number' && (last % 1 === 0)) {
			$('#calculatorHistory').html(calcHist+resTxt+what);
			$('#calculatorResult').html('0');
		}
		
	} else if (what == '.') {
		var last = Number(resTxt.substr(resTxt.length - 1));
		if (typeof last === 'number' && (last % 1 === 0)) {
			$('#calculatorResult').html(resTxt+'.');
		}
		
	}
}
$('html').keypress(function(e) {
	if (CUR_APP == 'calculator' || CUR_APP == 'phone') {
		
		var chr = 'bla';
		var code = e.keyCode || e.which;
		if (code == 8) {
			chr = 'rmlast';
		} else if (code == 44 || code == 46) {
			chr = '.';
		} else if (code == 43) {
			chr = '+';
		} else if (code == 45) {
			chr = '-';
		} else if (code == 42 || code == 120) {
			chr = '*';
		} else if (code == 47) {
			chr = '/';
		} else if (code == 37) {
			chr = '%';
		} else if (code == 13) {
			chr = 'result';
		} else if (code >= 42 && code <= 57) {
			chr = code - 48;
		}
		
		if (chr != 'bla') {
			if (CUR_APP == 'calculator') {
				calcClick(chr);
			} else if (CUR_APP == 'phone') {
				if ((code >= 42 && code <= 57 && code != 45 && code != 46 && code != 44 && code != 47) || code == 8 || code == 13) {
					phoneClick(chr);
				}
			}
		}
	
	}
});
