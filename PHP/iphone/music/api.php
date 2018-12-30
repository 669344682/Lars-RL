<?php
/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/


include("../../CONFIG.php");
$mySQLcon = new mysqli("127.0.0.1", "USER", 'PASSWORD', "DATABASE", 3306);
@$mySQLcon->query("set names 'utf8'");

header("Content-Type: application/json");
header("Cache-Control: no-cache");
$RET = array("success" => false, "message" => null, "data"=> null);

$token = hash('sha256',  @$_REQUEST['apiUser'].SALZ);
if ($_REQUEST['apiAuth'] == $token) {
	
	if (isset($_REQUEST['method'])) {
		
		if ($_REQUEST['method'] == 'getMusicSettings') {
			
			$query			= "SELECT firstGuide,radiostations,likedSongs FROM iphone_settings WHERE Name LIKE '".$mySQLcon->escape_string($_REQUEST['apiUser'])."';";
			$sql = $mySQLcon->query($query);
			if ($sql->num_rows > 0) {
				
				$row = $sql->fetch_assoc();
				
				$RET['success'] = true;
				$RET['data'] = $row;
				
			} else {
				$RET['message'] = 'Userdata not found';
			}
			
		} else if ($_REQUEST['method'] == 'setMusicLikes') {
			
			if (isset($_REQUEST['likes'])) {
				
				if (json_decode($_REQUEST['likes'], true)) {
					
					$query			= "UPDATE iphone_settings SET likedSongs='".$mySQLcon->escape_string($_REQUEST['likes'])."' WHERE Name LIKE '".$mySQLcon->escape_string($_REQUEST['apiUser'])."';";
					if ($mySQLcon->query($query)) {
						$RET['success'] = true;
					}
					
				} else {
					$RET['message'] = 'likes invalid';
				}
				
			} else {
				$RET['message'] = 'likes missing';
			}
			
		} else if ($_REQUEST['method'] == 'setRadioChannels') {
			
			if (isset($_REQUEST['stations'])) {
				
				if (json_decode($_REQUEST['stations'], true)) {
					
					$query			= "UPDATE iphone_settings SET radiostations='".$mySQLcon->escape_string($_REQUEST['stations'])."' WHERE Name LIKE '".$mySQLcon->escape_string($_REQUEST['apiUser'])."';";
					if ($mySQLcon->query($query)) {
						$RET['success'] = true;
					}
					
				} else {
					$RET['message'] = 'stations invalid';
				}
				
			} else {
				$RET['message'] = 'stations missing';
			}
			
		} else if ($_REQUEST['method'] == 'testRadioStream') {
			
			if (isset($_REQUEST['stream'])) {
				
				if (strpos($_REQUEST['stream'], 'http') !== false) {
					
					// Check if streamurl is playlist-file (m3u,asx,ra,ram,pls)
/*
.asx,strpos(ms-asf)
.pls,strpos(scpls)
.m3u,strpos(mpegurl)
.ra/.ram,strpos(realaudio)

*/
					$test = curlIt($_REQUEST['stream'], array(
						CURLOPT_RETURNTRANSFER		=> 1,
						CURLOPT_FOLLOWLOCATION		=> 1,
						CURLOPT_HEADER						=> 0,
						//CURLOPT_NOBODY						=> 1,
						CURLOPT_RANGE						=> '0-10000',
						CURLOPT_TIMEOUT						=> 3,
						CURLOPT_USERAGENT				=> 'VLC',
						CURLOPT_HTTPHEADER				=> array('Icy-MetaData: 1'),
					));
					
					if ($test['info']['http_code'] == 200 || $test['info']['http_code'] == 206) {
						
						$URLs = array();
						if (
							strpos($test['info']['content_type'], 'scpls') !== false || strpos($test['info']['url'], '.pls') !== false ||
							strpos($test['info']['content_type'], 'mpegurl') !== false || strpos($test['info']['url'], '.m3u') !== false ||
							strpos($test['info']['content_type'], 'realaudio') !== false || strpos($test['info']['url'], '.ra') !== false
						) {
							
							preg_match_all('/(https?:\/\/)(.*?)$/m', $test['data'], $URLs);
							$URLs = $URLs[0];
							
						} else if (strpos($test['info']['content_type'], 'ms-asf') !== false || strpos($test['info']['url'], '.asx') !== false) {
							
							preg_match_all('/"http(.*?)"/', $test['data'], $URLs);
							$URLs = $URLs[0];
							
						}
						
						if (count($URLs) == 0) {
							$URLs[] = $test['info']['url'];
						}
						
						//print_r($URLs);
						
						$finalURL = "";
						foreach ($URLs as $i => $url) {
							$url = str_replace('"', '', $url);
							$url = str_replace("\r", "", $url);
							$url = str_replace("\n", "", $url);
							$url = str_replace('\r', "", $url);
							$url = str_replace('\n', "", $url);
							/*$c = 'ffprobe -print_format json -show_streams -icy 1 -timeout 5000000 -user_agent "VLC" "'.$url.'"';
							$shell = shell_exec($c);
							echo $c."\r\n";
							print_r($shell);*/
							$tst = curlIt($url, array(
								CURLOPT_RETURNTRANSFER		=> 1,
								CURLOPT_FOLLOWLOCATION		=> 1,
								CURLOPT_HEADER						=> 1,
								CURLOPT_TIMEOUT						=> 5,
								CURLOPT_USERAGENT				=> 'VLC',
								CURLOPT_HTTPHEADER				=> array('Icy-MetaData: 1'),
							));
							//print_r($tst);
							if (strpos($tst['info']['content_type'], 'mp3') !== false || strpos($tst['info']['content_type'], 'mpeg') !== false) {
								$finalURL = $tst['info']['url'];
								$RET['format'] = 'mpeg';
								break;
							} else if (strpos($tst['info']['content_type'], 'ogg') !== false || strpos($tst['info']['content_type'], 'vorbis') !== false) {
								$finalURL = $tst['info']['url'];
								$RET['format'] = 'vorbis';
								break;
							}
						}
						
						if (!empty($finalURL)) {
							$RET['url'] = $finalURL;
							$RET['success'] = true;
						} else {
							$RET['message'] = 'No supported stream(format) found.';
						}
						
					} else {
						$RET['message'] = 'HTTP!=200||206:'.$test['info']['http_code'];
					}
					

					$RET['curl'] = $test;
					
				} else {
					$RET['message'] = 'stream-url invalid';
				}
				
			} else {
				$RET['message'] = 'stream-url missing';
			}
			
		} else {
			$RET['message'] = 'Unknown method';
		}
		
	} else {
		$RET['message'] = 'No method provided';
	}
	
} else {
	$RET['message'] = 'Authentication failed';
}

echo json_encode($RET);



function curlIt($url, $opts) {
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	
	foreach ($opts as $k => $v) {
		curl_setopt($ch, $k, $v);
	}
	
	$data = curl_exec($ch);
	$info = curl_getinfo($ch);
	curl_close($ch);
	
	return array("data" => $data, "info" => $info);
}

@$mySQLcon->close();
?>