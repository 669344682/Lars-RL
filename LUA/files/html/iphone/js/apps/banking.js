/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

function bankingSwitchTab(what) {
	$('#bankTransactionsCont').css('display', 'none');
	$('#bankSendCont').css('display', 'none');
	$('#bankPrepaidCont').css('display', 'none');
	
	$('#tabPrepaid').attr('class', '');
	$('#tabSend').attr('class', '');
	$('#tabTransactions').attr('class', '');
	
	
	if (what == 'send') {
		$('#tabSend').attr('class', 'bTabActive');
		$('#bankingApp').css('background', 'url(images/appBgs/bankingSendBg.png) no-repeat center center');
		$('#bankSendCont').css('display', '');
		
	} else if (what == 'transactions') {
		$('#tabTransactions').attr('class', 'bTabActive');
		$('#bankingApp').css('background', 'url(images/appBgs/bankingTransactionsBg.png) no-repeat center center');
		$('#bankTransactionsCont').css('display', '');
		loadTransactions();
		
	} else if (what == 'prepaid') {
		$('#tabPrepaid').attr('class', 'bTabActive');
		$('#bankingApp').css('background', 'url(images/appBgs/bankingSendBg.png) no-repeat center center');
		$('#bankPrepaidCont').css('display', '');
	}
}



function loadTransactions() {
	AJAXcall({action:"getBankData"}, function(){});
}

function bankDataCallback(data) {
	var json = atob(data);
	json = $.parseJSON(json);
	
	$('#curBankMoney').html(json['money_formated']+" $");
	
	$('#bankTransactions').html('');
	$.each(json['transactions'], function(i, arr) {
		$('#bankTransactions').append('<li>\
			<div class="item-content">\
				<div class="item-inner">\
					<span style="float:left;width:70%;">'+decodeURIComponent(escape(arr['reason']))+'<br><small>'+arr['date']+'</small></span>\
					<span style="float:right;width:30%;color:'+((arr['sum']>0) ? 'green' : 'red')+';text-align:right;">\
						'+arr['sum_readable']+' <b>'+((arr['sum']>0) ? '+' : '-')+'</b>\
					</span>\
				</div>\
			</div>\
		</li>');
	});
}

function transferMoney() {
	var receiver	= $('#transactionReceiver').val();
	var sum			= $('#transactionSum').val();
	var reason		= $('#transactionReason').val();
	
	if (receiver.length >= 3 && sum > 0 && reason.length >= 3) {
		AJAXcall({action:"transferMoney",sum:sum,receiver:receiver,reason:reason}, function(){});
		$('#transactionReceiver').val('');
		$('#transactionSum').val('');
		$('#transactionReason').val('');
	} else {
		myApp.alert('Du musst Empfänger, Summe und Verwendungszweck angeben.', 'Überweisung');
	}
}

function loadPrepaid() {
	var sum = $('#prepaidMoney').val();
	if (sum > 0) {
		AJAXcall({action:"loadPrepaid",sum:sum}, function(){});
	} else {
		myApp.alert('Wähle zuerst eine Summe aus.', 'Handyguthaben');
	}
}