/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/


function toggleSettingsUpdate() {
	setTimeout(function() {
		var onOff = $('#flightToggle:checked').length > 0;
		if (onOff) {
			firstGuideHelp("Mit aktiviertem Flugmodus kannst Du Apps welche eine Netzverbindung benötigen nicht nutzen, jedoch kannst Du nicht mehr von Strafverfolgungsbehörden geortet werden.");
		}
		FLIGHTMODE = onOff;
		
		
		var onOff = $('#firstGuideToggle:checked').length > 0;
		setSetting('firstGuide', ((onOff == true) ? 1 : 0));
	}, 200);
}

function changeColor(color) {
	setSetting('color', color);
}


function setSettingsToggles() {
	$('#flightToggle').prop('checked', FLIGHTMODE);
	$('#firstGuideToggle').prop('checked', ((SETTINGS['firstGuide']==1) ? true : false));
	
	$('input:radio[name="color-radio"]').filter('[value="'+SETTINGS['color']+'"]').attr('checked', true);
}