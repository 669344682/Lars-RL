/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

function updateVehicles() {
	AJAXcall({action:"getAllVehicles"}, function(){});
}

function receiveVehicles(data) {
	var json = atob(data);
	json = $.parseJSON(json);
	
	var put = '';
	$.each(json, function(i, arr) {
		put += '<li>\
			<div class="item-content">\
				<div class="item-inner">\
					<span style="float:left;width:82%;"><b>#'+arr["slot"]+'</b> '+arr["name"]+'</span>\
					<span style="width:18%;">\
						<i class="fa fa-location-arrow faa-wrench animated-hover" style="font-size:22px; color:#007aff;" onclick="locateVehicle('+arr["slot"]+');"></i>\
						<i class="fa fa-retweet faa-horizontal animated-hover" style="font-size:22px; color:#404040;" onclick="respawnVehicle('+arr["slot"]+');"></i>\
					</span>\
				</div>\
			</div>\
		</li>';
	});
	$('#allVehicles').html(put);

}

function locateVehicle(slot) {
	AJAXcall({action:"locateVehicle",slot:slot}, function(){});
}
function respawnVehicle(slot) {
	if (slot == 'all') {
		myApp.confirm(
			'Alle Fahrzeuge Respawnen?', 
			function () {
				AJAXcall({action:"respawnVehicle",slot:'all'}, function(){});
			},
			function () {
				
			}
		);
	} else {
		AJAXcall({action:"respawnVehicle",slot:slot}, function(){});
	}
	
}