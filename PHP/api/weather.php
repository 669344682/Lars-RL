<?php
/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

include("../CONFIG.php");
$apiUser	= @$_REQUEST['loc'];
$apiAuth	= @$_REQUEST['apiAuth'];
if (empty($apiUser) || empty($apiAuth) || strtolower(hash('sha256', $apiUser.SALZ)) != strtolower($apiAuth)) {
	header("Content-Type: text/html");
	die('Authentication Failed!<br>Suck my 🍆');
}

header("Content-Type: application/json");
$json = curlGet("http://api.openweathermap.org/data/2.5/weather?APPID=".openweathermap_apikey."&units=metric&q=".urlencode($_GET['loc']));
$json = json_decode($json, true);

$nextDays = curlGet("http://api.openweathermap.org/data/2.5/forecast?APPID=".openweathermap_apikey."&units=metric&q=".urlencode($_GET['loc']));
$nextDays = json_decode($nextDays, true);

$DayNames = array(
	1 => "Montag",
	2 => "Dienstag",
	3 => "Mittwoch",
	4 => "Donnerstag",
	5 => "Freitag",
	6 => "Samstag",
	7 => "Sonntag",
);

$dTmpMin = array();
$dTmpMax = array();
foreach ($nextDays['list'] as $i => $arr) {
	$d		= date("d", $arr['dt']);
	$min	= $arr['main']['temp_min'];
	$max	= $arr['main']['temp_max'];
	
	if (!$dTmpMin[$d] || $min < $dTmpMin[$d]) {
		$dTmpMin[$d] = $min;
	}
	if (!$dTmpMax[$d] || $max > $dTmpMax[$d]) {
		$dTmpMax[$d] = $max;
	}
}


$days = array();
foreach ($nextDays['list'] as $i => $arr) {
	$d = date("d", $arr['dt']);
	if (date("H", $arr['dt']) == 13 && $d != date("d")) {
		$days[] = array(
			"weekday"	=> $DayNames[date("N", $arr['dt'])],
			"icon"		=> $arr['weather'][0]['icon'],
			"temp_min"	=> $dTmpMin[$d],
			"temp_max"	=> $dTmpMax[$d],
		);
	}
}

$data = array(
	"title"			=> $json['weather'][0]['main'],
	"desc"			=> $json['weather'][0]['description'],
	"icon" 			=> $json['weather'][0]['icon'],
	"temp"			=> $json['main']['temp'],
	"pressure"		=> $json['main']['pressure'], // hPa
	"humidity"		=> $json['main']['humidity'], // %
	"temp_min"		=> $json['main']['temp_min'],
	"temp_max"		=> $json['main']['temp_max'],
	"wind_speed"	=> ($json['wind']['speed']*3.6), // meter/sec
	"wind_deg"		=> $json['wind']['deg'], // Wind direction, degrees (meteorological) (rotation z)
	"clouds_all"	=> $json['clouds']['all'], // Cloudiness, %
	"sunrise"		=> $json['sys']['sunrise'],
	"sunset"		=> $json['sys']['sunset'],
	"visibility"	=> $json['visibility'],
	"nextDays"		=> $days
);

echo json_encode($data);

function curlGet($url) {
	$ch = curl_init();
	curl_setopt($ch,CURLOPT_URL,$url);
	curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
	curl_setopt($ch,CURLOPT_FOLLOWLOCATION,1);
	curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,5);
	
	$data = curl_exec($ch);
	curl_close($ch);
	return $data;
}
?>