/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

function updateHouses() {
	AJAXcall({action:"getHouseData"}, function(){});
}

function receiveHouseData(data) {
	var json = atob(data);
	json = $.parseJSON(json);
	
	var put = '';
	$.each(json["houses"], function(i, arr) {
		put += '<li>\
			<div class="item-content">\
				<div class="item-inner">\
					<span style="float:left;width:82%;"><b>#'+arr["ID"]+'</b> '+arr["position"]+'</span>\
					<span style="width:18%;">\
						<i class="fa fa-location-arrow faa-wrench animated-hover" style="font-size:22px; color:#007aff;" onclick="locateHouse('+arr["ID"]+');"></i>\
						<i class="fa fa-lock faa-vertical animated-hover" style="font-size:22px; color:#404040;" onclick="lockHouse('+arr["ID"]+');"></i>\
					</span>\
				</div>\
			</div>\
		</li>';
	});
	$('#myHouses').html(put);
	
	
	var put = '';
	$.each(json["rentings"], function(i, arr) {
		put += '<li>\
			<div class="item-content">\
				<div class="item-inner">\
					<span style="float:left;width:90%;"><b>#'+arr["ID"]+'</b> '+arr["position"]+'</span>\
					<span style="width:10%;">\
						<i class="fa fa-location-arrow faa-wrench animated-hover" style="font-size:22px; color:#007aff;" onclick="locateHouse('+arr["ID"]+');"></i>\
					</span>\
				</div>\
			</div>\
		</li>';
	});
	$('#myRentings').html(put);

}

function locateHouse(ID) {
	AJAXcall({action:"houseAction",act:'locate',id:ID}, function(){});
}
function lockHouse(ID) {
	AJAXcall({action:"houseAction",act:'lock',id:ID}, function(){});	
}