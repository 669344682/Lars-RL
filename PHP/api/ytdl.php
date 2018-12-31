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

header("Cache-Control: no-cache");
header("Content-Type: application/json");
header("Keep-Alive: 0");
header("Connection: close");

$thisURI = str_replace('ytdl.php', '', getCurrentUrl());

$ret = array("state" => false, "code" => "");

$ID			= @$_REQUEST['id'];
$SERVICE	= @$_REQUEST['srv'];
$apiUser	= @$_REQUEST['apiUser'];
$apiAuth	= @$_REQUEST['apiAuth'];

if (empty($apiUser) || empty($apiAuth) || strtolower(hash('sha256', $apiUser.SALZ)) != strtolower($apiAuth)) {
	header("Content-Type: text/html");
	die('Authentication Failed!<br>Suck my ??');
}

if (!empty($ID) && !empty($SERVICE) && ($SERVICE == 'vimeo' || $SERVICE == 'vevo' || $SERVICE == 'youtube' || $SERVICE == 'dailymotion' || $SERVICE == 'soundcloud')) {
	
	if (true) {
		//    --audio-format FORMAT            Specify audio format: "best", "aac", "flac", "mp3", "m4a", "opus", "vorbis", or "wav"; "best" by default; No effect without -x
		$fileExt = 'opus';
		if ($SERVICE == 'vimeo' || $SERVICE == 'vevo' || $SERVICE == 'dailymotion' || $SERVICE == 'youtube') {
			$fileExt = 'ogg';
		} else if ($SERVICE == 'soundcloud') {
			$fileExt = 'mp3';
		}
		
		$serviceName = "";
		if ($SERVICE == 'vimeo') {
			$serviceName = "Vimeo";
		} else if ($SERVICE == 'vevo') {
			$serviceName = "Vevo";
		} else if ($SERVICE == 'dailymotion') {
			$serviceName = "Dailymotion";
		} else if ($SERVICE == 'soundcloud') {
			$serviceName = "Soundcloud";
		} else if ($SERVICE == 'youtube') {
			$serviceName = "YouTube";
		}
		
		$fPthEx = 'tmp/ytdl/'.$SERVICE.'-'.md5($ID).'.%(ext)s';
		$fPath = 'tmp/ytdl/'.$SERVICE.'-'.md5($ID).'.'.$fileExt;
		$jPath = 'tmp/ytdl/'.$SERVICE.'-'.md5($ID).'.json';
		
		if (file_exists($fPath)) {
			$ret['state']	= true;
			$ret['code']	= 'EXISTS';
			$ret['time']	= @filemtime($jPath);
			$ret['dl']		= $thisURI.$fPath;
			
			$json = @json_decode(@file_get_contents($jPath), true);
			$ret = array_merge($ret, $json);
			
		} else {
			
			$OK = false;
			$title = "";
			$image = "";
			$length = 0;
			$uFix = "";
			
			if ($SERVICE == "vimeo") {
				$API = curl("https://vimeo.com/api/v2/video/".$ID.".json");
				if (strpos($API, $ID.' not found.') !== true) {
					$API = json_decode($API, true)[0];
					
					if ($API['duration'] > 0 && $API['duration'] < (21*60)) {
						$OK = true;
						$title = $API['title'];
						$image = $API['thumbnail_medium'];
						$length = $API['duration'];
						$uFix = "https://vimeo.com/";
						
					} else {
						$ret['code']	= 'TOLONG';
					}
					
				} else {
					$ret['code']	= 'NOTFOUND';
				}
				
			} else if ($SERVICE == "youtube") {
				$API = curl("https://www.googleapis.com/youtube/v3/videos?id=".$ID."&part=snippet,contentDetails&key=".google_youtube_apikey);
				$API = json_decode($API, true);
				
				if (count($API['items']) > 0) {
					
					if ($API['items'][0]['snippet']['liveBroadcastContent'] != "live") {
						
						$lng = @ISO8601ToSeconds($API['items'][0]['contentDetails']['duration']);
						if ($lng > 0 && $lng < (21*60)) {
							$OK = true;
							$title = $API['items'][0]['snippet']['title'];
							$image = "https://i.ytimg.com/vi/".$ID."/mqdefault.jpg";
							$length = $lng;
							$uFix = "https://www.youtube.com/watch?v=";
							
						} else {
							$ret['code']	= 'TOLONG';
						}
						
					} else {
						$ret['code']	= 'NOLIVE';
					}
					
				} else {
					$ret['code']	= 'NOTFOUND';
				
				}
				
				
			/*} else if ($SERVICE == "vevo") { // vevo nur noch youtube
				
				$API = curl("https://www.vevo.com/watch/".$ID);
				preg_match('/property="video:duration" content="(.*?)"/', $API, $DUR);
				$DUR = $DUR[1];
				preg_match('/property="og:title" content="(.*?)"/', $API, $TTL);
				$TTL = $TTL[1];
				
				if (is_numeric($DUR) && !empty($TTL)) {
					$DUR = floor(($DUR/1000));
					
					if ($DUR > 0 && $DUR < (21*60)) {
						$OK = true;
						$title = $TTL;
						$image = "https://img.cache.vevo.com/thumb/video/".$ID."/small.jpeg";
						$length = $DUR;
						$uFix = "https://www.vevo.com/watch/";
						
					} else {
						$ret['code']	= 'TOLONG';
					}
				} else {
					$ret['code']	= 'NOTFOUND';
				}*/
				
				
			} else if ($SERVICE == "dailymotion") {
				
				$API = curl("https://api.dailymotion.com/video/".$ID."?fields=id,title,duration,thumbnail_240_url,mode,geoblocking,status");
				$API = json_decode($API, true);
				
				if ($API['status'] && $API['status'] == 'published') {
					
					if ($API['mode'] == 'vod') {
						
						if ($API['duration'] > 0 && $API['duration'] < (21*60)) {
							$OK = true;
							$title = $API['title'];
							$image = $API['thumbnail_240_url'];
							$length = $API['duration'];
							$uFix = "http://www.dailymotion.com/video/";
							
						} else {
							$ret['code']	= 'TOLONG';
						}
						
					} else {
						$ret['code']	= 'NOLIVE';
					}
				} else {
					$ret['code']	= 'NOTFOUND';
				}
				
				
			} else if ($SERVICE == "soundcloud") {
				
				$API = curl("https://soundcloud.com/".$ID);
				preg_match('/itemprop="duration" content="(.*?)"/', $API, $DUR);
				$DUR = @ISO8601ToSeconds($DUR[1]);
				preg_match('/property="twitter:title" content="(.*?)"/', $API, $TTL);
				$TTL = $TTL[1];
				preg_match('/property="twitter:image" content="(.*?)"/', $API, $IMG);
				$IMG = $IMG[1];
				
				if (is_numeric($DUR) && !empty($TTL) && !empty($IMG)) {
					if ($DUR > 0 && $DUR < (21*60)) {
						$OK = true;
						$title = $TTL;
						$image = $IMG;
						$length = $DUR;
						$uFix = "https://soundcloud.com/";
						
					} else {
						$ret['code']	= 'TOLONG';
					}
				} else {
					$ret['code']	= 'NOTFOUND';
				}
				
			}
			
			
			if ($OK) {
				$DIRECT = "";
				/*if ($SERVICE == 'youtube') { // hotlink nicht mehr möglich (403)
					$DIRECT = str_replace("\r", '', str_replace("\n", '', shell_exec('./youtube-dl --ffmpeg-location ./ -f "bestaudio[ext=webm]" --get-url "http://youtube.com/watch?v='.$ID.'"')));
				} else*/ if ($SERVICE == 'soundcloud') {
					$DIRECT = str_replace("\r", '', str_replace("\n", '', shell_exec('./youtube-dl --ffmpeg-location ./ -f "bestaudio[ext=mp3]" --get-url "'.$uFix.$ID.'"')));
				} else {
					$cmd = './youtube-dl --ffmpeg-location ./ --add-metadata --no-cache-dir --rm-cache-dir --no-check-certificate --ignore-errors --rate-limit 5000K --extract-audio --audio-format '.(($fileExt=='ogg')?'vorbis':$fileExt).' "'.$uFix.$ID.'" -o "'.$fPthEx.'"';
					$x = shell_exec($cmd);
					
					$ret['cmd']		= $cmd;
					$ret['cmd_out']	= $x;
				}
				
				if (file_exists($fPath) || $DIRECT != "") {
					$ret['state']	= true;
					$ret['code']	= 'SUCCESS';
					
					$ret['service']	= $SERVICE;
					$ret['serviceName']=$serviceName;
					$ret['title']	= $title;
					$ret['image']	= $image;
					//$ret['imageb64']= "data:image/jpg;base64,".base64_encode(file_get_contents($image));
					$ret['length']	= $length;
					
					if ($DIRECT == "") {
						$ret['dl']		= $thisURI.$fPath;
					} else {
						$ret['dl']		= $DIRECT;
					}
					$pret = $ret;
					unset($pret['code']);
					unset($pret['state']);
					unset($pret['dl']);
					file_put_contents($jPath, json_encode($pret));
					
				} else {
					$ret['code']	= 'DLERROR';
				}
			}
			
		}
		
	} else {
		$ret['code']	= 'AUTHERR';
	}
	
} else {
	$ret['code'] = 'PARAMISSING';
}


