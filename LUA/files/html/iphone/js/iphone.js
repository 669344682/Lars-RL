/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/



MY_NAME				= "";
API_AUTH				= "";
MY_NUMBER			= "TODO";
IPHONE_OPEN			= false;
SETTINGS			= {};
CUR_VOLUME			= 80;
FLIGHTMODE			= false;
CELLULAR			= 5;
LOADING				= false;
CUR_APP				= false;
DEFAULT_RADIOS		= {};
allOnlinePlayers	= {};
WEBSERVER_URL		= '';

myApp				= false; // Framework7


function alert(s) {
	return console.log(s);
}


/*** APPS ***/
var APPS = new Array();
APPS.push(
{
	title	: "Wetter",
	name	: "weather",
	dock	: false,
	script	: true,
},
{
	title	: "Notizen",
	name	: "notes",
	dock	: false,
	script	: false,
},
{
	title	: "Rechner",
	name	: "calculator",
	dock	: false,
	script	: true,
},
{
	title	: "Uhr",
	name	: "clock",
	dock	: false,
	script	: false,
	onclick	: "myApp.alert('todo');"
},

{
	title	: "Einstell.",
	name	: "settings",
	dock	: false,
	script	: true,
},
{
	title	: "Statistik",
	name	: "activity",
	dock	: false,
	script	: false,
	onclick	: "myApp.alert('todo');"
},
{
	title	: "Support",
	name	: "tips",
	dock	: false,
	script	: false,
	onclick	: "myApp.alert('todo');"
},
{
	title	: "Hilfe",
	name	: "tips",
	dock	: false,
	script	: false,
	onclick	: "AJAXcall({action:'browser',url:'"+encodeURI("https://wiki.skylinegaming.de/index.php?mobileaction=toggle_view_mobile")+"'});"
},


{
	title	: "Fahrzeuge",
	name	: "vehicles",
	dock	: false,
	script	: true,
},
{
	title	: "Home",
	name	: "home",
	dock	: false,
	script	: true,
},
{
	title	: "Banking",
	name	: "banking",
	dock	: false,
	script	: true,
},
{
	title	: "Premium",
	name	: "health",
	dock	: false,
	script	: false,
	onclick	: "myApp.alert('todo');"
},

{
	title	: "Franchise",
	name	: "franchise",
	dock	: false,
	script	: true,
},
{
	title	: "YouTube",
	name	: "youtube",
	dock	: false,
	script	: false,
	onclick	: "AJAXcall({action:'browser',url:'https://m.youtube.com/'});"
},
{
	title	: "DEV-TOOLS",
	name	: "settings",
	dock	: false,
	script	: false,
	onclick	: "AJAXcall({action:'toggleDev'});"
},
{
	title	: "GOOGLE",
	name	: "settings",
	dock	: false,
	script	: false,
	onclick	: "AJAXcall({action:'browser',url:'https://www.google.com/?ncr'});"
},



//Dock
{
	title	: "Telefon",
	name	: "phone",
	dock	: true,
	script	: true,
},
{
	title	: "SMS",
	name	: "messages",
	dock	: true,
	script	: true,
},
{
	title	: "Musik",
	name	: "music",
	dock	: true,
	script	: false,
	onclick	: "openApp('musicext');$('#topBar').css('background-color', '#f7f7f8');AJAXcall({action:'musicext'});",
},
{
	title	: "Safari",
	name	: "safari",
	dock	: true,
	script	: false,
}
);



function openMusicEXT() {
	AJAXcall({action:'browser',url:WEBSERVER_URL+'/iphone/music/?apiUser='+encodeURIComponent(MY_NAME)+'&apiAuth='+encodeURIComponent(API_AUTH)+'&defRadios='+encodeURIComponent(JSON.stringify(DEFAULT_RADIOS))+'&'+Math.random()+''});
}

