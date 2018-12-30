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


$apiUser	= @$_REQUEST['apiUser'];
$apiAuth	= @$_REQUEST['apiAuth'];
$apiParam	= "apiUser=".urlencode($apiUser)."&apiAuth=".$apiAuth;

if ((empty($apiUser) || empty($apiAuth) || strtolower(hash('sha256', $apiUser.SALZ)) != strtolower($apiAuth)) && !isset($_REQUEST['image']) && !isset($_REQUEST['update_charts'])) {
	header("Content-Type: text/html");
	die('Authentication Failed!<br>Suck my 🍆');
}

include("163util.php");
$crypto = new CryptoCloudMusic();

header("Cache-Control: no-cache");
header("Content-Type: application/json");

function curl($url, $data = null) {
	$curl = curl_init();
	
	$ip = '110.173.'.rand(192,223).'.'.rand(1,255);
		curl_setopt($curl, CURLOPT_HTTPHEADER, array('X-Real-IP: '.$ip, 'X-Forwarded-For: '.$ip));
		
	
	curl_setopt($curl, CURLOPT_URL, $url);
	if ($data) {
		if (is_array($data)) {
			$data = http_build_query($data);
		}
		curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
		curl_setopt($curl, CURLOPT_POST, 1);
	}
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 30);
	curl_setopt($curl, CURLOPT_COOKIE, 'os=pc; osver=Microsoft-Windows-10-Professional-build-14393-64bit; appver=2.1.0.145894; channel=netease; __remember_me=true');
	curl_setopt($curl, CURLOPT_REFERER, 'http://music.163.com/');
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


function getLyric($id) {
	$tmp = "tmp/163/".$id.".lyric";
	if (file_exists($tmp)) {
		return json_decode(file_get_contents($tmp), true);
	}
	
	$lyric = json_decode(curl('http://music.163.com/api/song/lyric/?id='.$id.'&lv=-1&csrf_token='), true);
	$lyric = @$lyric['lrc']['lyric'];
	$lyric = ((!empty($lyric)) ? $lyric : false);
	$isLiveLyric = false;
	if ($lyric != false) {
		preg_match('/\[by:(.*?)\]\n/', $lyric, $by);
		if (!empty($by[0])) {
			$lyric = str_replace($by[0], '', $lyric);
		}
		
		preg_match('/\[([0-9]+):([0-9]+).([0-9]+)\]/', $lyric, $live);
		if (!empty($live[0])) {
			$isLiveLyric = true;
			
			$lines = explode(PHP_EOL, $lyric);
			$newLines = array();
			foreach ($lines as $k => $v) {
				preg_match('/\[([0-9]+):([0-9]+).([0-9]+)\]/', $v, $time);
				if (!empty($time[0])) {
					$sec = ((int)($time[1]*60) + (int)$time[2]) * 1000;
					$sec += ($time[3]*10);
					$sec = (int)$sec;
					$v = str_replace($time[0], '', $v);
					if (!empty($v)) {
						$newLines[$sec] = $v;
					}
				}
			}
			
			$lyric = $newLines;
			
			
			
		}
	}
	
	$a = array('isLiveLyric' => $isLiveLyric, 'lyric' => $lyric);
	file_put_contents($tmp, json_encode($a, true));
	return $a;
}


function getImage($url, $id) {
	$tmp = "tmp/163/".$id.".webp";
	if (file_exists($tmp)) {
		$im = file_get_contents($tmp);
		return $im;
	}
	
	ob_start();
		$im		= imagecreatefromstring(curl($url));
		$width	= imagesx($im);
		$height = imagesy($im);
		
		$tmpimg = $im;
		if ($width > 200) {
			$scale = $width / 200;
			$nWidth = 200;
			$nHeight = ceil($height / $scale);
			
			$tmpimg = imagecreatetruecolor($nWidth, $nHeight);
			imagecopyresampled($tmpimg, $im, 0, 0, 0, 0, $nWidth, $nHeight, $width, $height);
		}
		//imagejpeg($tmpimg,null,35);
		imagewebp($tmpimg,null,30);
		
	$get = ob_get_clean();
	
	file_put_contents($tmp, $get);
	return $get;
}

