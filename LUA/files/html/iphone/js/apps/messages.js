/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

var emoticons = {};
emoticons[':-)'] = '&#128515;';
emoticons[':)'] = '&#128515;';
emoticons['(:'] = '&#128515;';
emoticons['(-:'] = '&#128515;';

emoticons[':-('] = '&#128542;';
emoticons[':('] = '&#128542;';
emoticons['):'] = '&#128542;';
emoticons[')-:'] = '&#128542;';

emoticons[';-)'] = '&#128521;';
emoticons[';)'] = '&#128521;';

emoticons[':P'] = '&#128523;';

emoticons['^^'] = '&#128516;';

emoticons[':D'] = '&#128513;';

emoticons[";("] = '&#128531;';
emoticons[";-("] = '&#128531;';
emoticons[":'("] = '&#128531;';
emoticons[":'-("] = '&#128531;';


emoticons["X-("] = '&#128544;';
emoticons["X("] = '&#128544;';
emoticons[":-@"] = '&#128544;';
emoticons[":@"] = '&#128544;';
emoticons[">:("] = '&#128544;';

emoticons[':-*'] = '&#128536;';
emoticons[':*'] = '&#128536;';
emoticons[':x'] = '&#128536;';

emoticons[':|'] = '&#128528;';
emoticons[':-|'] = '&#128528;';

emoticons[':O'] = '&#128558;';
emoticons[':-O'] = '&#128558;';
emoticons[':o'] = '&#128558;';
emoticons[':-o'] = '&#128558;';
emoticons[':-0'] = '&#128558;';
emoticons['8o'] = '&#128558;';

emoticons["D-':"] = '&#128561;';
emoticons["D:<"] = '&#128561;';
emoticons["=O"] = '&#128561;';

emoticons[":-&"] = '&#128567;';
emoticons["+o("] = '&#128567;';
emoticons[":-###.."] = '&#128567;';
emoticons[":###.."] = '&#128567;';
emoticons["<X"] = '&#128567;';

emoticons["(:|"] = '&#128564;';
emoticons["=_="] = '&#128564;';
emoticons["%-/"] = '&#128564;';
emoticons["(=_=)"] = '&#128564;';
emoticons["||"] = '&#128564;';

emoticons[":/"] = '&#128533;';
emoticons[":-/"] = '&#128533;';

emoticons[":s"] = '&#128542;';
emoticons[":S"] = '&#128542;';

emoticons["X/"] = '&#128530;';

emoticons["8)"] = '&#128526;';
emoticons["8-)"] = '&#128526;';
emoticons["|;-)"] = '&#128526;';

emoticons["?("] = '&#128533;';
emoticons["%("] = '&#128533;';
emoticons["%-("] = '&#128533;';

emoticons["xD"] = '&#128514;';
emoticons["XD"] = '&#128514;';

emoticons["<3"] = '&#9829;';
emoticons["&#60;3"] = '&#9829;';

var smsData = null;
var currentOpenChat = false;
var currentOpenChatID = 0;
function showMessage(nr) {
	
	// clear and show default: message list
	$('#messageChat').css('display', 'none');
	$('#messageTextField').css('display', 'none');
	$('#messageScroll').css('margin-bottom', '0px');
	$('#newMessageContactList').css('display', 'none');
	$('#messageList').css('display', '');
	$('#messageBackLink').css('visibility', 'hidden');
	$('#messageNewLink').css('visibility', '');
	$('#messagesTitle').html('Nachrichten');
	$('#messageScroll').css('height', '438px');
	currentOpenChat = false;
	currentOpenChatID = 0;
	
	if (nr == 'new') {	//Create new Chat => Show player list
		$('#messageList').css('display', 'none');
		$('#messageBackLink').css('visibility', '');
		$('#messageNewLink').css('visibility', 'hidden');
		$('#newMessageContactList').css('display', '');
		$('#messagesTitle').html('Neue Nachricht');
		
		var put = '';
		$.each(allOnlinePlayers, function(k, v) {
			var alreadyConvOpen = false;
			$.each(smsData, function(i, arr) {
				if (arr['sender'] == v || arr['receiver'] == v) {
					alreadyConvOpen = true;
					return false;
				}
			});
			if (v != MY_NAME && alreadyConvOpen == false) {
				var fix = "newSMS('"+v+"');";
				put = put + '<li onclick="'+fix+'">\
					<div class="item-content">\
						<div class="item-media"><i class="icon icon-form-name"></i></div>\
						<div class="item-inner">\
							<span style="float:left;"><b>'+v+'</b></span>\
						</div>\
					</div>\
				</li>';
			}
		});
		$('#newMessageContactListInner').html(put);
		
		firstGuideHelp("In dieser Liste werden deine gespeicherten Kontakte und anschließend alle Online-Spieler angezeigt.<br>Spieler mit denen bereits eine Konversation besteht, werden hier nicht mehr aufgeführt.");
		
	} else if (typeof nr === 'number') {
		currentOpenChat = Number(nr);
		$('#messageList').css('display', 'none');
		$('#messageBackLink').css('visibility', '');
		$('#messageNewLink').css('visibility', 'hidden');
		$('#messageChat').css('display', '');
		//$('#messageScroll').css('margin-bottom', '35px');
		$('#messageScroll').css('height', '403px');
		$('#messageTextField').css('display', '');
		var name = $('#messagesChat-'+nr+' b').html();
		$('#messagesTitle').html(name);
		
		var cArr = smsData[nr];
		currentOpenChatID = Number(cArr['ID']);
		
		var put = '';
		$.each($.parseJSON(cArr['chat']), function(i, arr) {
			var whatIam = 'sender';
			if (cArr['receiver'].toLowerCase() == MY_NAME.toLowerCase()) {
				whatIam = 'receiver'
			}
			var fix = 'from';
			if (arr['from'] == whatIam) {
				var fix = 'to';
			}
			
			var msg = urldecode(arr['text']);
			$.each(emoticons, function(txt, uni) {
				msg = msg.replace(txt, uni); 
			});
			
			
			put = put+'<div class="message '+fix+'">'+msg+'</div>';
		});
		$('#messageChat').html(put);
		
		
		var box = document.getElementById('messageScroll');
		box.scrollTop = box.scrollHeight;
		
	}
}

