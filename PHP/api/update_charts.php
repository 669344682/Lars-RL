<?php
include("../CONFIG.php");
if (isset($_REQUEST['update_charts']) && $_REQUEST['update_charts'] == CHART_UPDATE_SECRET) {
	
	$u = str_replace('update_charts.php', '163.php', getCurrentUrl());
	$php = PHP_BINDIR.'/php';
	$tmpFile = uniqid().".sh";
	$bash = $php.' 163.php "CHARTUPDATE" 1 "'.$u.'";'."\r\n".$php.' 163.php "CHARTUPDATE" 2 "'.$u.'";'."\r\n".$php.' 163.php "CHARTUPDATE" 3 "'.$u.'";'."\r\n".$php.' 163.php "CHARTUPDATE" 4 "'.$u.'";'."\r\n".$php.' 163.php "CHARTUPDATE" 5 "'.$u.'";'."\r\n".'rm -- "$0";';
	file_put_contents($tmpFile, $bash);
	exec('chmod +x '.$tmpFile);
	$proc = exec('sh '.$tmpFile.' > /dev/null 2>&1 & echo $!;');
	echo 'Läuft ('.$proc.')! Prüfe in ca. 2-3min. ob <a href="./charts.json">charts.json</a> geschrieben wurde.';
}

function getCurrentUrl() {
	$url  = isset( $_SERVER['HTTPS'] ) && 'on' === $_SERVER['HTTPS'] ? 'https' : 'http';
	$url .= '://' . $_SERVER['SERVER_NAME'];
	$url .= in_array( $_SERVER['SERVER_PORT'], array('80', '443') ) ? '' : ':' . $_SERVER['SERVER_PORT'];
	$url .= strtok($_SERVER["REQUEST_URI"],'?');
	return $url;
}
?>