function get163($s) {
	global $crypto, $apiParam;
	
	$data = array(
		's'			=> $s,
		'type'		=> ((isset($_REQUEST['type']) && !empty($_REQUEST['type'])) ? $_REQUEST['type'] : 1),
		'limit'		=> ((isset($_REQUEST['limit']) && !empty($_REQUEST['limit'])) ? $_REQUEST['limit'] : 10),
		'total'		=> 'true',
		'offset'	=> ((isset($_REQUEST['offset']) && !empty($_REQUEST['offset'])) ? $_REQUEST['offset'] : 0),
	);
	$search = json_decode(curl('http://music.163.com/api/search/pc', $data), true);
	
	/*$ids = array();
	if (count($search['result']['songs']) > 0) {
		foreach ($search['result']['songs'] as $k => $v) {
			array_push($ids, $v['id']);
		}
	}
	
	$data = array(
		'br'			=> 500000,
		'ids'			=> $ids,
		'csrf_token'	=> null,
	);
	$mp3 = json_decode(curl('http://music.163.com/weapi/song/enhance/player/url', $crypto->create_encrypt_data($data)), true);
	$mp3s = array();
	foreach ($mp3['data'] as $k => $v) {
		if (!empty($v['url'])) {
			$mp3s[($v['id'])] = str_replace('http:', 'https:', $v['url']);
		}
	}*/
	
	
	$ret = array();
	if (count($search['result']['songs']) > 0) {
		foreach ($search['result']['songs'] as $k => $v) {
			//if (!empty($mp3s[($v['id'])])) {
				$lyric = getLyric($v['id']);
				array_push($ret, array(
					"id" 		=> $v['id'],
					"artist"	=> $v['artists'][0]['name'],
					"title"		=> $v['name'],
					"album"		=> $v['album']['name'],
					"image"		=> getCurrentUrl()."?image=".bin2hex($v['album']['blurPicUrl'])."&id=".$v['id'],
					//"imageb64"	=> "data:image/jpg;base64,".base64_encode(getImage($v['album']['blurPicUrl'], $v['id'])),
					//"url"		=> str_replace(array('m7c.', 'm8c.'), array('m7.', 'm8.'), $mp3s[($v['id'])]),
					"url"		=> getCurrentUrl()."?".$apiParam."&mp3=".$v['id'],
					"lyric"		=> $lyric,
				));
			//}
		}
	}
	
	return $ret;
}