/*** ALLGEMEINES ***/
function updateAllShit() {
	var time = new Date();
	$('#topBarMiddle').html((time.getHours()<10?'0':'')+time.getHours()+':'+(time.getMinutes()<10?'0':'')+time.getMinutes());
	
	
	
	if (FLIGHTMODE) {
		$('#topBarLeft').html('&nbsp;');
		if (CUR_APP == 'messages' || CUR_APP == 'settings' || CUR_APP == 'notes' || CUR_APP == 'phone' || CUR_APP == 'music' || CUR_APP == 'musicext' || CUR_APP == 'vehicles' || CUR_APP == 'franchise' || CUR_APP == 'safari') {
			$("#topBarLeft").attr('class', 'flightmodeIconBlack');
		} else {
			$("#topBarLeft").attr('class', 'flightmodeIconWhite');
		}
		var onOff = $('#flightToggle:checked').length > 0;
		if (!onOff) {
			$('#flightToggle').prop('checked', true);
		}
		
	} else {
		var c = '';
		for (i = 1; i <= 5; i++) {
			
			if (i <= CELLULAR) {
				c = c + '•';
			} else {
				c = c + '◦';
			}
		}
		
		var netz = '&nbsp;';
		if (CELLULAR >= 5) {
			netz = 'LTE';
		} else if (CELLULAR >= 3) {
			netz = '3G';
		} else if (CELLULAR >= 1) {
			netz = 'E';
		}
		
		$('#topBarLeft').html('&nbsp;'+c+' SLmobile&nbsp;&nbsp;'+netz);
		$("#topBarLeft").attr('class', '');
		$('#flightToggle').prop('checked', false);
	}
	
	
	if (SETTINGS['battery']) {
		var bat = Number(SETTINGS['battery']);
		var fix = '';
		if (bat >= 90) {
			fix = 'p100';
		} else if (bat >= 60) {
			fix = 'p75';
		} else if (bat >= 40) {
			fix = 'p50';
		} else if (bat >= 21) {
			fix = 'p25';
		} else if (bat >= 11) {
			fix = 'p20';
		} else if (bat >= 0) {
			fix = 'p10';
		}
		$('#batteryPercent').html(Math.round(bat)+" %");
		$('#batSymbol').attr('class', 'battery '+fix);
	}
	
	updateVolumeOverlay();
}

var perc20 = false;
var perc10 = false;
function updateBattery() {
	/*if (IPHONE_OPEN || isPlaying) {
		// 200 min benutzung
		SETTINGS['battery'] = SETTINGS['battery'] - 0.5
	} else {
		// 1000 min standby
		SETTINGS['battery'] = SETTINGS['battery'] - 0.1
	}
	
	if (LOADING) {
		if (SETTINGS['battery'] < 100) {
			// 100min ladezeit von 0auf100
			SETTINGS['battery'] = SETTINGS['battery'] + 1;
		}
	}
	
	if (Math.floor(SETTINGS['battery']) == 20 && perc20 == false) {
		myApp.alert('Noch 20% Batterieladung.', 'Batterie fast leer');
		perc20 = true;
	} else if (Math.floor(SETTINGS['battery']) == 10 && perc20 == false) {
		myApp.alert('Noch 10% Batterieladezustand', 'Batterie fast leer');
		perc10 = true;
	}
	
	if (SETTINGS['battery'] > 20) {
		perc20 = false;
	}
	if (SETTINGS['battery'] > 10) {
		perc10 = false;
	}*/
}

