/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/


function updateWeather() {
	AJAXcall({action:"getWeather"}, function(){});
}

function weatherCallback(data) {
	var json = atob(data);
	json = $.parseJSON(json);
	
	$('#weatherName').html(json['weatherName']);
	$('#weatherTemp').html(Math.round(json['temp'])+"°");
	
	$('#imgToday').attr('src', 'images/ui/weather/'+json['icon']+'.png');
	
	$('#tempMinNow').html(Math.round(json['temp_min'])+"°");
	$('#tempMaxNow').html(Math.round(json['temp_max'])+"°");
	
	$('#weatherDays').html('');
	$.each(json['nextDays'], function(i, arr) {
		$('#weatherDays').append('<li>\
			<ul>\
				<li>'+arr['weekday']+'</li>\
				<li><img src="images/ui/weather/'+arr['icon']+'.png"/></li>\
				<li>'+Math.round(arr['temp_min'])+'˚</li>\
				<li>'+Math.round(arr['temp_max'])+'˚</li>\
			</ul>\
		</li>');
	});
	
	$('#wTodayText').html("Heute: "+json['weatherName']+". Die Temperatur beträgt "+Math.round(json['temp'])+"°; die vorhergesagte Höchsttemperatur für heute ist "+Math.round(json['temp_max'])+"°.");
	
	var sunrise	= new Date(json['sunrise']*1000);
	var sunset	= new Date(json['sunset']*1000);
	$('#sunriseNow').html(("0" + sunrise.getHours()).substr(-2)+":"+("0" + sunrise.getMinutes()).substr(-2));
	$('#sunsetNow').html(("0" + sunset.getHours()).substr(-2)+":"+("0" + sunset.getMinutes()).substr(-2));
	
	$('#humidityNow').html(json['humidity']+" %");
	$('#visibilityNow').html((json['visibility']/1000)+" km");
	
	$('#windNow').html(json['windRotationS']+" "+Math.round(json['wind_speed'])+" km/h");
	$('#pressureNow').html(json['pressure']+" hPa");
}