echo json_encode($ret, true);


function ISO8601ToSeconds($ISO8601)
{
    preg_match('/\d{1,2}[H]/', $ISO8601, $hours);
    preg_match('/\d{1,2}[M]/', $ISO8601, $minutes);
    preg_match('/\d{1,2}[S]/', $ISO8601, $seconds);
    
    $duration = [
        'hours'   => $hours ? $hours[0] : 0,
        'minutes' => $minutes ? $minutes[0] : 0,
        'seconds' => $seconds ? $seconds[0] : 0,
    ];

    $hours   = substr($duration['hours'], 0, -1);
    $minutes = substr($duration['minutes'], 0, -1);
    $seconds = substr($duration['seconds'], 0, -1);

    $toltalSeconds = (@$hours * 60 * 60) + (@$minutes * 60) + @$seconds;

    return $toltalSeconds;
}

function curl($url, $data = null) {
	$curl = curl_init();
	
	curl_setopt($curl, CURLOPT_URL, $url);
	if ($data) {
		if (is_array($data)) {
			$data = http_build_query($data);
		}
		curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
		curl_setopt($curl, CURLOPT_POST, 1);
	}
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 5);
	curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36');
	
	$result = curl_exec($curl);
	curl_close($curl);
	return $result;
}
function getCurrentUrl() {
	$url  = isset( $_SERVER['HTTPS'] ) && 'on' === $_SERVER['HTTPS'] ? 'https' : 'http';
	$url .= '://' . $_SERVER['SERVER_NAME'];
	$url .= in_array( $_SERVER['SERVER_PORT'], array('80', '443') ) ? '' : ':' . $_SERVER['SERVER_PORT'];
	$url .= strtok($_SERVER["REQUEST_URI"],'?');
	return $url;
}
?>