function openApp(name) {
	pressHome();
	if (name == 'weather') {
		updateWeather();
		
	} else if (name == 'notes') {
		$('#noteText').val(atob(SETTINGS['notes']));
		
	} else if (name == 'messages') {
		loadSMS();
		
	} else if (name == 'settings') {
		setSettingsToggles();
		
	} else if (name == 'phone') {
		firstGuideHelp("Mit *100# kannst Du dein Prepaid-Guthaben Abfragen.<br>Guthaben kannst Du in der Banking-App oder bei Supermärkten aufladen.");
		
	} else if (name == 'vehicles') {
		updateVehicles();
		
	} else if (name == 'franchise') {
		updateFranchise();
		
	} else if (name == 'banking') {
		loadTransactions();
		
	} else if (name == 'home') {
		updateHouses();
	}
	
	if (name == 'messages' || name == 'settings' || name == 'notes' || name == 'phone' || name == 'music' || name == 'musicext' || name=='vehicles' || name=='home' || name=='franchise' || name=='safari') { // make top bar font black
		$('#topBar').css('color', 'black');
		var fix = '#f7f7f8'; if (name=='notes' || name=='phone' || name=='music' || name == 'musicext' || name=='safari') { fix='transparent'; }
		$('#topBar').css('background-color', fix);
		$('#batLoadingSymbol').attr('src', 'images/ui/flash_b.png');
		if (FLIGHTMODE) {
			$("#topBarLeft").attr('class', 'flightmodeIconBlack');
		}
		$('head').append('<style id="batteryBlackFix">.battery{border:1px solid #000;}.battery:after{border: 1px solid #000;}</style>');
	}
	
	$('#apps').css('display', 'none');
	$('#pages').css('display', 'none');
	$('#dock').css('display', 'none');
	$('#'+name+'App').css('display', 'block');
	CUR_APP = name;
}

function pressHome(hold) {
	if (callScreenShowing == true && canMinimizeCall == false) {
		return myApp.alert("Du kannst den Anruf nur minimieren, wenn du Verbunden bist.", "Telefon");
	}
	
	if (CUR_APP == 'notes') {
		setSetting('notes', btoa($('#noteText').val()));
	}
	
	
	$('#apps').css('display', '');
	$('#pages').css('display', '');
	$('#dock').css('display', '');
	$('.app').css('display', 'none');
	$('#topBar').css('color', 'white');
	$('#topBar').css('background-color', 'transparent');
	$('#batLoadingSymbol').attr('src', 'images/ui/flash_w.png');
	if (FLIGHTMODE) {
		$("#topBarLeft").attr('class', 'flightmodeIconWhite');
	}
	$('.battery').css('border', '1px solid #fff');
	$('#batteryBlackFix').remove();
	CUR_APP = false;
}



function loadShit() {
	
}

function resizeBg() {
	var verhaeltnis = 1334 / 750;
	var iHeight		= $('#homeScreen').height();
	$('#homeScreen').width((iHeight/verhaeltnis)+'px');
}

$(document).ready(function() {
	if (imgExists("images/customBg.png")) {
		$('#homeScreen').css("background", "url(images/customBg.png?"+Math.random()+") no-repeat center center");
	}
	
	myApp = new Framework7();
	
	var _noti = myApp.addNotification;
	myApp.addNotification = function(params) {
		if (IPHONE_OPEN) {
			return _noti(params);
		} else {
			return AJAXcall({action:"showNotification",title:params.title,message:params.message,hold:params.hold,audio:params.audio,image:params.image,onclick:params.eventStr}, function(){});
		}
	};
	
	
	/** LOAD APPS **/
	var put = '';
	$.each(APPS, function(i, arr) {
		if (!arr.dock) {
			var fix = "openApp('"+arr.name+"');";
			if (arr.onclick) {
				fix = arr.onclick;
			}
			put = put + '<span class="appIcon">\
				<img class="appImg" src="images/apps/'+arr.name+'.png" height="80%" onclick="'+fix+'"/>\
				<span class="appName"><center>'+arr.title+'</center></span>\
			</span>';
		}
	});
	$('#apps').html(put);
	
	
	var put = '';
	$.each(APPS, function(i, arr) {
		if (arr.dock) {
			var fix = "openApp('"+arr.name+"');";
			if (arr.onclick) {
				fix = arr.onclick;
			}
			put = put + '<span class="appIcon dockapp">\
				<img class="appImg" src="images/apps/'+arr.name+'.png" height="80%" onclick="'+fix+'"/>\
				<span class="appName"><center>'+arr.title+'</center></span>\
			</span>';
		}
	});
	$('#dockApps').html(put);
	
	
	$.each(APPS, function(i, arr) {
		if (arr.script) {
			$.getScript("js/apps/"+arr.name+".js?"+Math.random(), function(data, textStatus, jqxhr) {
				//console.log('Load '+arr.name+': '+jqxhr.status+' - '+textStatus);
			});
		}
	});
	
	
	resizeBg();
	updateAllShit();
	loadShit();
	
	setInterval(function() {
		updateAllShit();
	}, 1000);
	setInterval(function() {
		loadShit();
	}, 3000);
	setInterval(function() {
		updateBattery();
	}, 1*60000);
	
	setTimeout(function() {
		loadSMS();
	}, 2500);
});


