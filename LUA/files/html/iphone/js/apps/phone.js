/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/


function phoneTabSwitch(what) {
	$('#phoneContent').css('display', 'none');
	$('#phoneInner').css('display', 'none');
	$('#phoneContactInner').css('display', 'none');
	$('#callContent').css('display', 'none');
	
	if (what == 'contacts') {
		$('#phoneContent').css('display', '');
		$('#phoneApp').css('background', 'url(images/appBgs/phoneContactBg.png) no-repeat center center');
		$('#phoneContactInner').css('display', '');
		
		$('#phoneMyName').html(MY_NAME);
		$('#phoneMyTel').html(MY_NUMBER);
		
		list = allOnlinePlayers;
		list.push('Guthaben Abfragen');
		list.push('Notruf');
		list = list.sort(function (a, b) {
			return a.localeCompare(b);
		});
		
		var put = '';
		var charArr = new Array();
		$.each(list, function(i, name) {
			if (!charArr[name.charAt(0).toLowerCase()]) {
				charArr[name.charAt(0).toLowerCase()] = true;
				put = put + '<li class="list-group-title">'+name.charAt(0).toUpperCase()+'</li>';
			}
			var o1 = "openApp('messages');setTimeout(function() { newSMS('"+name+"'); }, 750);";
			var o2 = "startCall('"+name+"');";
			var sms = ((name=='Notruf'||name=='Guthaben Abfragen') ? 'visibility:hidden;' : '');
			
			put = put + '<li>\
				<div class="item-content">\
					<div class="item-media"><i class="icon icon-form-name"></i></div>\
					<div class="item-inner">\
						<span style="float:left;width:75%;"><b>'+name+'</b></span>\
						<span style="width:25%;">\
							<i class="smsIcon" style="'+sms+'" onclick="'+o1+'"></i>\
							<i class="phoneIcon" onclick="'+o2+'"></i>\
						</span>\
					</div>\
				</div>\
			</li>';
		});
		
		$('#phoneContactsInner').html(put);
		
		
		firstGuideHelp("Kontakte welche Du hinzufügst, werden in Auswahllisten immer zuerst angezeigt.<br>So sparst Du dir das Scrollen in der Online-Liste.");
		
	} else if (what == 'phone') {
		$('#phoneContent').css('display', '');
		$('#phoneApp').css('background', 'url(images/appBgs/phoneBg.png) no-repeat center center');
		
		$('#phoneInner').css('display', '');
		
	} else if (what == 'call') {
		$('#callContent').css('display', '');
		
	}
}

var clickSound = false;
function phoneClick(what) {
	if (what == 'result') {
		alert('call me babe!');
		
	} else if (what == 'rmlast') {
		var nw = $('#phoneNumberInput').html();
		nw = nw.substr(0, nw.length - 1);
		$('#phoneNumberInput').html(nw);
		
	} else if (what == 'add') {
		alert('add me to contacts!');
			
	} else {
		if ($('#phoneNumberInput').html().length <= 16) {
			$('#phoneNumberInput').append(what);
		}
		
		var nr = what.toString().replace('#', 'r');
		nr = nr.replace('*', 's');
		clickSound = new Audio("sounds/tw"+nr+".ogg");
		clickSound.volume = CUR_VOLUME/100;
		clickSound.play();
	}
}

var timeTimer = false;
var curTime = 0;
var activeCall = false;
callScreenShowing = false;
canMinimizeCall = false;

var phoneAudio = false;
function clearPhoneAudio() {
	console.log('@clearPhoneAudio 1');
	if (phoneAudio != false) {
		console.log('@clearPhoneAudio 2');
		phoneAudio.pause();
		delete phoneAudio;
		phoneAudio = false;
	}
}

function startCall(_target) {
	if (activeCall == false && callScreenShowing == false) {
		
			
		if (_target == false) {
			var nr = $('#phoneNumberInput').html();
			if (nr.length > 0) {
				_target = nr;
			} else {
				return false;
			}
		}
		$('#phoneNumberInput').html('');
			
		if (_target != MY_NAME && _target != MY_NUMBER) {
			
			if (_target == '*100#' || _target == 'Guthaben Abfragen') {
				myApp.alert('Dein Prepaid-Guthaben beträgt '+String(SETTINGS['credit'])+' €.', 'Guthaben-Abfrage');
				
			} else if (_target.indexOf('*') >= 0 || _target.indexOf('#') >= 0 || _target.indexOf('+') >= 0) {
				myApp.alert('Dieser Service ist nicht vorhanden.', 'Fehler');
				
			} else {
				
				callScreenShowing = true;
				canMinimizeCall = false;
				
				AJAXcall({action:"startCall",target:_target});
				
				phoneTabSwitch('call');
				
				$('#callName').html(_target);
				$('#callSubtitle').html('Wählen');
				
				$('#incomingCallDecline').css('display', 'none');
				$('#incomingCallAccept').css('display', 'none');
				$('#outgoingCallDecline').css('display', '');
			}
			
		} else {
			myApp.alert("Du kannst dich nicht selbst Anrufen.", 'Fehler');
		}
		
	} else {
		myApp.alert("Du hast bereits einen aktiven Anruf.", 'Fehler');
	}
}


