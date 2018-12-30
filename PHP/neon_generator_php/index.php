<?php
/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

if (!empty($_POST['c1'])) {
	$c1 = $_POST['c1'];
	$c2 = $_POST['c2'];
	$c3 = $_POST['c3'];


	$hex = bin2hex(file_get_contents('drei.dff'));
	$hex = str_replace('c1fc1f', $c1, $hex);
	$hex = str_replace('c2fc2f', $c2, $hex);
	$hex = str_replace('c3fc3f', $c3, $hex);
	
	header('Content-Type: application/octet-stream');
	header('Content-Disposition: attachment; filename=neon.dff');
	header('Content-Length: '.filesize('drei.dff'));
	
	echo hex2bin($hex);
	exit();
}
?>
<form method="post">
<input type="text" name="c1" placeholder="HEX #1 Vorne" /><br>
<input type="text" name="c2" placeholder="HEX #2 Mitte" /><br>
<input type="text" name="c3" placeholder="HEX #2 Hinten" /><br>
<input type="submit" value="DL" />
</form>