if (isset($_REQUEST['s'])) {
	echo json_encode(get163($_REQUEST['s']), true);
	
	
} else if (isset($_REQUEST['playlist'])) {
	$search = json_decode(curl('http://music.163.com/api/song/detail/?ids='.$_REQUEST['playlist'], $data), true);
	
	/*$ids = array();
	if (count($search['songs']) > 0) {
		foreach ($search['songs'] as $k => $v) {
			array_push($ids, $v['id']);
		}
	}
	
	$data = array(
		'br'			=> 500000,
		'ids'			=> $ids,
		'csrf_token'	=> null,
	);
	$mp3 = json_decode(curl('http://music.163.com/weapi/song/enhance/player/url', $crypto->create_encrypt_data($data)), true);
	$mp3s = array();
	foreach ($mp3['data'] as $k => $v) {
		if (!empty($v['url'])) {
			$mp3s[($v['id'])] = str_replace('http:', 'https:', $v['url']);
		}
	}*/
	
	
	$ret = array();
	if (count($search['songs']) > 0) {
		foreach ($search['songs'] as $k => $v) {
			//if (!empty($mp3s[($v['id'])])) {
				$lyric = getLyric($v['id']);
				array_push($ret, array(
					"id" 		=> $v['id'],
					"artist"	=> $v['artists'][0]['name'],
					"title"		=> $v['name'],
					"album"		=> $v['album']['name'],
					"image"		=> getCurrentUrl()."?".$apiParam."&image=".bin2hex($v['album']['blurPicUrl'])."&id=".$v['id'],
					//"imageb64"	=> "data:image/jpg;base64,".base64_encode(getImage($v['album']['blurPicUrl'], $v['id'])),
					//"url"		=> str_replace(array('m7c.', 'm8c.'), array('m7.', 'm8.'), $mp3s[($v['id'])]),
					"url"		=> getCurrentUrl()."?".$apiParam."&mp3=".$v['id'],
					"lyric"		=> $lyric,
				));
			//}
		}
	}
	
	echo json_encode($ret, true);
	
	
	
	
	
	
	
	
	
	
	
	
	
} else if (isset($_REQUEST['lyric'])) {
	$fix = "";
	if (isset($_REQUEST['prx'])) {
		$fix = "|~DATA~|";
	}
	echo $fix.json_encode(getLyric($_REQUEST['lyric']), true).$fix;
	
} else if (isset($_REQUEST['mp3'])) {
	
	header("Content-Type: audio/mp3");
	
	$tmp = "tmp/163/".$_REQUEST['mp3'].".mp3";
	$out = "";
	if (!file_exists($tmp)) {
		
		$data = array(
			'br'			=> 500000,
			'ids'			=> '['.$_REQUEST['mp3'].']',
			'csrf_token'	=> null,
		);
		$u = json_decode(curl('http://music.163.com/weapi/song/enhance/player/url', $crypto->create_encrypt_data($data)), true)['data'][0]['url'];
		header("mp3u: ".$u);
		$u = str_replace(array('m7c.','m8.','m8c.','m9.','m9c.'), 'm7.', $u);
		header("mp3un: ".$u);
		$f = @curl($u);
		if (strlen($f) >= 500) {
			file_put_contents($tmp, $f);
		}
	}
		
	//set_eTagHeaders($tmp);
	//echo $out;
	smartReadFile($tmp, $_REQUEST['mp3'].".mp3",  'audio/mp3');
	
} else if (isset($_REQUEST['mp32'])) {
	
	$data = array(
		'br'			=> 500000,
		'ids'			=> '['.$_REQUEST['mp32'].']',
		'csrf_token'	=> null,
	);
	$u = json_decode(curl('http://music.163.com/weapi/song/enhance/player/url', $crypto->create_encrypt_data($data)), true)['data'][0]['url'];
	$u = str_replace(array('m7c.','m8.','m8c.','m9.','m9c.'), 'm7.', $u);
	echo $u;
	
} else if (isset($_REQUEST['image']) && isset($_REQUEST['id'])) {	
	
	header_remove('Cache-Control');
	header("Content-Type: image/webp");
	
	$im= getImage(hex2bin($_REQUEST['image']), $_REQUEST['id']);
	
	set_eTagHeaders("tmp/163/".$_REQUEST['id'].".webp");
	
	echo $im;
	
} else if (isset($_REQUEST['charts'])) {
			
	$json = file_get_contents("charts.json");
	echo str_replace('~~API_AUTH~~', $apiParam, $json);
	
} else if (isset($_REQUEST['update_charts']) && $_REQUEST['update_charts'] == CHART_UPDATE_SECRET) {
	
	/*
		Den update prozess hier unbedingt als cronjob auslagern.
		Bilder laden und compressen + Lyrics getten kann schon mal 3min dauern!
		*/
		
		$JSON = json_decode(curl('https://api.mtvnn.com/v2/DE/charts/288.json'), true);
		
		$Charts = array();
		foreach ($JSON['chart_instance']['chart_items'] as $k => $v) {
			$_REQUEST['limit']=5;
			
			$iTunesName = trim(preg_replace('/\s*\([^)]*\)/', '', $v['artist_name']." - ".$v['title']));
			
			$s = get163($iTunesName);
			if (is_array($s[0])) {
				
				$highPerc	= 0;
				$highNr		= 0;
				foreach ($s as $k1 => $v1) {
					similar_text(strtolower($iTunesName), strtolower($v1['artist']." - ".$v1['title']), $perc);
					if ($perc > $highPerc) {
						$highPerc	= $perc;
						$highNr		= $k1;
					}
				}
				
				$a = $s[$highNr];
				$a['url'] = getCurrentUrl()."?~~API_AUTH~~&mp3=".$s[$highNr]['id'];
				$a['mtv_name'] = strtolower($iTunesName);
				$a['163_name'] = strtolower(trim(preg_replace('/\s*\([^)]*\)/', '', $a['artist']." - ".$a['title'])));
				//$a['results'] = $s;
				
				$Charts[] = $a;
			} else {
				$Charts[] = array(
					"id" 		=> 0,
					"artist"	=> $v['artist_name'],
					"title"		=> $v['title'],
					"album"		=> "",
					"url"		=> false,
					"image"		=> 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAQAAAAAYLlVAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADdcAAA3XAUIom3gAAAAHdElNRQfhChgDMRL5c831AAAD60lEQVRo3s2Zz2sUZxjHP5nVqFmR0riCaxAkbAseErGHsngoLLj10Ehy8JIeFpQUcvDWQL0IHishgV76D4ggomz1oCakYNP20EJoghCx6dZLspuLkAVJRJN4mN1n35mdmfd9N5tMvu8hk+fX95l39v31vB3YIkmOXtLSYEXaf/zKW+uIxkhxlUessx3R1nnEVVLtpu5klFk2I6nVtslvjNLZHvIOhikZU6utxDAdO6XPMxdKsMYiM8ywyFqozRz51sl7mA58r0nyZEh6bJNkyDMZ2FfT9LRCn6XsCzTPTfq0fn3cZN7nWSZrS19gwxNikSEr/yEWPf4bFMydE4x7nJcZIWHdgwlGWPbEGTeLkqDocZugy5q8ji4mPLGKJimMt9pxIfB+zHG9ecO4Yv/TCUSWihK1EG3ayHahtcETiB4WlF7NhpuVlbdvH70bu9EL5bDY0yZZtgy1d6eDDPKm36llqL+vpgm6Q5nzJ3aFHlAG5Zx/mRpWpp3Wx70OXcrUNKwqOpVFZGTX6AFGlEVN2S+MKnO+/aRrg4SyRow2xLMitFtyWsGQcM3WRSnZbM3vOj0gi/UmKXCAyzg11YM9SaDO4nDZfXgsnaLfbrQDfcL3GCApG+3SntADMubWSTrkOFwT/2Lk3C0frBkO3UYx6kyHyTn0iviJ1vEs96iwxFigdowlKtzjrDZOg6kXbssXyWgdp8Q216TLiW5KGycjtrfhjvyT1Lptie39Ju190W1pXyUptncc0jVhVXusrPJent80aRuS91Q1kd6KRRpeyiSsx13JvL9J1y+6uwaR6hPyS6jWHmcM3Lq5QYkiFwO1FylS4obRSJipsVbtEmgfJAGHlZoovaOAtqizreyjBI5ph2H7kORYPYEDkgCk+dcqzCFOcooTrFFhlTdsW7+/L4EzhgmkGGCQLMc90g1+5ynPeGEQ4UwjARiQ8TupdXQo8JwPIdUQt/3PdY5o4kyK9YDNcnypqfAQ1lb5gaMRkZTlGMw2JJnAck1UW+KLkFieDckBoMg3NdUgC4EuX/GQT32y1/zNMius8gknSfMln3v0vfzJGD8FRBuUp6L7R7cpLfDO826vuMW5ALvTXOMvXz8E1QM8m1IXUdvy7z0By3ynOTl8zR+K/TtO+fQB2/Kog0mXpwb4o+FkdV1Owh844dGEHEzCj2afiXyDb43IXfTzD9ts87NPHnI0izqcTtW6/oIFvYvznPdJQg+nUcfzg1yhIDvnnSHieB57gQJiL9HsgyJV7GU6iL1QCbGXavdBsTr2cn1Qx+3xhYWLmK9sIPZLKxexXtu5iPni0kWsV7cN7MrltX0Xtfn6/iOkktOt5CwJdAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNy0xMC0yNFQwMzo0OToxOCswMjowMN6ANH0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTctMTAtMjRUMDM6NDk6MTgrMDI6MDCv3YzBAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAABJRU5ErkJggg==',
					//"imageb64"	=> "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAQAAAAAYLlVAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADdcAAA3XAUIom3gAAAAHdElNRQfhChgDMRL5c831AAAD60lEQVRo3s2Zz2sUZxjHP5nVqFmR0riCaxAkbAseErGHsngoLLj10Ehy8JIeFpQUcvDWQL0IHishgV76D4ggomz1oCakYNP20EJoghCx6dZLspuLkAVJRJN4mN1n35mdmfd9N5tMvu8hk+fX95l39v31vB3YIkmOXtLSYEXaf/zKW+uIxkhxlUessx3R1nnEVVLtpu5klFk2I6nVtslvjNLZHvIOhikZU6utxDAdO6XPMxdKsMYiM8ywyFqozRz51sl7mA58r0nyZEh6bJNkyDMZ2FfT9LRCn6XsCzTPTfq0fn3cZN7nWSZrS19gwxNikSEr/yEWPf4bFMydE4x7nJcZIWHdgwlGWPbEGTeLkqDocZugy5q8ji4mPLGKJimMt9pxIfB+zHG9ecO4Yv/TCUSWihK1EG3ayHahtcETiB4WlF7NhpuVlbdvH70bu9EL5bDY0yZZtgy1d6eDDPKm36llqL+vpgm6Q5nzJ3aFHlAG5Zx/mRpWpp3Wx70OXcrUNKwqOpVFZGTX6AFGlEVN2S+MKnO+/aRrg4SyRow2xLMitFtyWsGQcM3WRSnZbM3vOj0gi/UmKXCAyzg11YM9SaDO4nDZfXgsnaLfbrQDfcL3GCApG+3SntADMubWSTrkOFwT/2Lk3C0frBkO3UYx6kyHyTn0iviJ1vEs96iwxFigdowlKtzjrDZOg6kXbssXyWgdp8Q216TLiW5KGycjtrfhjvyT1Lptie39Ju190W1pXyUptncc0jVhVXusrPJent80aRuS91Q1kd6KRRpeyiSsx13JvL9J1y+6uwaR6hPyS6jWHmcM3Lq5QYkiFwO1FylS4obRSJipsVbtEmgfJAGHlZoovaOAtqizreyjBI5ph2H7kORYPYEDkgCk+dcqzCFOcooTrFFhlTdsW7+/L4EzhgmkGGCQLMc90g1+5ynPeGEQ4UwjARiQ8TupdXQo8JwPIdUQt/3PdY5o4kyK9YDNcnypqfAQ1lb5gaMRkZTlGMw2JJnAck1UW+KLkFieDckBoMg3NdUgC4EuX/GQT32y1/zNMius8gknSfMln3v0vfzJGD8FRBuUp6L7R7cpLfDO826vuMW5ALvTXOMvXz8E1QM8m1IXUdvy7z0By3ynOTl8zR+K/TtO+fQB2/Kog0mXpwb4o+FkdV1Owh844dGEHEzCj2afiXyDb43IXfTzD9ts87NPHnI0izqcTtW6/oIFvYvznPdJQg+nUcfzg1yhIDvnnSHieB57gQJiL9HsgyJV7GU6iL1QCbGXavdBsTr2cn1Qx+3xhYWLmK9sIPZLKxexXtu5iPni0kWsV7cN7MrltX0Xtfn6/iOkktOt5CwJdAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNy0xMC0yNFQwMzo0OToxOCswMjowMN6ANH0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTctMTAtMjRUMDM6NDk6MTgrMDI6MDCv3YzBAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAABJRU5ErkJggg==",
					"itunes"	=> $iTunesName,
				);
			}
		}
		
		$out = json_encode($Charts, true);
		file_put_contents("charts.json", $out);
		
		echo $out;
		
	
} else {
	echo 'ERROR';
}