function getIdFromConversationID(cID) {
	var id = 0;
	$.each(smsData, function(i, arr) {
		if (arr['ID'] == cID) {
			id = i
			return false;
		}
	});
	return id;
}

function receiveSMSData(data) {
	data = atob(data);
	var smsArr = $.parseJSON(data);
	smsData		= smsArr;
	if (smsArr != null && smsArr.length < 1) { return false; }
	
	
	var put = '';
	smsArr.sort(function(a, b) {
		var msgs1 = $.parseJSON(a['chat']);
		var lastMsg1 = msgs1[msgs1.length-1];
		var fix1 = 99999999999;
		if (lastMsg1) {
			fix1 = lastMsg1['time'];
		}
		
		var msgs2 = $.parseJSON(b['chat']);
		var lastMsg2 = msgs2[msgs2.length-1];
		var fix2 = 99999999999;
		if (lastMsg2) {
			fix2 = lastMsg2['time'];
		}
		
		return fix2 - fix1;
	});
	$.each(smsArr, function(i, item) {
		var partner = item["sender"];
		if (partner == MY_NAME) {
			partner = item['receiver'];
		}
		
		var msgs = $.parseJSON(item['chat']);
		var lastMsg = msgs[msgs.length-1];
		var date = '';
		if (lastMsg) {
			var dateNOW	= new Date();
			
			var dateSMS = new Date(lastMsg['time']*1000);
			
			
			date = (('0' + dateSMS.getDate()).slice(-2))+"."+(('0' + (dateSMS.getMonth() + 1)).slice(-2))+"."+dateSMS.getFullYear();
			if (dateNOW.getFullYear() == dateSMS.getFullYear() && dateNOW.getMonth() == dateSMS.getMonth() && dateNOW.getDate() == dateSMS.getDate()) {
				date = (('0' + dateSMS.getHours()).slice(-2))+":"+(('0' + dateSMS.getMinutes()).slice(-2));
			}
		}
		
		put = put+'<li id="messagesChat-'+i+'" onclick="showMessage('+i+');">\
			<div class="item-content">\
				<div class="item-media"><i class="icon icon-form-comment"></i></div>\
				<div class="item-inner" style="">\
					<span style="float:left; width:60%;"><b>'+partner+'</b></span>\
					<span style="text-align:right;float:right; width:40%; font-size:12px;">'+date+'</span>\
				</div>\
			</div>\
		</li>';
		
	});
	$('#messageListInner').html(put);
	
	if (currentOpenChatID > 0) { // reload open chat
		showMessage(getIdFromConversationID(currentOpenChatID));
	}
}

var SPAM = false;
function answerSMS() {
	if (SPAM) {
		return myApp.alert("Langsam, Freundchen!", 'Spam?');
	}
	//var txt = strip_tags($('#newSmsText').val());
	var txt = $('#newSmsText').val();
	txt = txt.replace("<\/", '&#60;&#47;');
	txt = txt.replace('<', '&#60;');
	txt = txt.replace('>', '&#62;');
	if (txt.length > 0 && currentOpenChatID > 0) {
		$('#newSmsText').val('');
		AJAXcall({action:"answerSMS",id:currentOpenChatID,msg:txt}, function(){});
		SPAM = true;
		setTimeout(function() {
			SPAM = false;
		}, 1000);
	}
}

function newSmsCallback(res) {
	if (res != false && res > 0) {
		var lastID = 0;
		$.each(smsData, function(i, arr) {
			lastID = i;
		});
		showMessage(lastID);
	}
}
function newSMS(to) {
	if (to.length > 0) {
		var alreadyConvOpen = "x";
		$.each(smsData, function(i, arr) {
			if (arr['sender'] == to || arr['receiver'] == to) {
				alreadyConvOpen = Number(i);
			}
		});
		
		if (alreadyConvOpen == "x") {
			AJAXcall({action:"newSMS",name:to}, function(){});
		} else {
			showMessage(alreadyConvOpen);
		}
	}
}

function loadSMS() {
	if (smsData == null) {
		AJAXcall({action:"loadSMS"}, function(){});
	}
}

function newSmsNotification(from, text, ID) {
	if (!(CUR_APP == 'messages' && currentOpenChatID == ID)) {
		myApp.addNotification({
			title: 'Neue SMS von '+from,
			message: urldecode(atob(text)),
			hold: 5000,
			closeOnClick: true,
			closeIcon:false,
			audio:true,
			onClose:(function() {
				openApp('messages');
				showMessage(getIdFromConversationID(ID));
			})
		});
	}
}