phoneAudio = false;
function startCallCallback(ret) {
	if (CUR_APP != 'phone') {
		openApp('phone');
		phoneTabSwitch('call');
	}
	
	clearInterval(timeTimer);
	curTime = 0;
	activeCall = false;
	callScreenShowing = true;
	canMinimizeCall = false;
	var closeIT = false;
	
	clearPhoneAudio();
	if (ret == 'calling') {
		$('#callSubtitle').html('Anrufen');
		phoneAudio = new Audio('sounds/wait_character.ogg');
		phoneAudio.volume = CUR_VOLUME/100;
		phoneAudio.loop = true;
		phoneAudio.play();
		
	} else if (ret == 'besetzt') {
		$('#callSubtitle').html('Besetzt');
		closeIT = true;
		phoneAudio = new Audio('sounds/busy.ogg');
		phoneAudio.volume = CUR_VOLUME/100;
		phoneAudio.loop = true;
		phoneAudio.play();
		
	} else if (ret == 'handyoff') {
		$('#callSubtitle').html('Nicht erreichbar');
		closeIT = true;
		phoneAudio = new Audio('sounds/no_connection.ogg');
		phoneAudio.volume = CUR_VOLUME/100;
		phoneAudio.loop = true;
		phoneAudio.play();
		
	} else if (ret == 'notarget') {
		$('#callSubtitle').html('Kein Anschluss');
		closeIT = true;
		/*phoneAudio = new Audio('sounds/no_connection.ogg');
		phoneAudio.volume = CUR_VOLUME/100;
		phoneAudio.loop = true;
		phoneAudio.play();*/
		
	} else if (ret == 'stopped') {
		$('#callSubtitle').html('Aufgelegt');
		closeIT = true;
		
	} else if (ret == false || ret == "false") {
		$('#callSubtitle').html('Abgelehnt');
		closeIT = true;
		
	} else if (ret == "nomoney") {
		$('#callSubtitle').html('Kein Guthaben');
		closeIT = true;
	
	} else if (ret == true || ret == "true") {
		$('#callSubtitle').html('Verbunden (0:00)');
		activeCall = true;
		canMinimizeCall = true;
		
		timeTimer = setInterval(function() {
			if (activeCall) {
				curTime = curTime + 1;
				var fix = ('0' + parseInt(curTime / 60, 10)).slice(-2)+':'+('0' + parseInt(curTime % 60)).slice(-2);
				$('#callSubtitle').html('Verbunden ('+fix+')');
			} else {
				clearInterval(timeTimer);
			}
		}, 1000);
	}
	
	
	if (closeIT) {
		AJAXcall({action:"toggleRingtone",bool:0});
		
		$('#callSubtitle').attr('class', 'blink_me');
		$('#incomingCallDecline').css('display', 'none');
		$('#incomingCallAccept').css('display', 'none');
		$('#outgoingCallDecline').css('display', 'none');
		
		setTimeout(function() {
			clearPhoneAudio();
			$('#callSubtitle').attr('class', '');
			phoneTabSwitch('phone');
			callScreenShowing = false;
			canMinimizeCall = true;
			activeCall = false;
		}, 4000);
	}
}

var autoStopCall = false;
function receiveCall(from) {
	AJAXcall({action:"toggleRingtone",bool:1});
	
	autoStopCall = setTimeout(function() {
		answerCall(0);
		clearPhoneAudio();
	}, 30000);
	
	
	openApp('phone');
	phoneTabSwitch('call');
	
	$('#callName').html(from);
	$('#callSubtitle').html('Eingehender Anruf');
	
	$('#incomingCallDecline').css('display', '');
	$('#incomingCallAccept').css('display', '');
	$('#outgoingCallDecline').css('display', 'none');
	
	callScreenShowing = true;
	canMinimizeCall = false;
}
function answerCall(_bool) {
	clearInterval(timeTimer);
	curTime = 0;
	activeCall = false;
	
	clearPhoneAudio();
	if (_bool == 1) {
		startCallCallback(true);
		
		$('#incomingCallDecline').css('display', 'none');
		$('#incomingCallAccept').css('display', 'none');
		$('#outgoingCallDecline').css('display', '');
		
	} else {
		
		$('#incomingCallDecline').css('display', 'none');
		$('#incomingCallAccept').css('display', 'none');
		$('#outgoingCallDecline').css('display', 'none');
		
		$('#callSubtitle').html('Aufgelegt');
		$('#callSubtitle').attr('class', 'blink_me');
		setTimeout(function() {
			$('#callSubtitle').attr('class', '');
			phoneTabSwitch('phone');
			
			callScreenShowing = false;
			canMinimizeCall = true;
		}, 3000);
	}
	
	clearTimeout(autoStopCall);
	AJAXcall({action:"toggleRingtone",bool:0});
	
	AJAXcall({action:"answerCall",bool:_bool});
}