function set_eTagHeaders($file) {
	$timestamp = filemtime($file);
    $gmt_mTime = gmdate('r', $timestamp); 
 
    header('Cache-Control: public');
    header('ETag: "' . md5($timestamp . $file) . '"');
    header('Last-Modified: ' . $gmt_mTime);
 
    if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) || isset($_SERVER['HTTP_IF_NONE_MATCH'])) {
        if ($_SERVER['HTTP_IF_MODIFIED_SINCE'] == $gmt_mtime || str_replace('"', '', stripslashes($_SERVER['HTTP_IF_NONE_MATCH'])) == md5($timestamp . $file)) {
            header('HTTP/1.1 304 Not Modified');
            exit();
        }
    }
}

function smartReadFile($location, $filename, $mimeType = 'application/octet-stream')
{
	if (!file_exists($location))
	{
		header ("HTTP/1.1 404 Not Found");
		return;
	}
	
	$size	= filesize($location);
	$time	= date('r', filemtime($location));
	
	$fm		= @fopen($location, 'rb');
	if (!$fm)
	{
		header ("HTTP/1.1 505 Internal server error");
		return;
	}
	
	$begin	= 0;
	$end	= $size - 1;
	
	if (isset($_SERVER['HTTP_RANGE']))
	{
		if (preg_match('/bytes=\h*(\d+)-(\d*)[\D.*]?/i', $_SERVER['HTTP_RANGE'], $matches))
		{
			$begin	= intval($matches[1]);
			if (!empty($matches[2]))
			{
				$end	= intval($matches[2]);
			}
		}
	}
	if (isset($_SERVER['HTTP_RANGE']))
	{
		header('HTTP/1.1 206 Partial Content');
	}
	else
	{
		header('HTTP/1.1 200 OK');
	}
	
	header("Content-Type: $mimeType"); 
	header('Cache-Control: public, must-revalidate, max-age=0');
	header('Pragma: no-cache');  
	header('Accept-Ranges: bytes');
	header('Content-Length:' . (($end - $begin) + 1));
	if (isset($_SERVER['HTTP_RANGE']))
	{
		header("Content-Range: bytes $begin-$end/$size");
	}
	header("Content-Disposition: inline; filename=$filename");
	header("Content-Transfer-Encoding: binary");
	header("Last-Modified: $time");
	
	$cur	= $begin;
	fseek($fm, $begin, 0);
	
	while(!feof($fm) && $cur <= $end && (connection_status() == 0))
	{
		print fread($fm, min(1024 * 16, ($end - $cur) + 1));
		$cur += 1024 * 16;
	}
}
?>