function setLoading(bool) {
	LOADING = bool;
	if (bool) {
		$('#batteryPercent').attr('style', 'margin-right:13px;');
		$('#batSymbol').attr('style', 'margin-right:13px;');
		$('#batLoadingSymbol').css('display', '');
	} else {
		$('#batteryPercent').attr('style', '');
		$('#batSymbol').attr('style', '');
		$('#batLoadingSymbol').css('display', 'none');
	}
}
setLoading(false);

function setSetting(k, v) {
	SETTINGS[k] = v;
	AJAXcall({action:"changeSettings",data:btoa(JSON.stringify(SETTINGS))});
}

/*** VOLUME ***/
function updateVolumeOverlay() {
	var x = Math.round((CUR_VOLUME/10));
	var put = '';
	if (x > 0) {
		for (i = 1; i <= x; i++) { 
			var plus = 6*(i-1);
			var left = 113+plus;
			put = put + '<span style="z-index:501;background-color:white;position:fixed;left:'+left+'px;top:293px;height:6px;width:4px;"></span>';
		}
	}
	$('#volumeOverlay').html(put);
}

var overlayTimer = false;
function setVolume(what) {
	var vol = CUR_VOLUME;
	
	if (what == '+') {
		vol = vol + 10;
		if (vol > 100) { vol = 100; }
	} else if (what == '-') {
		vol = vol - 10;
		if (vol < 0) { vol = 0; }
	} else if (typeof(what) == 'number') {
		vol = what;
	}
	CUR_VOLUME = vol;
	
	$('#musicVolumeSlide').val(CUR_VOLUME);
	$('#musicVolumeSlide').attr('value',CUR_VOLUME);
	if (isPlaying) {
		mta.triggerEvent("musicChangeVolume", CUR_VOLUME);
	}
	
	updateVolumeOverlay();
	if (!(CUR_APP == 'music' && isPlayerShowing)) {
		$('#volumeOverlay').css('display', '');
		if (overlayTimer) {
			clearTimeout(overlayTimer);
		}
		overlayTimer = setTimeout(function() {
			$('#volumeOverlay').css('display', 'none');
		}, 2500);
	}
}





/*** AJAX ***/
function AJAXcall(_data, returnFunction) {
	/*if (!returnFunction) {
		returnFunction = function(){};
	}
	var req = $.ajax({
		url: "ajax?cacheFucker="+Math.random(),
		type: "POST",
		data : _data,
		xhrFields: { withCredentials: true},
		success: function(data, textStatus, jqXHR) {
			returnFunction(data);
			
			jqXHR.abort();
		},
		error: function (jqXHR, textStatus, errorThrown) {
			returnFunction(false);
			
			jqXHR.abort();
		}
	});*/
	
	console.log('@AJAXcall');
	return mta.triggerEvent("ajaxFix", JSON.stringify(_data));
}









/*** OTHER UNSORTED SHIT ***/
var helpShown = new Array();
function firstGuideHelp(text) {
	if (Number(SETTINGS['firstGuide']) == 1) {
		if (!helpShown[text]) {
			myApp.alert(text+"<br><br><small>Du kannst diese Einführungshilfen in den Einstellungen deaktivieren.</small>", 'Einführungshilfe');
			helpShown[text] = true;
		}
	}
}

